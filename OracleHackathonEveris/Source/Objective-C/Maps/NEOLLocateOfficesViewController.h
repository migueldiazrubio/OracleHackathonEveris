//
//  NEOLLocateOfficesViewController.h
//  NEOL
//
//  Created by José Miguel Benedicto Ruiz on 29/04/14.
//  Copyright (c) 2014 ameu8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Poi.h"

#define kOfficeAnnotationViewIdentifier @"NEOLOfficeIdentifier"
#define kUserAnnotationViewIdentifier @"NEOLUserIdentifier"

#define kMadridCenter CLLocationCoordinate2DMake(40.416944, -3.703611)
#define KLatitudMadrid 40.5211523
#define KLongitudMadrid -3.8913309
#define kInitZoomLevel 10
#define kSearchZoomLevel 13
#define kMinimumSearchLength 3

@protocol NEOLLocateOfficesViewControllerDetailOfficeViewProtocol <NSObject>
- (void)setViewOfficeInfoWithOffice:(Poi *)office;
- (void)animateToShowViewOfficeInfo;
- (void)animateToHideViewOfficeInfo;
- (void)showMapsApplicationsChoice;
@end

@interface NEOLLocateOfficesViewController : UIViewController <MKMapViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *buttonCenter;

@property (strong, nonatomic) IBOutlet UITableView *tableViewResults;
@property (strong, nonatomic) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UIView *viewOfficeInfo;
@property (weak, nonatomic) IBOutlet UIView *viewOfficeType;
@property (weak, nonatomic) IBOutlet UILabel *labelOfficeType;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewOfficeType;
@property (weak, nonatomic) IBOutlet UIView *viewOfficeContent;
@property (weak, nonatomic) IBOutlet UILabel *labelOfficeTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelOfficeAddress;
@property (weak, nonatomic) IBOutlet UIButton *buttonHowToArrive;

@property (nonatomic) CGFloat maximumHeightSearchResultsTable;

@property (nonatomic, strong) NSArray *offices; // [NEOLOffice]
@property (nonatomic, strong) NSArray *annotations; // [NEOLAnnotationsOfficeModel]
@property (nonatomic, strong) NSArray *results;

@property (nonatomic, strong) NSString *searchText;


- (IBAction)buttonCenterTouchUpInside:(id)sender;
- (IBAction)buttonHowToArriveTouchUpInside:(id)sender;

@end
