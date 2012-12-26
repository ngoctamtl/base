//
//  APIClient.m
//  SetaBase
//
//  Created by Thanh Le on 8/9/12.
//  Copyright (c) 2012 Setacinq. All rights reserved.
//

#import "APIClient.h"

@implementation APIClient

+ (APIClient *)sharedClient {
    static APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    return self;
}

/*
 * Handle Success Operation
 */
- (void)handleSuccess:(id)responseData block:(void (^)(ResponseObject *responseObject))block
{
    if (block) {
        DLog(@"Server response string: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        NSError *error;
        NSDictionary *responseDict = AFJSONDecode(responseData, &error);
        DLog(@"Server response dict: %@", responseDict);
		
		ResponseObject *responseObject = [[ResponseObject alloc] init];
		
		if (error) {
			DLog(@"Parse Error: %@",[error description]);
			responseObject.errorCode = @""; //Error code for decode error
			responseObject.data = nil;
			responseObject.message = @"";
		} else {
			responseObject.errorCode = @"";
			responseObject.data = nil;
			responseObject.message = @"";
		}
		
        block(responseObject);
    }
}

/*
 * Handle Failed Operation
 */
- (void)handleFailed:(NSError *)error block:(void (^)(ResponseObject *responseObject))block
{
    DLog(@"%@", [error localizedDescription]);
    if (block) {
        ResponseObject *responseObject = [[ResponseObject alloc] init];

		responseObject.errorCode = @""; //Error code for network error
		responseObject.data = nil;
		responseObject.message = @"";
		
        block(responseObject);
    }
}

//Implement all API functions here
// Sample //////////////////
/*
- (void)registerPresentWithId:(NSNumber *)presentId block:(void (^)(ResponseObject *responseObject))block
{
    NSString *path = [NSString stringWithFormat:@"api/present/%d/register", [presentId intValue]];
    NSString *ticketType = [[NSUserDefaults standardUserDefaults] valueForKey:kCurrentTicketType];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken], kJsonAccessToken,
                            [presentId stringValue], @"present_id",
                            ticketType, @"entryType",
                            nil];
    DLog(@"%@", params);
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseData) {
        [self handleSuccess:responseData block:block];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"%@", [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding]);
        [self handleFailed:error block:block];
    }];
}
 */
////////////////////////////



@end
