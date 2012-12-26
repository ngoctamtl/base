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
#define kJSONSuccess					200
#define kJSONInternalNetworkError       500
#define kJSONParseError					-1
#define kJSONUnauthorizedError			401
#define kJSONForbiddenError				403
#define kJSONPaymentRequiredError		402
#define kJSONPreconditionFailedError	412
#define kJSONRequestTimeoutError		408
#define kJSONConflictError				409
#define kJSONBadRequestError			400
#define kJSONNotFoundError				404
#define kJSONNoInternetConnection       0

@interface APIClient : AFHTTPClient

+ (APIClient *)sharedClient;

//Define all API functions here

// Sample /////////////////////
//- (void)loginWithFBToken:(NSString *)token
//				   block:(void (^)(ResponseObject *responseObject))block;
///////////////////////////////

@end
