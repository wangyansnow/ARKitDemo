//
//  ARSCNVC.m
//  05-点击屏幕增加3D模型
//
//  Created by 王俨 on 2018/10/10.
//  Copyright © 2018年 https://github.com/wangyansnow. All rights reserved.
//

#import "ARSCNVC.h"
#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>

@interface ARSCNVC ()<ARSCNViewDelegate, ARSessionDelegate>

@property (nonatomic, strong) ARSCNView *arSCNView;
@property (nonatomic, strong) ARSession *arSession;
@property (nonatomic, strong) ARWorldTrackingConfiguration *arWordTrackingConfiguration;

@end

@implementation ARSCNVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.arSCNView = [[ARSCNView alloc] initWithFrame:self.view.bounds options:nil];
    self.arSCNView.session = [[ARSession alloc] init];
    
    self.arWordTrackingConfiguration = [[ARWorldTrackingConfiguration alloc] init];
    self.arWordTrackingConfiguration.planeDetection = ARPlaneDetectionHorizontal;
    self.arWordTrackingConfiguration.lightEstimationEnabled = YES;
    
    [self.view addSubview:self.arSCNView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.arSession runWithConfiguration:self.arWordTrackingConfiguration];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
    SCNNode *shipNode = scene.rootNode.childNodes.firstObject;
    shipNode.position = SCNVector3Make(0, -1, -1);
    
    [self.arSCNView.scene.rootNode addChildNode:shipNode];
}

@end
