//
//  ViewController.m
//  09-皱眉检测
//
//  Created by 王俨 on 2018/10/17.
//  Copyright © 2018年 https://github.com/wangyansnow. All rights reserved.
//

#import "ViewController.h"
#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>

@interface ViewController ()<ARSCNViewDelegate>

@property (nonatomic, strong) ARSCNView *arSCNView;
@property (nonatomic, strong) ARConfiguration *arConfiguration;
@property (nonatomic, strong) ARSession *arSession;

@property (weak, nonatomic) IBOutlet UIView *topContainerView;
@property (weak, nonatomic) IBOutlet UILabel *browValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (nonatomic, assign) CGFloat browValue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.topContainerView addSubview:self.arSCNView];
    self.browValue = 0.8;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.arSession runWithConfiguration:self.arConfiguration];
}

- (IBAction)startBtnClick:(UIButton *)sender {
    [self.arSession runWithConfiguration:self.arConfiguration options:ARSessionRunOptionRemoveExistingAnchors];
    self.resultLabel.hidden = YES;
}

- (IBAction)browValueChanged:(UISlider *)sender {
    self.browValue = sender.value;
    self.browValueLabel.text = [NSString stringWithFormat:@"%.2f", sender.value];
}

#pragma mark - ARSCNViewDelegate
- (void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    
    if (!anchor && ![anchor isKindOfClass:[ARFaceAnchor class]]) return;
    
    ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchor;
    NSDictionary *blendShapes = faceAnchor.blendShapes;
    NSNumber *browInnerUp = blendShapes[ARBlendShapeLocationBrowInnerUp];
    
    if ([browInnerUp floatValue] > self.browValue) {
        [self.arSession pause];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultLabel.hidden = NO;
        });
    }
    
    NSLog(@"browInnerUp = %@", browInnerUp);
}

#pragma mark - 懒加载
- (ARSCNView *)arSCNView {
    if (!_arSCNView) {
        _arSCNView = [[ARSCNView alloc] initWithFrame:self.topContainerView.bounds];
        _arSCNView.session = self.arSession;
        _arSCNView.delegate = self;
    }
    
    return _arSCNView;
}

- (ARSession *)arSession {
    if (!_arSession) {
        _arSession = [[ARSession alloc] init];
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

@end
