//
//  TwitterHelper.h
//  ShortShortFF
//
//  Created by Thanh Le on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Twitter.h"

@interface TwitterHelper : NSObject <TwitterDialogDelegate, TwitterLoginDialogDelegate> {
    OAuth *oAuth;
}

@property (nonatomic, assign) id delegate;

- (void)login;
- (void)sendStatus:(NSString *)status;
@end
