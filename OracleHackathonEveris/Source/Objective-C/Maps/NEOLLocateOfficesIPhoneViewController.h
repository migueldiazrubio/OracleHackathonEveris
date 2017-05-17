//
//  NEOLLocateOfficesIPhoneViewController.h
//  NEOL
//
//  Created by Jose Miguel Benedicto Ruiz on 07/07/14.
//  Copyright (c) 2014 ameu8. All rights reserved.
//

#import "NEOLLocateOfficesViewController.h"

@class A8RevealSlidingViewController;

@interface NEOLLocateOfficesIPhoneViewController : NEOLLocateOfficesViewController <UISearchBarDelegate, NEOLLocateOfficesViewControllerDetailOfficeViewProtocol, UISearchResultsUpdating, UISearchControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintVerticalSpaceFromBottomViewOfficeInfoToView;
@end
