//
//  Order.h
//  一键订水商家端
//
//  Created by Chun Kong on 2018/7/23.
//  Copyright © 2018年 chenzhengang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property    NSString *user;
@property    NSString *commodity;
@property    NSString *address;
@property    NSString *phone;
@property    NSString *all;

- (instancetype)initWithOrderName:(NSString *)user
                        commodity:(NSString *)commodity
                          address:(NSString *)address
                            phone:(NSString *)phone;

- (instancetype)initWithAll:(NSString *)all;
@end
