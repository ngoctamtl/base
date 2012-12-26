//
//  ViewController.m
//  Classes
//
//  Created by Thanh Le on 8/9/12.
//  Copyright (c) 2012 Setacinq. All rights reserved.
//

#import "ViewController.h"
#import "Session.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    ///////// SESSION SAMPLE ////////////
    self.session.isAuthenticated = YES;
    self.session.userID = @"123";
    [self.session.userInfo setObject:@"Hola" forKey:@"fullName"];
    [self.session save];
    /////////////////////////////////////
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
