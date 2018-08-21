//
//  UINavigationController+Cloudox.m
//  一键订水商家端
//
//  Created by Chun Kong on 2018/8/21.
//  Copyright © 2018年 chenzhengang. All rights reserved.
//

#import "UINavigationController+Cloudox.h"
#import <objc/runtime.h>
#import "UIViewController+Cloudox.h"

@implementation UINavigationController (Cloudox)
// 设置导航栏背景透明度
- (void)setNeedsNavigationBackground:(CGFloat)alpha {
    // 导航栏背景透明度设置
    UIView *barBackgroundView = [[self.navigationBar subviews] objectAtIndex:0];// _UIBarBackground
    UIImageView *backgroundImageView = [[barBackgroundView subviews] objectAtIndex:0];// UIImageView
    if (self.navigationBar.isTranslucent) {
        if (backgroundImageView != nil && backgroundImageView.image != nil) {
            barBackgroundView.alpha = alpha;
        } else {
            UIView *backgroundEffectView = [[barBackgroundView subviews] objectAtIndex:1];// UIVisualEffectView
            if (backgroundEffectView != nil) {
                backgroundEffectView.alpha = alpha;
            }
        }
    } else {
        barBackgroundView.alpha = alpha;
    }
    
    // 对导航栏下面那条线做处理
    self.navigationBar.clipsToBounds = alpha == 0.0;
}
//定义常量 必须是C语言字符串
static char *CloudoxKey = "CloudoxKey";

-(void)setCloudox:(NSString *)cloudox{
    /*
     OBJC_ASSOCIATION_ASSIGN;            //assign策略
     OBJC_ASSOCIATION_COPY_NONATOMIC;    //copy策略
     OBJC_ASSOCIATION_RETAIN_NONATOMIC;  // retain策略
     
     OBJC_ASSOCIATION_RETAIN;
     OBJC_ASSOCIATION_COPY;
     */
    /*
     * id object 给哪个对象的属性赋值
     const void *key 属性对应的key
     id value  设置属性值为value
     objc_AssociationPolicy policy  使用的策略，是一个枚举值，和copy，retain，assign是一样的，手机开发一般都选择NONATOMIC
     objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);
     */
    
    objc_setAssociatedObject(self, CloudoxKey, cloudox, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)cloudox{
    return objc_getAssociatedObject(self, CloudoxKey);
}

//+ (void)initialize {
//    if (self == [UINavigationController self]) {
//        // 交换方法
//        SEL originalSelector = NSSelectorFromString(@"_updateInteractiveTransition:");
//        SEL swizzledSelector = NSSelectorFromString(@"et__updateInteractiveTransition:");
//        Method originalMethod = class_getInstanceMethod([self class], originalSelector);
//        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
@end
