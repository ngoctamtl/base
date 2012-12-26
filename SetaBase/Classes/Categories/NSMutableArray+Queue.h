//
//  NSMutableArray+Queue.h
//  istepandrepeat2
//
//  Created by thanhlv on 5/25/11.
//  Copyright 2011 SETA:CINQ Vietnam., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (QueueAdditions)
- (id) dequeue;
- (void) enqueue:(id)obj;
@end
