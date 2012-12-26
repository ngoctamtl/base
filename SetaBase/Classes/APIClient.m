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
		NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        DLog(@"Server response string: %@", responseString);
		
        NSError *error = nil;
        NSDictionary *responseDict;
		if (responseData) {
			responseDict = AFJSONDecode(responseData, &error);
		} else {
			responseDict = nil;
		}
		
        DLog(@"Server response dict: %@", responseDict);
		
		ResponseObject *responseObject = [[ResponseObject alloc] init];
		
		if (error) {
			DLog(@"Parse Error: %@",[error description]);
			//			responseObject.errorCode = kJSONParseError; //Error code for decode error
			//			responseObject.data = nil;
			//			responseObject.message = @"Server error!";
			
			responseObject.errorCode = kJSONSuccess;
			responseObject.data = nil;
			responseObject.message = responseString;
		} else {
			responseObject.errorCode = kJSONSuccess;
			responseObject.data = responseDict;
			responseObject.message = @"Success!";
		}
		
        block(responseObject);
    }
}

/*
 * Handle Failed Operation
 */
- (void)handleFailed:(NSError *)error block:(void (^)(ResponseObject *responseObject))block
{
    if (block) {
        ResponseObject *responseObject = [[ResponseObject alloc] init];
		
		responseObject.errorCode = error.code;
		responseObject.data = nil;
		responseObject.message = [error.userInfo objectForKey:@"message"];
		
		DLog(@"API Error: \n{\n\tURL: %@\n\tError: %d\n\tResponse: %@\n}",error.domain, error.code, responseObject.message);
        block(responseObject);
    }
}

/*
 * Process response
 */
- (void)processOperation:(AFHTTPRequestOperation *)operation withData:(id)responseObject block:(void (^)(ResponseObject *))block {
	//If response code != 200 --> Failed
	DLog(@"API: [%@]. Status code: [%d]", operation.request.URL.absoluteString, [operation.response statusCode]);
	
	if ([operation.response statusCode] != kJSONSuccess) {
		NSError *errorParser = nil;
        NSDictionary *responseDict;
		if (operation.responseData) {
			responseDict = AFJSONDecode(operation.responseData, &errorParser);
		} else {
			responseDict = nil;
		}
		
        DLog(@"Server response dict: %@", responseDict);
		NSString *message = @"";
		if (responseDict && !errorParser) {
			message = [responseDict objectForKey:@"error"];
		} else {
			message = operation.responseString;
		}
		
		NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"message", nil];
		
		NSError *error = [[NSError alloc] initWithDomain:operation.request.URL.absoluteString code:operation.response.statusCode userInfo:userInfo];
		[self handleFailed:error block:block];
		return;
	}
	[self handleSuccess:responseObject block:block];
}

//Implement all API functions here
// Sample //////////////////
//- (void)loginWithFBToken:(NSString *)token
//				   block:(void (^)(ResponseObject *responseObject))block
//{
//	NSString *path = kAPIURLLoginFB;
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//							token, kJSONFacebookToken,
//							nil];
//	DLog(@"Params: %@", params);
//	
//    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self processOperation:operation withData:responseObject block:block];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//		[self processOperation:operation withData:nil block:block];
//    }];
//	
//}

////////////////////////////



@end
