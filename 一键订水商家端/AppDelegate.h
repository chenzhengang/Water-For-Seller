//
//  AppDelegate.h
//  一键订水商家端
//
//  Created by Chun Kong on 2018/7/22.
//  Copyright © 2018年 chenzhengang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

typedef enum JumpType
{
    Order_HOME_LOGIN = 0,
    Add_HOME_LOGIN ,
}MYJumpType;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

//设置后台任务
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (nonatomic, strong) NSTimer *myTimer;
//登录状态
@property (assign, nonatomic) BOOL isLogin;
//跳转状态（从哪跳转过来的）
@property (assign, nonatomic) MYJumpType jumpType;
@end

