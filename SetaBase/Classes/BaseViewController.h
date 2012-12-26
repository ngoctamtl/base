//
//  BaseViewController.h
//  SetaBase
//
//  Created by Thanh Le on 8/19/12.
//  Copyright (c) 2012 Setacinq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "APIClient.h"
#import "Session.h"

@interface BaseViewController : UIViewController

@property (nonatomic, weak) DataManager *dataManager;
@property (nonatomic, weak) APIClient *apiClient;
@property (nonatomic, weak) Session *session;
@property (nonatomic, weak) AppDelegate *appDelegate;
@end
