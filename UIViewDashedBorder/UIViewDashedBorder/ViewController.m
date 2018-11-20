//
//  ViewController.m
//  UIViewDashedBorder
//
//  Created by 山不在高 on 2018/4/3.
//  Copyright © 2018年 Pangshishan. All rights reserved.
//

#import "ViewController.h"
#import "UIView+DashedBorder.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *dashedView1 = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 200, 100)];
    [self.view addSubview:dashedView1];
    [dashedView1 startDashedLayerRunning];
    //dashedView1.backgroundColor = [UIColor greenColor];
    
    UIView *dashedView2 = [[UIView alloc] initWithFrame:CGRectMake(50, 170, 200, 100)];
    [self.view addSubview:dashedView2];
    DashedConfig *config = [DashedConfig defaultConfig];
    config.openAnimation = NO;
    [dashedView2 startDashedLayerRunningWithContig:config];
    //dashedView2.backgroundColor = [UIColor greenColor];
    
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
    
    UIView *dashedView4 = [[UIView alloc] initWithFrame:CGRectMake(50, 410, 200, 100)];
    [self.view addSubview:dashedView4];
    DashedConfig *config4 = [DashedConfig defaultConfig];
    config4.cornerRidus = 10;
    [dashedView4 startDashedLayerRunningWithContig:config4];
        
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
