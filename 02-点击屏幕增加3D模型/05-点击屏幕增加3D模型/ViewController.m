//
//  ViewController.m
//  05-点击屏幕增加3D模型
//
//  Created by 王俨 on 2018/10/10.
//  Copyright © 2018年 https://github.com/wangyansnow. All rights reserved.
//

#import "ViewController.h"
#import "ARSCNVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (IBAction)startARBtnClick:(UIButton *)sender {
    
    [self presentViewController:[ARSCNVC new] animated:YES completion:nil];
}



@end
