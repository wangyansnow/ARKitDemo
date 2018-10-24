//
//  WYScene.m
//  06-点击屏幕增加文字
//
//  Created by 王俨 on 2018/10/10.
//  Copyright © 2018年 https://github.com/wangyansnow. All rights reserved.
//

#import "Scene.h"

@implementation Scene

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (![self.view isKindOfClass:[ARSKView class]]) return;
    
    ARSKView *sceneView = (ARSKView *)self.view;
    ARFrame *currentFrame = [sceneView.session currentFrame];
    
    // Create anchor using the camera's current position
    if (currentFrame) {
        // Create a transform with a translation of 0.2 meters in front of the camera
        matrix_float4x4 translation = matrix_identity_float4x4;
        translation.columns[3].z = -1;
        matrix_float4x4 transform = matrix_multiply(currentFrame.camera.transform, translation);
        
        // Add a new anchor to the session
        ARAnchor *anchor = [[ARAnchor alloc] initWithTransform:transform];
        [sceneView.session addAnchor:anchor];
    }
}

@end
