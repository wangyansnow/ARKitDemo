//
//  ViewController.m
//  04-QuickLook
//
//  Created by 王俨 on 2018/10/9.
//  Copyright © 2018年 https://github.com/wangyansnow. All rights reserved.
//

#import "ViewController.h"
#import <QuickLook/QuickLook.h>
#import "WYPreviewItem.h"

@interface ViewController ()<QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    QLPreviewController *preVC = [[QLPreviewController alloc] init];
    preVC.dataSource = self;
    preVC.delegate = self;
    
    [self presentViewController:preVC animated:YES completion:nil];
}

#pragma mark - QLPreviewControllerDataSource && QLPreviewControllerDelegate
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    
    return [[NSBundle mainBundle] URLForResource:@"plantpot.usdz" withExtension:nil];
}

- (UIImage *)previewController:(QLPreviewController *)controller transitionImageForPreviewItem:(id<QLPreviewItem>)item contentRect:(CGRect *)contentRect {
    
    CGRect rect = CGRectMake(100, 200, 300, 300);
    contentRect = &rect;
    
    return [UIImage imageNamed:@"wy.jpeg"];
}


@end
