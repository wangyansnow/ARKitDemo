//
//  ARSCNVC.m
//  03-ARKit自定义实现
//
//  Created by 王俨 on 2018/9/29.
//  Copyright © 2018年 https://github.com/wangyansnow. All rights reserved.
//

#import "ARSCNVC.h"
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>
/**
 默认情况下节点SCNNode的x、y、z位置是(0,0,0)，也就是摄像头所在的位置，每一个ARSession在启动时，摄像头的位置就是3D世界的原点，而且这个原点不再跟随摄像头移动而改变，是第一次就永久固定的
 */

@interface ARSCNVC ()<ARSCNViewDelegate, ARSessionDelegate>

@property (nonatomic, strong) ARSCNView *arSCNView;
@property (nonatomic, strong) ARSession *arSession;
@property (nonatomic, strong) ARWorldTrackingConfiguration *arWordTrackingConfiguration;
@property (nonatomic, strong) SCNNode *vaseNode;

@end

@implementation ARSCNVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    /**
     ARSCNView
     ARSession
     ARSessionConfiguration
     */
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.arSCNView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.arSession runWithConfiguration:self.arWordTrackingConfiguration];
}

#pragma mark - ARSCNViewDelegate
// 添加节点的时候调用(当开启平地捕捉模式之后，如果捕捉到平地，ARKit会自动添加一个平地节点)
- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    
    if (![anchor isMemberOfClass:[ARPlaneAnchor class]]) return;
    
    // 添加一个3D平面模型，ARKit只有捕捉能力，锚点只是一个空间位置，想更加清楚看到这个空间，我们需要给控件添加一个平地的3D模型来渲染它
    // 1. 获取捕捉到的平地锚点
    ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
    // 2. 创建一个3D模型(系统捕捉到的平地是一个不规则的大小长方形，这里笔者q将其变成一个长方形，并且对平地做了一个缩放效果)
    // 参数分别是长、宽、高、圆角
    SCNBox *planeBox = [SCNBox boxWithWidth:planeAnchor.extent.x * 0.3 height:0 length:planeAnchor.extent.x * 0.3 chamferRadius:0];
    // 3. 使用Material渲染3D模型(默认模型是白色的)
    planeBox.firstMaterial.diffuse.contents = [UIColor clearColor];
    // 4. 创建一个基于3D物体模型的节点
    SCNNode *planeNode = [SCNNode nodeWithGeometry:planeBox];
    // 5. 设置节点的位置为捕捉到的平地的锚点的中心位置
    // SceneKit中节点的位置position是一个基于3D坐标系的矢量坐标SCNVector3Make
    planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
    
    [node addChildNode:planeNode];
    
    // 6. 创建一个花瓶场景
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/vase/vase.scn"];
    // 7. 获取花瓶节点
    // 一个场景有多个节点，所有场景有且只有一个根节点，其它所有节点都是根节点的子节点
    SCNNode *vaseNode = scene.rootNode.childNodes.firstObject;
    // 8. 设置花瓶节点的位置为捕捉到的平地的位置，如果不设置，则默认为原点位置也就是相机位置
    vaseNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
    // 9. 将花瓶节点添加到屏幕中
    // !!!!FBI WARNING: 花瓶节点是添加到代理捕捉到的节点中，而不是AR视图的根接节点。
    // 因为捕捉到的平地锚点是一个本地坐标系，而不是世界坐标系
    [node addChildNode:vaseNode];
}

#pragma mark - 懒加载
- (ARSCNView *)arSCNView {
    if (!_arSCNView) {
        // 1. 创建AR视图
        _arSCNView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
        // 2. 设置视图会话
        _arSCNView.session = self.arSession;
        // 3. 自动刷新光(3D游戏用到，此处忽略)
        _arSCNView.automaticallyUpdatesLighting = YES;
        
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

- (ARWorldTrackingConfiguration *)arWordTrackingConfiguration {
    if (!_arWordTrackingConfiguration) {
        // 1. 创建世界追踪配置，需要支持A9芯片也就是iPhone6S以上
        _arWordTrackingConfiguration = [[ARWorldTrackingConfiguration alloc] init];
        // 2. 设置追踪方向,追踪平面
        _arWordTrackingConfiguration.planeDetection = ARPlaneDetectionHorizontal;
        _arWordTrackingConfiguration.lightEstimationEnabled = YES;
    }
    
    return _arWordTrackingConfiguration;
}

@end
