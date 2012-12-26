//
//  Session.h
//  SetaBase
//
//  Created by Thanh Le on 8/15/12.
//  Copyright (c) 2012 Setacinq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session : NSObject

@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, assign) BOOL isAuthenticated;
@property (nonatomic, retain) NSString *deviceToken;
@property (nonatomic, retain) NSMutableDictionary *userInfo;

+ (Session *)sharedInstance;

- (void)save;
- (void)getData;
////////////////////////////////////////////////////
//Define all Session-related functions here
@end
