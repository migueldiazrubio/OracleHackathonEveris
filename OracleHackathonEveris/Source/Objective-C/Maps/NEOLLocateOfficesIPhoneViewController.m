//
//  NEOLLocateOfficesIPhoneViewController.m
//  NEOL
//
//  Created by Jose Miguel Benedicto Ruiz on 07/07/14.
//  Copyright (c) 2014 ameu8. All rights reserved.
//

#import "NEOLLocateOfficesIPhoneViewController.h"
#import "NEOLLocateOfficesViewController.h"

#import "NEOLAnnotationOfficeModel.h"
#import "NEOLAnnotationOfficeView.h"

#import "MKMapView+ZoomLevel.h"

#import "GGeocodeResponse.h"
#import "LatLngPoint.h"

#import "NEOLOffice.h"


#define kPOITypeOffice  @"OFICINA"
#define kPOITypeGarage  @"PDS"

@interface NEOLLocateOfficesIPhoneViewController ()

@end

@implementation NEOLLocateOfficesIPhoneViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationController.extendedLayoutIncludesOpaqueBars = YES;
    
    self.maximumHeightSearchResultsTable = 44.0f * 6;
    
    self.layoutConstraintVerticalSpaceFromBottomViewOfficeInfoToView.constant = 0;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //This line is to kill all the connections that can be in the stack
}

#pragma mark - NEOLLocateOfficesViewControllerDetailOfficeViewProtocol

- (void)setViewOfficeInfoWithOffice:(NEOLOffice *)office {
    if ([office.type isEqualToString:kPOITypeOffice]) {
        self.imageViewOfficeType.image = [UIImage imageNamed:@"offices_ico_building"];
        //self.viewOfficeType.backgroundColor = [UIColor colorWithHexString:@"338cce"];
        self.labelOfficeType.text = NSLocalizedString(@"OFFICE", nil);
    } else if ([office.type isEqualToString:kPOITypeGarage]) {
        self.imageViewOfficeType.image = [UIImage imageNamed:@"offices_ico_garage"];
        //self.viewOfficeType.backgroundColor = [UIColor colorWithHexString:@"f88106"];
        self.labelOfficeType.text = NSLocalizedString(@"GARAGE", nil);
    }
    
    self.labelOfficeTitle.text = office.name;
    self.labelOfficeAddress.text = [office.physicalAddress description];
    
}

- (void)animateToShowViewOfficeInfo {
    // Update Constraints
    self.layoutConstraintVerticalSpaceFromBottomViewOfficeInfoToView.constant = - self.viewOfficeInfo.bounds.size.height;
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)animateToHideViewOfficeInfo {
    self.layoutConstraintVerticalSpaceFromBottomViewOfficeInfoToView.constant = 0;
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)showMapsApplicationsChoice {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"MAP_CHOOSE_APP", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"BTN_CANCEL", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"MAP_MAPS_APP_TITLE", nil), @"Google Maps", nil];
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}




@end
