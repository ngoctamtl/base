//
//  Util.m
//  
//
//  Created by Thanh Le on 12/1/11.
//  Copyright 2011 SETA:CINQ Vietnam., Ltd. All rights reserved.
//

#import "Util.h"
#import "NSString+Extension.h"

@implementation Util

+ (Util *)sharedUtil {
    static Util *_sharedUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUtil = [[Util alloc] init];
    });
    
    return _sharedUtil;
}

#pragma mark Validator
+ (BOOL)validateEmail:(NSString*)email
{
	email = [email lowercaseString];
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [regExPredicate evaluateWithObject:email];
}

- (void)dealloc {
    [HUD release];
    HUD = nil;
    [super dealloc];
}

+ (AppDelegate *)appDelegate {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate;
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSDate *ret = [formatter dateFromString:dateString];
    [formatter release];
    return ret;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSString *ret = [formatter stringFromDate:date];
    [formatter release];
    return ret;
}

#pragma mark
+ (NSString*)getString:(NSInteger)i {
    return [[NSNumber numberWithInt:i] stringValue];
}

+ (NSNumber *)getSafeInt:(id)obj {
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return [NSNumber numberWithInt:INT_MIN];
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        return obj;
    }
    if ([obj length] == 0) {
        return [NSNumber numberWithInt:INT_MIN];
    }
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return [NSNumber numberWithInt:INT_MIN];
    }    
    return [NSNumber numberWithInt:[obj intValue]];
}

+ (NSNumber *)getSafeFloat:(id)obj {
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return [NSNumber numberWithInt:INT_MIN];
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        return obj;
    }
    if ([obj length] == 0) {
        return [NSNumber numberWithInt:INT_MIN];
    }
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return [NSNumber numberWithInt:INT_MIN];
    }    
    return [NSNumber numberWithFloat:[obj floatValue]];
}

+ (NSNumber *)getSafeBool:(id)obj {
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return [NSNumber numberWithInt:INT_MIN];
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        return obj;
    }
    if ([obj length] == 0) {
        return [NSNumber numberWithInt:INT_MIN];
    }
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return [NSNumber numberWithInt:INT_MIN];
    }
    return [NSNumber numberWithBool:[obj boolValue]];
}

+ (NSString *)getSafeString:(id)obj {
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return @"";
    }
    return [obj stringValue];
}

+ (BOOL)isNullOrNilObject:(id)object
{
    if ([object isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (object == nil) {
        return YES;
    }
    return NO;
}

+ (NSString *)getXIB:(Class)fromClass
{
	NSString *className = NSStringFromClass(fromClass);
	
	if (IS_IPAD()) {
		className = [className stringByAppendingString:IPAD_XIB_POSTFIX];
	} else {
		
	}
	return className;
}

#pragma mark Loading View
- (void)showLoadingView {
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:[Util appDelegate].window];
        [[Util appDelegate].window addSubview:HUD];
        HUD.labelText = nil;//@"Wait a moment...";
        HUD.animationType = MBProgressHUDAnimationFade;
        HUD.dimBackground = YES;
    }    
    [HUD show:YES];
}

- (void)hideLoadingView {
    [HUD hide:NO];
}

+ (void)setValue:(id)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)valueForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

@end
