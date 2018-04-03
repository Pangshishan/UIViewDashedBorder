//
//  UIView+DashedBorder.h
//  Test
//
//  Created by pangshishan on 2018/4/3.
//  Copyright © 2018年 pangshishan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashedConfig.h"

@class AngleGradientLayer;
@interface UIView (DashedBorder)

// 前缀避免与其他库重名
@property (nonatomic, strong, readonly) AngleGradientLayer *pss_angleLayer;
@property (nonatomic, strong, readonly) CAShapeLayer *pss_shapeLayer;
@property (nonatomic, strong, readonly) NSTimer *pss_timer;
@property (nonatomic, assign, readonly) NSInteger pss_Count;
@property (nonatomic, strong, readonly) DashedConfig *pss_config;
@property (nonatomic, strong, readonly) CALayer *pss_layer;

/// 如果存在layer, 直接retun, 并不会刷新新的config - (推荐使用)
- (void)startDashedLayerRunning;
/// 如果存在layer, 直接retun, 并不会刷新新的config - (推荐使用)
- (void)startDashedLayerRunningWithContig:(DashedConfig *)config;

/// 会remove边框相关的layer 重新创建,  会刷新新的config - (刷新时才用)
- (void)refreshByConfig:(DashedConfig *)config;

@end

