//
//  SPNSExtensions.m
//  Sparrow
//
//  Created by Daniel Sperl on 13.05.09.
//  Copyright 2011 Gamua. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import "SPNSExtensions.h"
#import "SPSound.h"

@implementation NSInvocation (SPNSExtensions)

+ (NSInvocation*)invocationWithTarget:(id)target selector:(SEL)selector
{
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.selector = selector;
    invocation.target = target;
    return invocation;
}

@end


@implementation NSString (SPNSExtensions)

- (NSString *)fullPathExtension
{
    NSString *filename = [self lastPathComponent];
    NSRange range = { .location = 1, .length = filename.length - 1 }; // ignore first letter -> '.hidden' files
    uint dotLocation = [filename rangeOfString:@"." options:NSLiteralSearch range:range].location;
    return dotLocation == NSNotFound ? @"" : [filename substringFromIndex:dotLocation + 1];
}

- (NSString *)stringByDeletingFullPathExtension
{
    NSString *base = self;
    while (![base isEqualToString:(base = [base stringByDeletingPathExtension])]) {}
    return base;
}

- (NSString *)stringByAppendingSuffixToFilename:(NSString *)suffix
{
    return [[self stringByDeletingFullPathExtension] stringByAppendingFormat:@"%@.%@", 
            suffix, [self fullPathExtension]];
}

- (float)contentScaleFactor
{
    NSString *filename = [self lastPathComponent];
    NSRange atRange = [filename rangeOfString:@"@"];
    if (atRange.length == 0) return 1.0f;
    else
    {
        int factor = [[filename substringWithRange:NSMakeRange(atRange.location+1, 1)] intValue];
        return factor ? factor : 1.0f;
    }
    
    // The code above supports only integer scalefactors. The code below supports any number,
    // but is dependent on iOS 4.
    
    /*
    NSError *error;
    NSRange range = NSMakeRange(0, self.length);
    NSString *regexStr = @"@(\\d+)x(?:~\\w+)?\\.\\S+$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] 
                                  initWithPattern:regexStr options:0 error:&error];
    
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:range];
    NSRange resultRange = [result rangeAtIndex:1];
    [regex release];
    
    if (resultRange.length == 0) return 1.0f;
    else return [[self substringWithRange:resultRange] floatValue];
    */
}

@end


@implementation NSBundle (SPNSExtensions)

- (NSString *)pathForResource:(NSString *)name
{
    if (!name) return nil;
    
    NSString *directory = [name stringByDeletingLastPathComponent];
    NSString *file = [name lastPathComponent];    
    return [self pathForResource:file ofType:nil inDirectory:directory];
}

- (NSString *)pathForResource:(NSString *)name withScaleFactor:(float)factor
{
    if (factor != 1.0f)
    {
        NSString *suffix = [NSString stringWithFormat:@"@%@x", [NSNumber numberWithFloat:factor]];
        NSString *path = [self pathForResource:[name stringByAppendingSuffixToFilename:suffix]];
        if (path) return path;
    }    
    
    return [self pathForResource:name];
}

+ (NSBundle *)appBundle
{
    /********  ThanhLV added 20120528 - Only for audio
    return [NSBundle bundleForClass:[SPDisplayObject class]];
     */
    return [NSBundle bundleForClass:[SPSound class]];
}

@end
