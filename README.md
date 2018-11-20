# UIViewDashedBorder


今天分享一个我封装的UIView的传送带边框，带动画的，也可以关闭动画，可以设置圆角，可以设置颜色渐变，用法非常简单，先看看效果图

![效果图](http://img.hb.aicdn.com/f2055c1edb04cdd4266a3fdfbf194f45eb01afcf437d5-iv2q79_fw658)



**代码用法如下：**  效果图中的四种效果，对应代码四种写法
```Objective-C
    // 1.
    UIView *dashedView1 = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 200, 100)];
    [self.view addSubview:dashedView1];
    [dashedView1 startDashedLayerRunning];
    //dashedView1.backgroundColor = [UIColor greenColor];
    
    // 2.
    UIView *dashedView2 = [[UIView alloc] initWithFrame:CGRectMake(50, 170, 200, 100)];
    [self.view addSubview:dashedView2];
    DashedConfig *config = [DashedConfig defaultConfig];
    config.openAnimation = NO;
    [dashedView2 startDashedLayerRunningWithContig:config];
    //dashedView2.backgroundColor = [UIColor greenColor];
    
    // 3.
    UIView *dashedView3 = [[UIView alloc] initWithFrame:CGRectMake(50, 290, 200, 100)];
    [self.view addSubview:dashedView3];
    DashedConfig *config1 = [DashedConfig defaultConfig];
    config1.openAnimation = YES;
    config1.colors = @[(id)[UIColor redColor].CGColor];
    config1.solidPointCount = 6;
    config1.dashedPointCount = 6;
    config1.lineWidth = 2;
    config1.eachPoint = 2;
    config1.duration = 0.1;
    config1.circleDuration = 15;
    [dashedView3 startDashedLayerRunningWithContig:config1];
    
    // 4. 
    UIView *dashedView4 = [[UIView alloc] initWithFrame:CGRectMake(50, 410, 200, 100)];
    [self.view addSubview:dashedView4];
    DashedConfig *config4 = [DashedConfig defaultConfig];
    config4.cornerRidus = 10;
    [dashedView4 startDashedLayerRunningWithContig:config4];
```

**文件目录以及.h**
![在这里插入图片描述](https://img-blog.csdnimg.cn/20181120165613997.png)

```OC
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
```

```OC
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
```

**码字码代码不易，喜欢的话别忘了Star哦**
