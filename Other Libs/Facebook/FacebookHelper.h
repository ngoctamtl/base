//
//  FacebookHelper.h
//  ShortShortFF
//
//  Created by Thanh Le on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@interface FacebookHelper : NSObject <FBRequestDelegate,FBDialogDelegate,FBSessionDelegate> {
    Facebook *facebook;
    NSArray *permissions;
}

@property (nonatomic, assign) id delegate;

- (void)login;
- (void)logout;
- (void)apiGraphUserLinksPost:(NSString*)link withMessage:(NSString*)message;
- (void)apiGraphUserPhotosPost:(UIImage *)img withMessage:(NSString *)message;
@end
