//
//  MCCountingButton.m
//  一键订水商家端
//
//  Created by Chun Kong on 2018/8/16.
//  Copyright © 2018年 chenzhengang. All rights reserved.
//

#import "MCCountingButton.h"

#pragma mark - MCCountingButton
@interface MCCountingButton()
@property (nonatomic, strong) UIBezierPath* path;
@property (nonatomic, strong) CAShapeLayer* backgroundShapeLayer;
@property (nonatomic, strong) CAShapeLayer* shapeLayer;
@end

@implementation MCCountingButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.totalTime = 6;//默认总时长6秒
        self.tickTockInterval = 40;//默认25下每秒
        [self initialView];
    }
    return self;
}

-(void)initialView
{
    //设置路径
    self.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    //灰色底层
    self.backgroundShapeLayer = [CAShapeLayer layer];
    self.backgroundShapeLayer.frame = self.bounds;
    self.backgroundShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.backgroundShapeLayer.lineWidth = 2.0f;
    self.backgroundShapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    self.backgroundShapeLayer.strokeStart = 0.f;
    self.backgroundShapeLayer.strokeEnd = 1.f;
    self.backgroundShapeLayer.path = self.path.CGPath;
    [self.layer addSublayer:self.backgroundShapeLayer];
    //环形进度条，起始点＝终结点＝0，所以初始化时不可见
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = self.bounds;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.lineWidth = 2.0f;
    self.shapeLayer.lineCap = kCALineCapRound;
    self.shapeLayer.strokeColor = [UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
    self.shapeLayer.strokeStart = 0.0f;
    //通过不断修改stroEnd的值，使形成像动画刷新的效果，也可以使用CAAnimation的方式，动画的显示出来，duration设置为你广告总时长就可以
    self.shapeLayer.strokeEnd = 0.0f;
    self.shapeLayer.path = self.path.CGPath;
    [self.layer addSublayer:self.shapeLayer];
    //修正坐标轴，逆时针旋转90度，从12点钟开始倒计时
    self.shapeLayer.transform =  CATransform3DRotate(CATransform3DIdentity, M_PI / 2, 0, 0, -1);
    //
    [self setTitle:NSLocalizedString(@"跳过", nil) forState:UIControlStateNormal];
    [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:10.0];
}

/*改变进度条末端位置，循环调用实现进度条刷新*/
-(void)counting
{
    //strokeEnd的取值范围是0.0到1.0，所以超出1.0时截取
    CGFloat unit = self.tickTockInterval/(self.totalTime*1000.0);
    CGFloat f = self.shapeLayer.strokeEnd+unit;
    if (f > 1.0) {
        self.shapeLayer.strokeEnd = 1.0f;
    }else {
        self.shapeLayer.strokeEnd = f;
    }
}
@end

