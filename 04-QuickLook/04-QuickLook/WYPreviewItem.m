//
//  WYPreviewItem.m
//  04-QuickLook
//
//  Created by 王俨 on 2018/10/10.
//  Copyright © 2018年 https://github.com/wangyansnow. All rights reserved.
//

#import "WYPreviewItem.h"

@implementation WYPreviewItem

- (NSURL *)previewItemURL {
    return [[NSBundle mainBundle] URLForResource:@"plantpot.usdz" withExtension:nil];
}

@end
