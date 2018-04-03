//
//  DashedConfig.m
//  Test
//
//  Created by pangshishan on 2018/4/3.
//  Copyright © 2018年 pangshishan. All rights reserved.
//

#import "DashedConfig.h"

@implementation DashedConfig

+ (instancetype)defaultConfig
{
    return [[self alloc] init];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _openAnimation = YES; // 动画是开启的
        _solidPointCount = 4; // 实线4个pt
        _dashedPointCount = 4; // 虚线空4个pt
        _duration = 0.1; // 0.1秒触发一次定时器，向前走一步
        _lineWidth = 1.0; // 线宽
        _eachPoint = 1; // 一步 1pt
        _circleDuration = 30; // 颜色循环一周30秒
        // 颜色分布
        _colors = @[
                    (id)[UIColor yellowColor].CGColor,
                    (id)[UIColor redColor].CGColor,
                    (id)[UIColor yellowColor].CGColor,
                    (id)[UIColor redColor].CGColor,
                    (id)[UIColor yellowColor].CGColor,
                    (id)[UIColor redColor].CGColor,
                    (id)[UIColor yellowColor].CGColor,
                    (id)[UIColor redColor].CGColor,
                    (id)[UIColor yellowColor].CGColor,
                    ];
    }
    return self;
}

@end
