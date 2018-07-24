//
//  TradeViewController.h
//  一键订水商家端
//
//  Created by Chun Kong on 2018/7/22.
//  Copyright © 2018年 chenzhengang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define aiScreenWidth [UIScreen mainScreen].bounds.size.width
#define aiScreenHeight [UIScreen mainScreen].bounds.size.height
#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVIGATION_BAR_HEIGHT self.navigationController.navigationBar.frame.size.height
#define TAB_BAR_HEIGHT self.tabBarController.tabBar.frame.size.height

@interface TradeViewController : UITableViewController

@end
