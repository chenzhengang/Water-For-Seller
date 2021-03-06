//
//  Order.m
//  一键订水商家端
//
//  Created by Chun Kong on 2018/7/23.
//  Copyright © 2018年 chenzhengang. All rights reserved.
//

#import "Order.h"

//订单属性
@implementation Order

- (NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"%@ %@ %@ %@ %@",
         self.user,
         self.commodity,
         self.address,
         self.phone,
         self.state];
    return descriptionString;
}



- (instancetype)initWithAll:(NSString *)all
{
    self = [super init];
    if (self){
        self.all = all;
    }
    return self;
}

//- (NSString *)description
//{
//    NSString *descriptionString =
//    [[NSString alloc] initWithFormat:@"%@",
//     self.all];
//    return descriptionString;
//}

- (instancetype)initWithOrderName:(NSString *)user
                        commodity:(NSString *)commodity
                          address:(NSString *)address
                            phone:(NSString *)phone
                            state:(NSString *)state{
    self = [super init];
    if(self){
        self.user = user;
        self.commodity = commodity;
        self.address = address;
        self.phone = phone;
        self.state = state;
    }
        return self;
}
@end

