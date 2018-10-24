//
//  ViewController.m
//  08-微笑检测
//
//  Created by 王俨 on 2018/10/16.
//  Copyright © 2018年 https://github.com/wangyansnow. All rights reserved.
//

#import "ViewController.h"
#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>

@interface ViewController ()<ARSCNViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topContainerView;
@property (weak, nonatomic) IBOutlet UILabel *smileLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (nonatomic, strong) ARSession *arSession;
@property (nonatomic, strong) ARConfiguration *arConfiguration;
@property (nonatomic, strong) ARSCNView *arSCNView;

@property (nonatomic, assign) CGFloat smileValue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.topContainerView addSubview:self.arSCNView];
    self.smileValue = 0.5;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.arSession runWithConfiguration:self.arConfiguration];
}

- (IBAction)startBtnClick:(UIButton *)sender {
    [self.arSession runWithConfiguration:self.arConfiguration options:ARSessionRunOptionRemoveExistingAnchors];
    self.resultLabel.hidden = YES;
}

- (IBAction)smileValueChanged:(UISlider *)sender {
    self.smileLabel.text = [NSString stringWithFormat:@"%.2f", sender.value];
    self.smileValue = sender.value;
}

#pragma mark - ARSCNViewDelegate
- (void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    
    if (!anchor || ![anchor isKindOfClass:[ARFaceAnchor class]]) return;
    
    ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchor;
    
    NSDictionary *blendShips = faceAnchor.blendShapes;
    CGFloat leftSmile = [blendShips[ARBlendShapeLocationMouthSmileLeft] floatValue];
    CGFloat rightSmile = [blendShips[ARBlendShapeLocationMouthSmileRight] floatValue];
    
    NSLog(@"leftSmile = %f, rightSmile = %f", leftSmile, rightSmile);
    if (leftSmile > self.smileValue && rightSmile > self.smileValue) {
        NSLog(@"检测到笑容");
        [self.arSession pause];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultLabel.hidden = NO;
        });
    }
}

#pragma mark - 懒加载
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

- (ARSCNView *)arSCNView {
    if (!_arSCNView) {
        _arSCNView = [[ARSCNView alloc] initWithFrame:self.topContainerView.bounds options:nil];
        _arSCNView.scene = [SCNScene new];
        _arSCNView.session = self.arSession;
        _arSCNView.delegate = self;
        _arSCNView.backgroundColor = [UIColor clearColor];
    }
    
    return _arSCNView;
}

@end
