//
//  AppDelegate.m
//  一键订水商家端
//
//  Created by Chun Kong on 2018/7/22.
//  Copyright © 2018年 chenzhengang. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "LoginViewController.h"
#import "TradeViewController.h"
#import "MCLaunchAdView.h"
#import "MainViewController.h"

@interface AppDelegate ()
@property (nonatomic) dispatch_source_t badgeTimer;
@end

@implementation AppDelegate

NSUInteger num=0;//当前的订单数目
NSUInteger num0=0;//关闭之前的订单数目
NSUInteger num1=0;//发出通知时的订单数目
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    /*添加广告
     1.初始化，选择屏占比
     2.设置广告总时长，可跳过，默认是6秒
     3.启动计时器
     */
    MCLaunchAdView* view = [[MCLaunchAdView alloc] initWithWindow:self.window with:MCAdViewTypeFiveSixths];
    //显示本地图片
    //    view.localImageName = @"adImage_lion.png";
    //显示网络图片
    view.imageURL = @"http://imgsrc.baidu.com/forum/pic/item/65c1a9cc7b899e51371108904aa7d933c9950d56.jpg";
    
    [view setTimer:6];
    [view startTimer];
    view.clickBlock = ^(MCQuitLaunchAdStyle tag){
        MCQuitLaunchAdStyle style = MCQuitLaunchAdStyleDefault;
        switch (tag) {
            case MCQuitLaunchAdStyleTimeOut:{
                NSLog(@"%@",NSLocalizedString(@"时间耗尽", nil));
                style = MCQuitLaunchAdStyleTimeOut;
            }
                break;
            case MCQuitLaunchAdStyleSkip:{
                NSLog(@"%@",NSLocalizedString(@"跳过广告", nil));
                style = MCQuitLaunchAdStyleSkip;
            }
                break;
            case MCQuitLaunchAdStyleJumpToURL:{
                NSLog(@"%@",NSLocalizedString(@"进入广告", nil));
                style = MCQuitLaunchAdStyleJumpToURL;
            }
                break;
            default:{
                NSLog(@"%@",NSLocalizedString(@"未知原因", nil));
                style = MCQuitLaunchAdStyleDefault;
            }
                break;
        }
        //结束后再进入
        MainViewController* vc = [[MainViewController alloc] init];
        vc.view.backgroundColor = [UIColor whiteColor];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    };
    //打印mainbundle
    //NSDictionary* dict = [[NSBundle mainBundle] infoDictionary];
    //NSLog(@"%@",dict);

    
    // 注册通知
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
    }];
    
    /*
    //1、创建窗口
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    //2.创建一个导航控制器并添加子视图
    
    //UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[TradeViewController new]];
    UINavigationController *nav=[[UINavigationController alloc]init];
    nav.navigationBar.barTintColor = [UIColor blueColor];
    
    //[nav.navigationBarsetBackgroundImage:[UIImage imageNamed:@"00"]forBarMetrics:UIBarMetricsDefault];
    
    //3.设置根视图
    
    self.window.rootViewController = nav;
    
    //4、显示窗口
    
    [self.window makeKeyAndVisible];
    
    TradeViewController *vc = [[TradeViewController alloc] init];
    [nav pushViewController:vc animated:YES];
     */
    return YES;
}

//发出通知
- (void)addlocalNotificationForNewVersion {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:[NSString stringWithFormat:@"您有%lu个新的订单",num-num0] arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:@"点击查看" arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    content.badge = @3;
    //    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:alertTime repeats:NO];
    
    //通知触发机制。（重复提醒，时间间隔要大于60s）
//    UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];

    //创建UNNotificationRequest通知请求对象
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"OXNotification" content:content trigger:nil];
    
    //将通知加到通知中心
    [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
        NSLog(@"成功添加推送");
    }];
}

//设置定时检测订单
- (void)stratBadgeNumberCount{
    //[UIApplication sharedApplication].applicationIconBadgeNumber = 3;
    //创建定时器在主线程
    _badgeTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    //设置定时器执行规律
    //第二个是开始时间DISPATCH_TIME_NOW是现在  dispatch_walltime(const struct timespec *_Nullable when, int64_t delta),参数when可以为Null，默认为获取当前时间，参数delta为增量   注意时间要是 3 * NSEC_PER_SEC
    dispatch_source_set_timer(_badgeTimer, dispatch_walltime(NULL,3.0 * NSEC_PER_SEC), 3 * NSEC_PER_SEC, 3 * NSEC_PER_SEC);
    //设置定时器的动作
    dispatch_source_set_event_handler(_badgeTimer, ^{
        //[UIApplication sharedApplication].applicationIconBadgeNumber ++;
        [self getTrade];
        //有新订单
        if(num > num0 && num!=num1) {
            num1 = num;
            [self addlocalNotificationForNewVersion];
        }
        //NSLog(@"%lu",(unsigned long)num0);
        //但是没有显示
    });
    dispatch_resume(_badgeTimer);
}

- (void)startBgTask{
    UIApplication *application = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        //这里延迟的系统时间结束
        NSLog(@"%f",application.backgroundTimeRemaining);
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    //startBgTask用于延迟挂起
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init]; // 创建3个操作
    NSOperation *a = [NSBlockOperation blockOperationWithBlock:^{ [self getTrade]; NSLog(@"operationA---");}];
    NSOperation *b = [NSBlockOperation blockOperationWithBlock:^{ num0 = num ; NSLog(@"operationB---");}];
    // 添加依赖
    [b addDependency:a];
    // 执行操作
    [queue addOperation:a];
    [queue addOperation:b];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        num0 = num;
    });
    [self stratBadgeNumberCount];
    [self startBgTask];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//获取当前订单数目
- (void)getTrade {
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/IOS.php"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 60;
    NSString *user = @"ZJU";
    request.HTTPBody = [[NSString stringWithFormat:@"User=%@",user] dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    __block NSString *result;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *array = [result componentsSeparatedByString:@"\n"];
        num = array.count;
    }];
    [dataTask resume];
}

//通知中心
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
//
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    UNNotificationRequest *request = notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的消息内容
//    NSNumber *badge = content.badge;  // 推送消息的角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 推送消息的声音
//    NSString *subtitle = content.subtitle;  // 推送消息的副标题
//    NSString *title = content.title;  // 推送消息的标题
//
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        NSLog(@"iOS10 前台收到远程通知:%@", body);
//
//    } else {
//        // 判断为本地通知
//        NSLog(@"iOS10 前台收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
//    }
//    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
//
//}


@end
