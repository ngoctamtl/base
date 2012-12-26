//
//  Util.h
//  
//
//  Created by Thanh Le on 12/1/11.
//  Copyright 2011 SETA:CINQ Vietnam., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface Util : NSObject {
    MBProgressHUD *HUD;
}

+ (Util *) sharedUtil;
+ (AppDelegate *)appDelegate;
+ (BOOL)validateEmail:(NSString*)email;
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title;
+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)dateFormat;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat;

+ (NSString *)getString:(NSInteger)i;
+ (NSNumber *)getSafeInt:(id)obj;
+ (NSNumber *)getSafeFloat:(id)obj;
+ (NSNumber *)getSafeBool:(id)obj;
+ (NSString *)getSafeString:(id)obj;
+ (BOOL)isNullOrNilObject:(id)object;

- (void)showLoadingView;
- (void)hideLoadingView;

+ (void)setValue:(id)value forKey:(NSString *)key;
+ (id)valueForKey:(NSString *)key;
+ (NSString *)getXIB:(Class)fromClass;

@end