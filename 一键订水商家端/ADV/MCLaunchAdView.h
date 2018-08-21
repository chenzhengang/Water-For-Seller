//
//  MCLaunchAdView.h
//  一键订水商家端
//
//  Created by Chun Kong on 2018/8/16.
//  Copyright © 2018年 chenzhengang. All rights reserved.
//

#import <UIKit/UIKit.h>
/*广告显示屏幕占比类型，对应的NSUInteger竟然选择有意义一点的*/
typedef NS_ENUM(NSUInteger, MCAdViewType) {
    MCAdViewTypeFullScreen = 1,//全屏
    MCAdViewTypeHalfScreen = 2,//半屏
    MCAdViewTypeThreeQuarters = 4,//四分之三屏
    MCAdViewTypeFiveSixths = 6,//六分之五屏
};

/*广告结束的方式*/
typedef NS_ENUM(NSUInteger, MCQuitLaunchAdStyle) {
    MCQuitLaunchAdStyleDefault = 0,
    MCQuitLaunchAdStyleTimeOut,//时间耗尽
    MCQuitLaunchAdStyleSkip,//跳过广告
    MCQuitLaunchAdStyleJumpToURL,//进入广告
};

/*块回调，广告结束后根据不同的结束方式处理下一步*/
typedef void (^MCClick) (MCQuitLaunchAdStyle tag);

/*广告*/
#pragma mark - MCLaunchAdView
@interface MCLaunchAdView : UIView

@property (nonatomic, strong) UIWindow* window;
@property (nonatomic, strong) NSString* localImageName;//本地图片名
@property (nonatomic, strong) NSString* imageURL;//网络图片名
@property (nonatomic, copy) MCClick clickBlock;//块回调，处理不同的操作

-(instancetype)initWithWindow:(UIWindow*)window with:(MCAdViewType)type;
-(void)setTimer:(NSInteger)time;
-(void)startTimer;
@end

