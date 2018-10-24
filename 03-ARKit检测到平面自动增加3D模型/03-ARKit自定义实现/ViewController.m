//
//  ViewController.m
//  03-ARKit自定义实现
//
//  Created by 王俨 on 2018/9/29.
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
