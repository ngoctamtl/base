//
//  DataManager.m
//  SetaBase
//
//  Created by Thanh Le on 8/15/12.
//  Copyright (c) 2012 Setacinq. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

+ (DataManager*)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id)init {
    if (self = [super init]) {
        //Init
        
    }
    
    return self;
}

//////////////////////////////////////////////////////////////////////
//Implement all DB-related functions here

@end
