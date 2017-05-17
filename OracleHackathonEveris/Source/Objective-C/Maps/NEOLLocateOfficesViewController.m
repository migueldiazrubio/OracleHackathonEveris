//
//  NEOLLocateOfficesViewController.m
//  NEOL
//
//  Created by José Miguel Benedicto Ruiz on 29/04/14.
//  Copyright (c) 2014 ameu8. All rights reserved.
//

#import "NEOLLocateOfficesViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>
#import "NEOLMockRequestManager.h"
#import "NEOLAnnotationOfficeModel.h"
#import "NEOLAnnotationOfficeView.h"
#import "MKMapView+ZoomLevel.h"
#import "GGeocodeResponse.h"
#import "LatLngPoint.h"
#import "OracleHackathonEveris-swift.h"

@interface NEOLLocateOfficesViewController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *lastKnownLocation;
@property (nonatomic) BOOL locationServicesEnabled;

@property (nonatomic) NSInteger zoomLevel;
@property (nonatomic) CLLocationDistance radius;

@property (nonatomic, strong) NSString *spanishString;

@property (nonatomic) BOOL mapReadyToLocateOffices;

@property (nonatomic, retain) MKPolyline *routeLine; //your line
@property (nonatomic, retain) MKPolylineRenderer *routeLineView; //overlay view
@property (nonatomic, strong) CLGeocoder *ceo;
@property (nonatomic, strong) Poi * selectedPoi;

@end

@implementation NEOLLocateOfficesViewController

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"MAPA", nil);
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    if (![CLLocationManager locationServicesEnabled]) {
        
        [self initializeMapViewCenteringInCoordinate:kMadridCenter];
    }
    
    [self.buttonHowToArrive setExclusiveTouch:YES];
    [self.buttonCenter setExclusiveTouch:YES];
    
    [self performLocateOfficesRequest];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - MapView Utils

- (void)initializeMapViewCenteringInCoordinate:(CLLocationCoordinate2D)coordinate {
    [self.mapView setCenterCoordinate:coordinate zoomLevel:kInitZoomLevel animated:YES];
    self.mapView.showsUserLocation = YES;
}

- (NSArray*) getCornerCoordinatesOfMap:(MKMapView*)mapView {
    //To calculate the search bounds...
    //First we need to calculate the corners of the map so we get the points
    CGPoint nePoint = CGPointMake(self.mapView.bounds.origin.x + mapView.bounds.size.width, mapView.bounds.origin.y);
    CGPoint swPoint = CGPointMake((self.mapView.bounds.origin.x), (mapView.bounds.origin.y + mapView.bounds.size.height));
    
    //Then transform those point into lat,lng values
    CLLocationCoordinate2D neCoord;
    neCoord = [mapView convertPoint:nePoint toCoordinateFromView:mapView];
    
    CLLocationCoordinate2D swCoord;
    swCoord = [mapView convertPoint:swPoint toCoordinateFromView:mapView];
    
    // Convert to CLLocation object to insert in the array
    CLLocation *neCorner = [[CLLocation alloc] initWithLatitude:neCoord.latitude longitude:neCoord.longitude];
    CLLocation *swCorner = [[CLLocation alloc] initWithLatitude:swCoord.latitude longitude:swCoord.longitude];
    
    return @[neCorner, swCorner];
}

- (CLLocationDistance)radiusFromCoordinateRegion {
    NSArray *locations = [self getCornerCoordinatesOfMap:self.mapView];
    return [(CLLocation *)locations[0] distanceFromLocation:(CLLocation *)locations[1]] / 2;
}

- (void)createOfficeAnnotations {
    NSMutableArray *annotations = [NSMutableArray array];
    NSMutableArray *response = (NSMutableArray *)self.offices;
    Poi *office;
    for (office in response) {
        [annotations addObject:[[NEOLAnnotationOfficeModel alloc] initWithOffice:office]];
    }
    self.annotations = [NSArray arrayWithArray:annotations];
}

- (void)updateOffices {
    [self.mapView removeAnnotations:self.annotations];
    [self createOfficeAnnotations];
    [self.mapView addAnnotations:self.annotations];
}


#pragma mark - Connections

- (void)performLocateOfficesRequest {
    
    self.ceo= [[CLGeocoder alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    CLLocationCoordinate2D coordinate;
    
    coordinate.latitude=self.locationManager.location.coordinate.latitude;
    coordinate.longitude=self.locationManager.location.coordinate.longitude;
    
    Poi *myPosition = [[Poi alloc] init];
    //    myPosition.latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    //    myPosition.longitude =[NSString stringWithFormat:@"%f",coordinate.longitude];
    
    //TODO conseguir obtener correctamente mi posición
    myPosition.latitude = [NSString stringWithFormat:@"%f",KLatitudMadrid];
    myPosition.longitude =[NSString stringWithFormat:@"%f",KLongitudMadrid];
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    [mutableArray addObject:myPosition];
    [mutableArray addObjectsFromArray:self.offices];
    
    self.offices = nil;
    self.offices = [[NSArray alloc] initWithArray:mutableArray];
    
    self.offices = [self sortedArrayForDistance:self.offices];
    
    if (self.offices.count >0){
        [self updateOffices];
        [self drawLine];
        
        
    }
}

- (void)performGeolocalizationRequest {
   
}


#pragma mark - Detail Office View Management

- (void)showOfficeDetailWithAnnotationView:(MKAnnotationView *)view {
    NEOLAnnotationOfficeView *officeAnnotationView = (NEOLAnnotationOfficeView *)view;
    NEOLAnnotationOfficeModel *officeAnnotation = (NEOLAnnotationOfficeModel *) officeAnnotationView.annotation;
    if (![officeAnnotation isKindOfClass:[MKUserLocation class]]){
        Poi *office = officeAnnotation.office;
        
        if ([self conformsToProtocol:@protocol(NEOLLocateOfficesViewControllerDetailOfficeViewProtocol)]) {
            id<NEOLLocateOfficesViewControllerDetailOfficeViewProtocol> locateOfficesViewController =
            (id<NEOLLocateOfficesViewControllerDetailOfficeViewProtocol>)self;
            [locateOfficesViewController setViewOfficeInfoWithOffice:office];
            self.selectedPoi = office;
            [locateOfficesViewController animateToShowViewOfficeInfo];
            
            MKPointAnnotation *point=[[MKPointAnnotation alloc]init];
            point.coordinate = CLLocationCoordinate2DMake([[(Poi *)office latitude] doubleValue], [[(Poi *)office longitude] doubleValue]);
             //[self animateAnnotation:point];
            
//            [(NEOLAnnotationOfficeView *) view setCoordinate:CLLocationCoordinate2DMake([[(Poi *)office latitude] doubleValue], [[(Poi *)office longitude] doubleValue])];
            
            [(NEOLAnnotationOfficeView *) view setCoordinate:CLLocationCoordinate2DMake(33,33)];
        }
    }
}

- (void)hideOfficeDetailWithAnnotationView {
    if ([self conformsToProtocol:@protocol(NEOLLocateOfficesViewControllerDetailOfficeViewProtocol)]) {
        id<NEOLLocateOfficesViewControllerDetailOfficeViewProtocol> locateOfficesViewController =
        (id<NEOLLocateOfficesViewControllerDetailOfficeViewProtocol>)self;
        [locateOfficesViewController animateToHideViewOfficeInfo];
    }
}


#pragma mark - Open External Maps Applications

#pragma mark - Actions

- (IBAction)buttonCenterTouchUpInside:(id)sender {
    if ([CLLocationManager locationServicesEnabled]) {
        [self.mapView setCenterCoordinate:kMadridCenter zoomLevel:10 animated:YES];
    } else {
       // [UIAlertView showAlertViewWithTitle:NSLocalizedString(@"ALERT", nil) andMessage:NSLocalizedString(@"MAP_ACTIVATE_LOCALIZATION", nil)];
    }
}

- (IBAction)buttonHowToArriveTouchUpInside:(id)sender {
    
//    MKPointAnnotation *point=[[MKPointAnnotation alloc]init];
//    [self animateAnnotation:point];
    
    
}


//#pragma mark - UIActionSheetDelegate
//
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 0) {
//        [self openMapsAndShowHowToArrive];
//    } else if (buttonIndex == 1) {
//        [self openGoogleMapsAndShowHowToArrive];
//    }
//}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.lastKnownLocation = [locations lastObject];
    if (!self.locationServicesEnabled) {
        self.locationServicesEnabled = [CLLocationManager locationServicesEnabled];
        [self initializeMapViewCenteringInCoordinate:self.lastKnownLocation.coordinate];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
}


#pragma mark - MKMapKitDelegate

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView {
    // Check authorization status (with class method)
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // User has never been asked to decide on location authorization
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"Requesting when in use auth");
        [self.locationManager requestWhenInUseAuthorization];
    }
    // User has denied location use (either for this app or for all apps
    else if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"Location services denied");
       // [UIAlertView showAlertViewWithTitle:NSLocalizedString(@"ALERT", nil) andMessage:NSLocalizedString(@"MAP_ACTIVATE_LOCALIZATION", nil)];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annotationView;
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kUserAnnotationViewIdentifier];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kUserAnnotationViewIdentifier];
        }
        annotationView.image = [UIImage imageNamed:@"offices_img_point"];
    } else {
        annotationView = (NEOLAnnotationOfficeView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kOfficeAnnotationViewIdentifier];
        if (!annotationView) {
            // Create a new annotation
            annotationView = [[NEOLAnnotationOfficeView alloc] initWithAnnotation:annotation reuseIdentifier:kOfficeAnnotationViewIdentifier];
        } else {
            annotationView.annotation = annotation;
        }
        
    }
    annotationView.bounds = CGRectMake(0, 0, annotationView.image.size.width, annotationView.image.size.height);
    annotationView.centerOffset = CGPointMake(0, -nearbyint(annotationView.image.size.height * 0.5));
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if (![view isKindOfClass:[MKUserLocation class]]) {
        
        [self showOfficeDetailWithAnnotationView:view];
        
    }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if (![view isKindOfClass:[MKUserLocation class]]) {
        [self hideOfficeDetailWithAnnotationView];
    }
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    // Prevent to load the locations until the map has finished rendering
    if (self.mapReadyToLocateOffices)
    {
        
        // Apply the zoom level and radius to the map view
        self.zoomLevel = [self.mapView getZoomLevel];
        self.radius = [self radiusFromCoordinateRegion];
        
        // Search for offices
       // [self performLocateOfficesRequest];
    }
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    // If the map has never been ready, now it is time to be ready
    if (!self.mapReadyToLocateOffices) {
        // Set the map ready to search for offices
        self.mapReadyToLocateOffices = TRUE;
        
        // Force the search of the offices
        [self mapView: mapView regionDidChangeAnimated:TRUE];
    }
}


-(void)drawLine{
    
    if (self.offices.count > 1) {
        CLLocationCoordinate2D coordinateArray[self.offices.count];
        
        for (int i = 0; i< self.offices.count; i++) {
            coordinateArray[i] = CLLocationCoordinate2DMake([[(Poi *)self.offices[i] latitude] doubleValue], [[(Poi *)self.offices[i] longitude] doubleValue]);
        }
        
        self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:self.offices.count];
        /***********************************************/
        
        [_mapView addOverlay:self.routeLine];
    }
    
    
}


-(MKPolylineRenderer *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if(overlay == self.routeLine)
    {
        if(nil == self.routeLineView)
        {
            self.routeLineView = [[MKPolylineRenderer alloc] initWithPolyline:self.routeLine] ;
            self.routeLineView.fillColor = [UIColor colorWithHexString:@"98b433"];
            self.routeLineView.strokeColor = [UIColor colorWithHexString:@"333639"];
            self.routeLineView.lineWidth = 3;
            
        }
        
        return self.routeLineView;
    }
    
    return nil;
}


- (NSArray *)sortedArrayForDistance: (NSArray *)array{
        NSMutableArray *arrayAux = [[NSMutableArray alloc] initWithArray:array];
        NSMutableArray *sortedArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableDictionary *dictionaryOfDistances = [[NSMutableDictionary alloc] init];
    
        [sortedArray addObject:arrayAux[0]];
        [arrayAux removeObjectAtIndex:0];
    while (sortedArray.count != array.count) {
        Poi *current = [[Poi alloc] init];
        current = [sortedArray lastObject];
        CLLocation *locA = [[CLLocation alloc] initWithLatitude:[[current latitude] doubleValue] longitude:[[current longitude] doubleValue]];
        
        for (int i = 0 ; i< arrayAux.count; i++) {
            
            CLLocation *locB = [[CLLocation alloc] initWithLatitude:[[(Poi *)[arrayAux objectAtIndex:i] latitude] doubleValue] longitude:[[(Poi *)[arrayAux objectAtIndex:i] longitude] doubleValue]];
            
            CLLocationDistance distance = [locA distanceFromLocation:locB];
            
            [dictionaryOfDistances setObject:arrayAux[i] forKey:[NSNumber numberWithDouble: distance]];
            
        }
        
        [sortedArray addObject:[self sortDistances:dictionaryOfDistances]];
        [arrayAux removeObject:[self sortDistances:dictionaryOfDistances]];
    }
    
    
    
    return sortedArray;
}
- (IBAction)buttonPoiPressed:(id)sender {

    MCSService * service = [[MCSService alloc] init];
    self.selectedPoi.status = @"1";
    [service modifyPoiWithPoi:self.selectedPoi completion:^(BOOL success)  {
        if (success == true) {
            [self performSegueWithIdentifier:@"showFinishSegue" sender:self];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Ha habido algun problema con la conexion" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            alert.show;
        }
    }];
}

-(Poi *)sortDistances: (NSDictionary *)dict{
    NSArray *sortedKeys = [[dict allKeys] sortedArrayUsingSelector: @selector(compare:)];
    NSMutableArray *sortedValues = [NSMutableArray array];
    for (NSString *key in sortedKeys)
        [sortedValues addObject: [dict objectForKey: key]];
    
    
    return [sortedValues objectAtIndex:0];
}


-(void) animateAnnotation:(MKPointAnnotation*)annotation{
    
    CLLocationCoordinate2D newCordinates;
    //for(int i=0;i<self.offices.count;i++){
        newCordinates=CLLocationCoordinate2DMake([[(Poi *)self.offices[1] latitude] doubleValue], [[(Poi *)self.offices[1] longitude] doubleValue]);
        [UIView
         animateWithDuration:2.0
         delay:0.0
         options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             annotation.coordinate = newCordinates;
         }
         completion:nil];
    
    [self.mapView reloadInputViews];
    [self.mapView setNeedsDisplay];
    //}
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    InfoScreenViewController *vC = [segue destinationViewController];
    vC.officeDoneList = self.offices;
    
}

@end
