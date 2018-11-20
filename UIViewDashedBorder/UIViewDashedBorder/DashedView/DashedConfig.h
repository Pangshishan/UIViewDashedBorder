//
//  DashedConfig.h
//  Test
//
//  Created by pangshishan on 2018/4/3.
//  Copyright © 2018年 pangshishan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DashedConfig : NSObject

/// 实线和虚线的长度, 循环他俩之和, 控件宽度最少要大于两个之和
@property (nonatomic, assign) NSInteger solidPointCount;
@property (nonatomic, assign) NSInteger dashedPointCount;

@property (nonatomic, assign, getter=isOpenAnimation) BOOL openAnimation; 
@property (nonatomic, copy) NSArray *colors;
@property (nonatomic, assign) CGFloat lineWidth;
/// 一步几个单位 pt
@property (nonatomic, assign) NSInteger eachPoint;
/// 多久移动一步
@property (nonatomic, assign) double duration;
/// 颜色多久循环一周
@property (nonatomic, assign) double circleDuration;
/// 半径, 0时为直角
@property (nonatomic, assign) CGFloat cornerRidus;

+ (instancetype)defaultConfig;

@end
