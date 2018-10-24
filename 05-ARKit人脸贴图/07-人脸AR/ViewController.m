//
//  ViewController.m
//  07-人脸AR
//
//  Created by 王俨 on 2018/10/11.
//  Copyright © 2018年 https://github.com/wangyansnow. All rights reserved.
//

#import "ViewController.h"
#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>

@interface ViewController ()<ARSCNViewDelegate, ARSessionDelegate>

@property (nonatomic, strong) ARSCNView *arSCNView;
@property (nonatomic, strong) ARSession *arSession;
@property (nonatomic, strong) ARConfiguration *arConfiguration;

@property (nonatomic, strong) SCNNode *textureMaskNode;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.arSCNView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.arSCNView.session runWithConfiguration:self.arConfiguration];
}


#pragma mark - ARSCNViewDelegate
- (void)renderer:(id<SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    
    if (!anchor || ![anchor isKindOfClass:[ARFaceAnchor class]]) return;
    ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchor;
    
    if (!_textureMaskNode) {
        [node addChildNode:self.textureMaskNode];
    }
    
    ARSCNFaceGeometry *faceGeometry = (ARSCNFaceGeometry *)self.textureMaskNode.geometry;
    if (faceGeometry && [faceGeometry isKindOfClass:[ARSCNFaceGeometry class]]) {
        [faceGeometry updateFromFaceGeometry:faceAnchor.geometry];
    }
}

#pragma mark - 懒加载
- (ARSCNView *)arSCNView {
    if (!_arSCNView) {
        _arSCNView  = [[ARSCNView alloc] initWithFrame:self.view.bounds];
        _arSCNView.session = self.arSession;
        _arSCNView.delegate = self;
    }
    
    return _arSCNView;
}

- (ARSession *)arSession {
    if (!_arSession) {
        _arSession = [[ARSession alloc] init];
        _arSession.delegate = self;
    }
    
    return _arSession;
}

- (ARConfiguration *)arConfiguration {
    if (!_arConfiguration) {
        _arConfiguration = [[ARFaceTrackingConfiguration alloc] init];
        _arConfiguration.lightEstimationEnabled = YES;
    }
    
    return _arConfiguration;
}

- (SCNNode *)textureMaskNode {
    if (!_textureMaskNode) {
        
        id<MTLDevice> device = self.arSCNView.device;
        ARSCNFaceGeometry *geometry = [ARSCNFaceGeometry faceGeometryWithDevice:device fillMesh:NO];
        SCNMaterial *material = geometry.firstMaterial;
        material.fillMode = SCNFillModeFill;
        material.diffuse.contents = [UIImage imageNamed:@"wy.jpg"];
        _textureMaskNode = [SCNNode nodeWithGeometry:geometry];
    }
    _textureMaskNode.name = @"textureMask";
    return _textureMaskNode;
}


@end
