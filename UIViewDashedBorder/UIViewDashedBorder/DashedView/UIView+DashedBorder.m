//
//  UIView+DashedBorder.m
//  Test
//
//  Created by pangshishan on 2018/4/3.
//  Copyright © 2018年 pangshishan. All rights reserved.
//

#import "UIView+DashedBorder.h"
#import "AngleGradientLayer.h"
#import "PSSWeakProxy.h"
#import <objc/runtime.h>

static char pss_angleLayer_key;
static char pss_shapeLayer_key;
static char pss_timer_key;
static char pss_Count_key;
static char pss_config_key;
static char pss_layer_key;

@implementation UIView (DashedBorder)

+ (void)load
{
    Method layoutSubviews = class_getInstanceMethod(self, @selector(layoutSubviews));
    Method pss_layoutSubviews = class_getInstanceMethod(self, @selector(pss_layoutSubviews));
    method_exchangeImplementations(layoutSubviews, pss_layoutSubviews);
    
    Method dealloc = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
    Method pss_dealloc = class_getInstanceMethod(self, @selector(pss_dealloc));
    method_exchangeImplementations(dealloc, pss_dealloc);
}

- (void)pss_dealloc
{
    [self.pss_timer invalidate];
    self.pss_timer = nil;
    [self pss_dealloc];
}
- (void)pss_layoutSubviews
{
    [self pss_layoutSubviews];
    if (self.pss_shapeLayer && self.pss_angleLayer) {
        [self drawSquare:0];
    }
}

- (void)startDashedLayerRunningWithContig:(DashedConfig *)config
{
    if (self.pss_shapeLayer && self.pss_angleLayer) {
        return;
    }
    // 初始化config
    if (config) {
        self.pss_config = config;
    } else {
        self.pss_config = [DashedConfig defaultConfig];
    }
    self.pss_Count = 0;
    
    self.pss_shapeLayer = [[CAShapeLayer alloc] init];
    self.pss_shapeLayer.lineDashPattern = @[@(self.pss_config.solidPointCount), @(self.pss_config.dashedPointCount)];
    self.pss_shapeLayer.lineWidth = self.pss_config.lineWidth;
    self.pss_shapeLayer.repeatCount = 1;
    self.pss_shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    self.pss_shapeLayer.lineDashPhase = 1;
    self.pss_shapeLayer.fillColor = nil;
    
    self.pss_layer = [[CALayer alloc] init];
    [self.layer addSublayer:self.pss_layer];
    self.pss_layer.frame = self.bounds;
    
    AngleGradientLayer *angleLayer = [[AngleGradientLayer alloc] init];
    self.pss_angleLayer = angleLayer;
    angleLayer.backgroundColor = [UIColor whiteColor].CGColor;
    angleLayer.colors = self.pss_config.colors;
    [self.pss_layer addSublayer:angleLayer];
    
    self.pss_layer.mask = self.pss_shapeLayer;
    
    if (self.pss_config.isOpenAnimation) {
        CABasicAnimation *baseAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        baseAni.toValue = @(M_PI * 2);
        baseAni.duration = self.pss_config.circleDuration;
        baseAni.cumulative = YES;
        baseAni.repeatCount = 9999999;
        [angleLayer addAnimation:baseAni forKey:nil];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.pss_config.duration target:[PSSWeakProxy proxyWithTarget:self] selector:@selector(pssTimerRunning) userInfo:nil repeats:YES];
        self.pss_timer = timer;
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}
- (void)startDashedLayerRunning
{
    [self startDashedLayerRunningWithContig:nil];
}
- (void)refreshByConfig:(DashedConfig *)config
{
    [self.pss_layer removeFromSuperlayer];
    self.pss_layer = nil;
    [self.pss_angleLayer removeFromSuperlayer];
    self.pss_angleLayer = nil;
    [self.pss_shapeLayer removeFromSuperlayer];
    self.pss_shapeLayer = nil;
    [self.pss_timer invalidate];
    self.pss_timer = nil;
    self.pss_Count = 0;
    self.pss_config = nil;
    [self startDashedLayerRunningWithContig:config];
}

- (void)pssTimerRunning
{
    self.pss_Count += self.pss_config.eachPoint;
    [self drawSquare:self.pss_Count];
}

- (void)drawSquare:(NSInteger)num
{
    // 由于angleLayer是长方形的, 为了旋转不让边框超范围, 需要扩大angleLayer的范围, 并且对边框进行修正
    // 关掉隐式动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.pss_layer.frame = self.bounds;
    CGFloat startX = (CGFloat)(num % (self.pss_config.solidPointCount + self.pss_config.dashedPointCount));
    double width = (double)self.bounds.size.width + 2 * self.pss_config.lineWidth;
    double height = (double)self.bounds.size.height + 2 * self.pss_config.lineWidth;
    double diagonal = sqrt(pow(self.bounds.size.width, 2.0) + pow(self.bounds.size.height, 2.0));
    CGFloat x = (CGFloat)(width - diagonal) / 2;
    CGFloat y = (CGFloat)(height - diagonal) / 2;
    self.pss_angleLayer.frame = CGRectMake(x, y, (CGFloat)diagonal, (CGFloat)diagonal);
    
    CGFloat R = self.pss_config.cornerRidus;
    // 半径的二倍 大于宽或者高时，要绘制直角；（无法绘制圆角）
    BOOL bool1 = (R * 2 > self.bounds.size.width || R * 2 > self.bounds.size.height);
    BOOL bool2 = (R <= 0); // 无圆角，绘制直角
    if (bool1 || bool2) {
        CGPoint point0 = CGPointMake(startX, 0);
        CGPoint point1 = CGPointMake(self.bounds.size.width, 0);
        CGPoint point2 = CGPointMake(self.bounds.size.width, self.bounds.size.height);
        CGPoint point3 = CGPointMake(0, self.bounds.size.height);
        CGPoint point4 = CGPointMake(0, 0);
        
        int pointCount = 5;
        CGPoint moveToPoints[] = {point1, point2, point3, point4, point0};
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:point0];
        for (int i = 0; i < pointCount; i++) {
            [path addLineToPoint:moveToPoints[i]];
        }
        self.pss_shapeLayer.path = path.CGPath;
    } else {
        CGPoint point0 = CGPointMake(startX + R, 0);
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:point0];
        [path addLineToPoint:CGPointMake(self.bounds.size.width - R, 0)];
        [path addArcWithCenter:CGPointMake(self.bounds.size.width - R, R) radius:R startAngle:-M_PI_2 endAngle:0 clockwise:YES];
        [path addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - R)];
        [path addArcWithCenter:CGPointMake(self.bounds.size.width - R, self.bounds.size.height - R) radius:R startAngle:0 endAngle:M_PI_2 clockwise:YES];
        [path addLineToPoint:CGPointMake(R, self.bounds.size.height)];
        [path addArcWithCenter:CGPointMake(R, self.bounds.size.height - R) radius:R startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        [path addLineToPoint:CGPointMake(0, R)];
        [path addArcWithCenter:CGPointMake(R, R) radius:R startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
        [path addLineToPoint:point0];
        self.pss_shapeLayer.path = path.CGPath;
    }
    
    [CATransaction commit];
}

#pragma mark - getter
- (AngleGradientLayer *)pss_angleLayer
{
    return objc_getAssociatedObject(self, &pss_angleLayer_key);
}
- (CAShapeLayer *)pss_shapeLayer
{
    return objc_getAssociatedObject(self, &pss_shapeLayer_key);
}
- (NSTimer *)pss_timer
{
    return objc_getAssociatedObject(self, &pss_timer_key);
}
- (NSInteger)pss_Count
{
    return [objc_getAssociatedObject(self, &pss_Count_key) integerValue];
}
- (DashedConfig *)pss_config
{
    return objc_getAssociatedObject(self, &pss_config_key);
}
- (CALayer *)pss_layer
{
    return objc_getAssociatedObject(self, &pss_layer_key);
}
#pragma mark - setter
- (void)setPss_angleLayer:(AngleGradientLayer *)pss_angleLayer
{
    objc_setAssociatedObject(self, &pss_angleLayer_key, pss_angleLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setPss_shapeLayer:(CAShapeLayer *)pss_shapeLayer
{
    objc_setAssociatedObject(self, &pss_shapeLayer_key, pss_shapeLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setPss_timer:(NSTimer *)pss_timer
{
    objc_setAssociatedObject(self, &pss_timer_key, pss_timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setPss_Count:(NSInteger)pss_Count
{
    objc_setAssociatedObject(self, &pss_Count_key, @(pss_Count), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)setPss_config:(DashedConfig *)pss_config
{
    objc_setAssociatedObject(self, &pss_config_key, pss_config, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setPss_layer:(CALayer *)pss_layer
{
    objc_setAssociatedObject(self, &pss_layer_key, pss_layer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end










