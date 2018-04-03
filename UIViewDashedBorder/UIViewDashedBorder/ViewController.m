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
    
    UIView *dashedView2 = [[UIView alloc] initWithFrame:CGRectMake(50, 200, 200, 100)];
    [self.view addSubview:dashedView2];
    DashedConfig *config = [DashedConfig defaultConfig];
    config.openAnimation = NO;
    [dashedView2 startDashedLayerRunningWithContig:config];
    //dashedView2.backgroundColor = [UIColor greenColor];
        
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
