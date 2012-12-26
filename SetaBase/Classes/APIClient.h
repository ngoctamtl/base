//
//  APIClient.h
//  SetaBase
//
//  Created by Thanh Le on 8/9/12.
//  Copyright (c) 2012 Setacinq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPClient.h"
#import "AFJSONUtilities.h"
#import "AFImageRequestOperation.h"
#import "ResponseObject.h"

//JSON Keys

@interface APIClient : AFHTTPClient

+ (APIClient *)sharedClient;

//Define all API functions here

// Sample /////////////////////
//- (void)getLocationWithAddress:(NSString *)address block:(void (^)(ResponseObject *responseObject))block;
///////////////////////////////

@end
