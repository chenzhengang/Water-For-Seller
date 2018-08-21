//
//  UINavigationController+Cloudox.h
//  一键订水商家端
//
//  Created by Chun Kong on 2018/8/21.
//  Copyright © 2018年 chenzhengang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Cloudox)
@property (copy, nonatomic) NSString *cloudox;
- (void)setNeedsNavigationBackground:(CGFloat)alpha;
@end
