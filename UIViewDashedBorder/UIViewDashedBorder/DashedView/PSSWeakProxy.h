//
//  PSSWeakProxy.h
//  Test
//
//  Created by pangshishan on 2018/4/3.
//  Copyright © 2018年 pangshishan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSSWeakProxy : NSProxy

@property (nullable, nonatomic, weak, readonly) id target;

- (instancetype)initWithTarget:(id)target;

+ (instancetype)proxyWithTarget:(id)target;

@end
