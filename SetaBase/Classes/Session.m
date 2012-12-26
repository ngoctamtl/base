//
//  Session.m
//  SetaBase
//
//  Created by Thanh Le on 8/15/12.
//  Copyright (c) 2012 Setacinq. All rights reserved.
//

#import "Session.h"
#import "NSObject+Extension.h"

#define SESSION_KEY @"SESSION_DATA"

@implementation Session
@synthesize userID;
@synthesize username;
@synthesize accessToken;
@synthesize isAuthenticated;
@synthesize deviceToken;
@synthesize userInfo;

+ (Session*)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id)init {
    if (self = [super init]) {
        //Init
        [self getData];
    }
    
    return self;
}

- (void)initData {
    self.userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    self.userID = nil;
    self.username = nil;
    self.deviceToken = nil;
    self.accessToken = nil;
    self.isAuthenticated = 0;
}

/*
 * Save properties to NSUserDefaults
 */
- (void)save {
    NSDictionary *allData = [self propertiesDictionary];
    DLog(@"Save session: %@", allData);
    [[NSUserDefaults standardUserDefaults] setObject:allData forKey:SESSION_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
 * Get all properties from NSUserDefaults
 */
- (void)getData {
    NSDictionary *allData = [[NSUserDefaults standardUserDefaults] objectForKey:SESSION_KEY];
    DLog(@"Session's saved data: %@", allData);
    
    if (allData && ![allData isEqual:[NSNull null]]) {
        NSArray *keyArray =  [allData allKeys];
        int count = [keyArray count];
        for (int i=0; i < count; i++) {
            id obj = [allData objectForKey:[keyArray objectAtIndex:i]];
            [self setValue:obj forKey:[keyArray objectAtIndex:i]];
        }
    } else {
        //Init some value
        [self initData];
    }
}
//////////////////////////////////////////////////////////////////////
//Implement all Session-related functions here


@end
