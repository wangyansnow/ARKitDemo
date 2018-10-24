//
//  ViewController.m
//  06-点击屏幕增加文字
//
//  Created by 王俨 on 2018/10/10.
//  Copyright © 2018年 https://github.com/wangyansnow. All rights reserved.
//

#import "ViewController.h"
#import "Scene.h"

@interface ViewController ()<ARSKViewDelegate>

@property (nonatomic, strong)  ARSKView *sceneView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sceneView = [[ARSKView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.sceneView];
    self.sceneView.delegate = self;
    
    // Show statistics such as fps and node count
    self.sceneView.showsFPS = YES;
    self.sceneView.showsNodeCount = YES;
    
    // Load the SKScene from 'Scene.sks'
    Scene *scene = (Scene *)[SKScene nodeWithFileNamed:@"Scene"];
    
    // Present the scene
    [self.sceneView presentScene:scene];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    ARWorldTrackingConfiguration *configuration = [[ARWorldTrackingConfiguration alloc] init];
    [self.sceneView.session runWithConfiguration:configuration];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.sceneView.session pause];
}

#pragma mark - ARSKViewDelegate
- (SKNode *)view:(ARSKView *)view nodeForAnchor:(ARAnchor *)anchor {
    // Create and configure a node for the anchor added to the view's session
    SKLabelNode *labelNode = [SKLabelNode labelNodeWithText:@"王俨"];
    labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    return labelNode;
}

@end
