//
//  FacebookHelper.m
//  ShortShortFF
//
//  Created by Thanh Le on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookHelper.h"
#import "Util.h"

@implementation FacebookHelper
@synthesize delegate;

- (id)init {
    if (self = [super init]) {
        [self initFacebook];
    }
    return self;
}

- (void)initFacebook {
    permissions = [[NSArray alloc] initWithObjects:@"publish_stream", nil];
    facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:self];
    
    // Check and retrieve authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
}

#pragma mark - Facebook API Calls
/**
 * Make a Graph API Call to get information about the current logged in user.
 */
- (void)apiFQLIMe {
    // Using the "pic" picture since this currently has a maximum width of 100 pixels
    // and since the minimum profile picture size is 180 pixels wide we should be able
    // to get a 100 pixel wide version of the profile picture
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT uid, name, pic FROM user WHERE uid=me()", @"query",
                                   nil];
    [facebook requestWithMethodName:@"fql.query"
                          andParams:params
                      andHttpMethod:@"POST"
                        andDelegate:self];
}

- (void)apiGraphUserPermissions {
    [facebook requestWithGraphPath:@"me/permissions" andDelegate:self];
}

/**
 * Show the logged in menu
 */

- (void)showLoggedIn {
    //[self apiFQLIMe];
    if (delegate) {
        [delegate performSelector:@selector(fbActionAfterLogin)];
    }
}

/**
 * Show the logged in menu
 */

- (void)showLoggedOut {
    if (delegate) {
        [delegate performSelector:@selector(fbActionAfterLogout)];
    }
}

/**
 * Show the authorization dialog.
 */
- (void)login {
    if (![facebook isSessionValid]) {
        [facebook authorize:permissions];
    } else {
        [self showLoggedIn];
    }
}

/**
 * Invalidate the access token and clear the cookie.
 */
- (void)logout {
    [facebook logout];
}

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

#pragma mark - FBSessionDelegate Methods
/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
    [self showLoggedIn];
    
    [self storeAuthData:[facebook accessToken] expiresAt:[facebook expirationDate]];
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSLog(@"token extended");
    [self storeAuthData:accessToken expiresAt:expiresAt];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
    
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
    
    
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    //Remove cookie
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    
    [self showLoggedOut];
}

/**
 * Called when the session has expired.
 */
- (void)fbSessionInvalidated {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception"
                              message:@"Your session has expired."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
    [alertView release];
    [self fbDidLogout];
}

#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response.
 *
 * This callback gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    
    NSLog(@"Result: %@", result);
    // This callback can be a result of getting the user's basic
    // information or getting the user's permissions.
    if ([result objectForKey:@"id"]) {
        // If basic information callback, set the UI objects to
        // display this.
        [Util showMessage:@"Shared on Facebook successful!" withTitle:nil];
    } else {
        // Processing other
    }
    
    [[Util sharedUtil] hideLoadingView];
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    NSLog(@"Err code: %d", [error code]);
    [[Util sharedUtil] hideLoadingView];
}

- (void)requestLoading:(FBRequest *)request {
    [[Util sharedUtil] showLoadingView];
}
/*
 * Graph API: Upload a photo. By default, when using me/photos the photo is uploaded
 * to the application album which is automatically created if it does not exist.
 */
- (void)apiGraphUserPhotosPost:(UIImage *)img withMessage:(NSString *)message {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   img, @"picture",message,@"message",
                                   nil];
    
    [facebook requestWithGraphPath:@"me/photos"
                         andParams:params
                     andHttpMethod:@"POST"
                       andDelegate:self];
}

- (void)apiGraphUserLinksPost:(NSString*)link withMessage:(NSString*)message {
    [[Util sharedUtil] showLoadingView];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   link, @"link",message,@"message",
                                   nil];
    
    [facebook requestWithGraphPath:@"me/links"
                         andParams:params
                     andHttpMethod:@"POST"
                       andDelegate:self];
}

- (void)dealloc {
    [permissions release];
    [facebook release];
    [super dealloc];
}
@end
