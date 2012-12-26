//
//  ResponseObject.h
//  SetaBase
//
//  Created by Thanh Le on 10/16/12.
//  Copyright (c) 2012 Setacinq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseObject : NSObject

@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSString *errorCode;
@property (nonatomic, strong) NSString *message;

@end
