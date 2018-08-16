//
//  MCLaunchAdView.m
//  一键订水商家端
//
//  Created by Chun Kong on 2018/8/16.
//  Copyright © 2018年 chenzhengang. All rights reserved.
//

#import "MCLaunchAdView.h"
#import "MCCountingButton.h"
#import "UIImageView+WebCache.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

#define TIMER_INTERVAL 0.04 //25帧每秒
#define SKIPBUTTONSIZE 30

#pragma mark - MCLaunchAdView
@interface MCLaunchAdView()
{
    MCCountingButton* _countingBtn;//跳过广告按钮
}
@property (nonatomic) MCAdViewType adViewtype;
@property (nonatomic, strong) UIImageView* adView;/*广告界面*/
@property (nonatomic) NSInteger adTime;//广告时长，默认6秒
@property (nonatomic) CGFloat adTimeLeft;/*剩余时间，用于计算时间是否耗尽*/
@property (nonatomic, strong) NSTimer* countTimer;/*计时器*/
@end

@implementation MCLaunchAdView

/*初始化*/
-(instancetype)initWithWindow:(UIWindow*)window with:(MCAdViewType)type
{
    self = [super init];
    if (self) {
        //
        self.window = window;
        [window makeKeyAndVisible];
        self.adViewtype = type;
        self.adTime = 6;//默认6秒
        self.adTimeLeft = self.adTime;
        [self initailView];
        [self.window addSubview:self];
    }
    return self;
}

-(void)initailView
{
    //广告界面
    {
        UIImageView* imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleToFill;//因为图片不一定铺满整个屏幕，所以这里暂时做了拉伸
        [self addSubview:imgView];
        self.adView = imgView;
    }
    //跳过按钮
    {
        MCCountingButton* countingBtn = [[MCCountingButton alloc] initWithFrame:CGRectMake(0, 0, SKIPBUTTONSIZE, SKIPBUTTONSIZE)];
        [countingBtn addTarget:self action:@selector(skipButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.adView addSubview:countingBtn];
        _countingBtn = countingBtn;
    }
}

-(void)layoutSubviews
{
    self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    //设置启动界面的背景，显示logo
    NSString* imgName = [self getBestLaunchImage];
    UIImage* img = [UIImage imageNamed:imgName];
    self.layer.contents = (id)img.CGImage;
    //根据不同的广告占屏比设置不同的布局
    if (self.adViewtype == MCAdViewTypeFullScreen) {
        self.adView.bounds = CGRectMake(0, 0, screenWidth, screenHeight);
    }else if (self.adViewtype == MCAdViewTypeHalfScreen) {
        self.adView.bounds = CGRectMake(0, 0, screenWidth, 2*screenHeight/3);
    }else if (self.adViewtype == MCAdViewTypeThreeQuarters) {
        self.adView.bounds = CGRectMake(0, 0, screenWidth, 3*screenHeight/4);
    }else if (self.adViewtype == MCAdViewTypeFiveSixths) {
        self.adView.bounds = CGRectMake(0, 0, screenWidth, 5*screenHeight/6);
    }else {
        self.adView.bounds = CGRectMake(0, 0, screenWidth, screenHeight);
    }
    self.adView.center = CGPointMake(screenWidth/2, self.adView.bounds.size.height/2);
    //跳过按钮的布局
    _countingBtn.center = CGPointMake(screenWidth-SKIPBUTTONSIZE/2-5, SKIPBUTTONSIZE/2+20);
    _countingBtn.tickTockInterval = TIMER_INTERVAL*1000;//设置计时间隔
    _countingBtn.totalTime = self.adTime;//设置总时长
}
/*设置计时器时长，不调用这个方法，就使用计时器默认的6秒*/
-(void)setTimer:(NSInteger)time
{
    self.adTime = time;
    self.adTimeLeft = time;
}
/*启动计时器*/
-(void)startTimer
{
    //添加计时器
    self.countTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(TickTock) userInfo:nil repeats:YES];
}
/*关闭计时器*/
-(void)closeTimer
{
    //关闭
    if (self.countTimer) {
        [self.countTimer invalidate];
        self.countTimer = nil;
    }
}

#pragma mark - Action
/*过了一个计时单位TIMER_INTERVAL，检查剩余时间*/
-(void)TickTock
{
    if (self.adTimeLeft > 0) {
        //默认6秒，时间未耗尽，继续展示
        self.adTimeLeft = self.adTimeLeft - TIMER_INTERVAL;
        [_countingBtn counting];
    }else {
        //默认6秒，时间耗尽
        [self closeTimer];
        if (self.clickBlock) {
            self.clickBlock(MCQuitLaunchAdStyleTimeOut);
        }
    }
}
/*响应点击跳过按钮事件*/
-(void)skipButtonClicked:(UIButton*)btn
{
    [self closeTimer];
    if (self.clickBlock) {
        self.clickBlock(MCQuitLaunchAdStyleSkip);
    }
}
/*响应点击广告事件*/
-(void)jumpToURL:(UITapGestureRecognizer*)recognizer
{
    [self closeTimer];
    if (self.clickBlock) {
        self.clickBlock(MCQuitLaunchAdStyleJumpToURL);
    }
}

#pragma mark - 获取最佳启动图
/*获取最佳启动图，根据硬件设备分辨率，从info.plist中获取图片名，需要在plist中添加相关的图片信息，从而适配不同尺寸的设备*/
-(NSString*)getBestLaunchImage
{
    NSString* launchImage = nil;
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString* viewOrientation = @"Portrait";//如需设置横屏，请修改为Landscape,对应的viewSize也要切换一下
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        viewSize = CGSizeMake(viewSize.height, viewSize.width);
        viewOrientation = @"Landscape";
    }
    //比较设备分辨率和图片尺寸，取得匹配的图片名
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
            //这边会有问题，因为屏幕占比不一定全屏，所以这边其实还要进一步截取屏幕的大小，但是这边我省略了，外部在调用的时候我做了拉伸的处理
            launchImage = dict[@"UILaunchImageName"];
    }
    //没有匹配的图片，取默认的图片名
    if (!launchImage) {
        launchImage = @"LaunchImageIconLogo_930.png";
    }
    return launchImage;
}

#pragma mark -
/*重写setter方法，支持GIF图的显示*/
-(void)setLocalImageName:(NSString *)localImageName
{
    _localImageName = localImageName;
    if (_localImageName) {
        if ([[_localImageName uppercaseString] rangeOfString:@".GIF"].location != NSNotFound) {
            _localImageName = [_localImageName stringByReplacingCharactersInRange:[[_localImageName uppercaseString] rangeOfString:@".GIF"] withString:@""];
            NSData* gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_localImageName ofType:@"gif"]];
            UIWebView* webView = [[UIWebView alloc] initWithFrame:self.adView.frame];
            webView.backgroundColor = [UIColor clearColor];
            webView.scalesPageToFit = YES;
            [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:@"" baseURL:[NSURL URLWithString:@""]];
            [self.adView addSubview:webView];
            [self.adView bringSubviewToFront:_countingBtn];
        }else {
            self.adView.image = [UIImage imageNamed:_localImageName];
        }
        //添加点击广告监听,在此处添加，避免没有图片时点击区域依然跳转的发生
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToURL:)];
        self.adView.userInteractionEnabled = YES;
        [self.adView addGestureRecognizer:tap];
    }
}
-(void)setImageURL:(NSString *)imageURL
{
    _imageURL = imageURL;
    if (_imageURL) {
        SDWebImageManager* manager = [SDWebImageManager sharedManager];
        [manager loadImageWithURL:[NSURL URLWithString:_imageURL] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSData *imageData, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                self.adView.image = image;
                //添加点击广告监听,在此处添加，避免没有图片时点击区域依然跳转的发生
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToURL:)];
                self.adView.userInteractionEnabled = YES;
                [self.adView addGestureRecognizer:tap];
            }
        }];
    }
}
@end
