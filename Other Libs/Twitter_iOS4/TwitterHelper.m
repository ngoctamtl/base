//
//  TwitterHelper.m
//  ShortShortFF
//
//  Created by Thanh Le on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterHelper.h"
#import "Util.h"

@implementation TwitterHelper
@synthesize delegate;

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)login {
    if (![self checkTWLogin]) {
        [self connectWithTwitter];
    } else {
        if (delegate) {
            [delegate performSelector:@selector(twActionAfterLogin)];
        }
    }
}

-(void) connectWithTwitter
{
    NSLog(@"Connect with Twitter account");
    
    oAuth = [[OAuth alloc] initWithConsumerKey:OAUTH_CONSUMER_KEY andConsumerSecret:OAUTH_CONSUMER_SECRET];
    
    TwitterDialog *td = [[TwitterDialog alloc] init];
    td.twitterOAuth = oAuth;
    td.delegate = self;
    td.logindelegate = self;
    
    [td show];
    [td release];
}

//Twitter Delegates
- (void)twitterDidLogin {
    //Save Details
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:oAuth.oauth_token forKey:@"twAccessToken"];
    [userDef setObject:oAuth.oauth_token_secret forKey:@"twAccessSecret"];
    [userDef synchronize];
    
    if (delegate) {
        [delegate performSelector:@selector(twActionAfterLogin)];
    }
}

- (BOOL)checkTWLogin {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if ([userDef objectForKey:@"twAccessToken"]) {
        oAuth = [[OAuth alloc] initWithConsumerKey:OAUTH_CONSUMER_KEY andConsumerSecret:OAUTH_CONSUMER_SECRET];
        oAuth.oauth_token = [userDef objectForKey:@"twAccessToken"];
        oAuth.oauth_token_secret = [userDef objectForKey:@"twAccessSecret"];
        return YES;
    }
    return NO;
}

-(void)twitterDidNotLogin:(BOOL)cancelled {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"There was a unknown error authenticating with Twitter." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

/***** SEND status + image on Twitter*********/

- (void)sendStatus:(NSString *)status {
    [[Util sharedUtil] showLoadingView];
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:OAUTH_CONSUMER_KEY secret:OAUTH_CONSUMER_SECRET];
    OAToken *token = [[OAToken alloc] initWithKey:oAuth.oauth_token secret:oAuth.oauth_token_secret];
    
    OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/statuses/update.json"]
                                                                    consumer:consumer
                                                                       token:token
                                                                       realm:nil
                                                           signatureProvider:nil];
    
    [consumer release];
    [token release];
    
    [oRequest setHTTPMethod:@"POST"];
    
    OARequestParameter *statusParam = [[OARequestParameter alloc] initWithName:@"status"
                                                                         value:status];
    OARequestParameter *messageParam = [[OARequestParameter alloc] initWithName:@"include_entities"
                                                                         value:@"true"];
    NSArray *params = [NSArray arrayWithObjects:statusParam, messageParam, nil];
    [oRequest setParameters:params];
    [statusParam release];
    [messageParam release];
    
    OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
                                                                                          delegate:self
                                                                                 didFinishSelector:@selector(sendStatusTicket:didFinishWithData:)
                                                                                   didFailSelector:@selector(sendStatusTicket:didFailWithError:)];	
    
    [fetcher start];
    [oRequest release];
}

- (void)sendStatusTicket:(OAServiceTicket*)ticket didFinishWithData:(NSData*)data {
    NSString* newStr = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    NSLog(@"Send status ok. Data %@", newStr);
    [[Util sharedUtil] hideLoadingView];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *dataResponse = [parser objectWithData:data];
    if (dataResponse != nil) {
        [[Util sharedUtil] showMessage:@"Tweeted successful!" withTitle:nil];
    }
}

- (void)sendStatusTicket:(OAServiceTicket*)ticket didFailWithError:(NSError*)error {
    NSLog(@"Error when tweet");
    [[Util sharedUtil] hideLoadingView];
    [[Util sharedUtil] showMessage:@"Tweeted fail!" withTitle:@"Error"];
}

- (void)dealloc {
    [oAuth release];
    [super dealloc];
}
@end
