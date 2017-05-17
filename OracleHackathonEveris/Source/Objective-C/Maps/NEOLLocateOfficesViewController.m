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
#import "NEOLOffice.h"


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

@end

@implementation NEOLLocateOfficesViewController

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"MAP_TITLE", nil);
    
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
    //This line is to kill all the connections that can be in the stack
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
    
    //self.offices = [NEOLMockRequestManager mockLocateOfficesRequest];
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
            [locateOfficesViewController animateToShowViewOfficeInfo];
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

- (void)openGoogleMapsAndShowHowToArrive {
    NEOLAnnotationOfficeModel *annotationOffice = self.mapView.selectedAnnotations[0];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?daddr=%f,%f&saddr=%f,%f&directionsmode=walking,driving,transit,bicycling",
                                       self.lastKnownLocation.coordinate.latitude,
                                       self.lastKnownLocation.coordinate.longitude,
                                       annotationOffice.coordinate.latitude,
                                       annotationOffice.coordinate.longitude]];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)openMapsAndShowHowToArrive {
    if (self.mapView.selectedAnnotations.count>0){
        // Origin
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        
        // Destination
        NEOLAnnotationOfficeModel *annotationOffice = self.mapView.selectedAnnotations[0];
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:annotationOffice.coordinate addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:annotationOffice.office.address];
        
        // Options
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
}



#pragma mark - Actions

- (IBAction)buttonCenterTouchUpInside:(id)sender {
    if ([CLLocationManager locationServicesEnabled]) {
        [self.mapView setCenterCoordinate:kMadridCenter zoomLevel:5 animated:YES];
    } else {
       // [UIAlertView showAlertViewWithTitle:NSLocalizedString(@"ALERT", nil) andMessage:NSLocalizedString(@"MAP_ACTIVATE_LOCALIZATION", nil)];
    }
}

- (IBAction)buttonHowToArriveTouchUpInside:(id)sender {
    if ([CLLocationManager locationServicesEnabled] && self.lastKnownLocation) {
      
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
            if ([self conformsToProtocol:@protocol(NEOLLocateOfficesViewControllerDetailOfficeViewProtocol)]) {
                id<NEOLLocateOfficesViewControllerDetailOfficeViewProtocol> locateOfficesViewController =
                (id<NEOLLocateOfficesViewControllerDetailOfficeViewProtocol>)self;
                [locateOfficesViewController showMapsApplicationsChoice];
            }
        } else {
            [self openMapsAndShowHowToArrive];
        }
    } else {
       // [UIAlertView showAlertViewWithTitle:NSLocalizedString(@"ALERT", nil) andMessage:NSLocalizedString(@"MAP_ACTIVATE_LOCALIZATION", nil)];
    }
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self openMapsAndShowHowToArrive];
    } else if (buttonIndex == 1) {
        [self openGoogleMapsAndShowHowToArrive];
    }
}


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
        [self performLocateOfficesRequest];
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
            coordinateArray[i] = CLLocationCoordinate2DMake([[(NEOLOffice *)self.offices[i] latitude] doubleValue], [[(NEOLOffice *)self.offices[i] longitude] doubleValue]);
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
            self.routeLineView.fillColor = [UIColor greenColor];
            self.routeLineView.strokeColor = [UIColor greenColor];
            self.routeLineView.lineWidth = 3;
            
        }
        
        return self.routeLineView;
    }
    
    return nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        NSString *longitudeLabel = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        NSString *latitudeLabel = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
}


@end
