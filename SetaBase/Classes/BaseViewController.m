//
//  BaseViewController.m
//  SetaBase
//
//  Created by Thanh Le on 8/19/12.
//  Copyright (c) 2012 Setacinq. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)initProperties {
    self.dataManager = [DataManager sharedInstance];
    self.apiClient = [APIClient sharedClient];
    self.session = [Session sharedInstance];
	self.appDelegate = [Util appDelegate];
}

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        [self initProperties];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initProperties];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
