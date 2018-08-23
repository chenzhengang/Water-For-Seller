//
//  OrderViewController.m
//  一键订水商家端
//
//  Created by Chun Kong on 2018/8/16.
//  Copyright © 2018年 chenzhengang. All rights reserved.
//

#import "OrderViewController.h"
#import "Masonry/Masonry.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface OrderViewController ()
//@property (nonatomic, strong) UILabel *nameLabel;
//@property (nonatomic, strong) UILabel *commodityLabel;
//@property (nonatomic, strong) UILabel *addressLabel;
//@property (nonatomic, strong) UILabel *phoneLabel;
//用property的话要自己写初始化方法 分配内存 然后return xx
@end
//订单详情界面
@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSLog(@"OrderViewController viewDidLoad");
    self.view.backgroundColor = UIColor.whiteColor;
    //防止block中的循环引用 不需要  因为这是系统的block  所以不会导致引用循环
    __weak typeof(self) weakSelf = self;
    UILabel *idLabel = [UILabel new];
    UILabel *nameLabel = [UILabel new];
    UILabel *commodityLabel = [UILabel new];
    UILabel *addressLabel = [UILabel new];
    UILabel *phoneLabel = [UILabel new];
    UILabel *stateLabel = [UILabel new];
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    NSArray *array = [self.order.all componentsSeparatedByString:@" "];
    
    [idLabel setText:@"订单号："];
    idLabel.text = [NSString stringWithFormat:@"%@",array[0]];
    [nameLabel setText:@"姓名："];
    nameLabel.text = [NSString stringWithFormat:@"%@",array[1]];
    [commodityLabel setText:@"商品名："];
    commodityLabel.text = [NSString stringWithFormat:@"%@",array[2]];
    [addressLabel setText:@"地址："];
    addressLabel.text = [NSString stringWithFormat:@"%@",array[3]];
    [phoneLabel setText:@"联系电话："];
    phoneLabel.text = [NSString stringWithFormat:@"%@",array[4]];
    [stateLabel setText:@"状态："];
    stateLabel.text = [NSString stringWithFormat:@"%@",array[5]];
    [sendButton setTitle:@"发货" forState:UIControlStateNormal];
    [self.view addSubview:idLabel];
    [self.view addSubview:nameLabel];
    [self.view addSubview:commodityLabel];
    [self.view addSubview:addressLabel];
    [self.view addSubview:phoneLabel];
    [self.view addSubview:stateLabel];
    [self.view addSubview:sendButton];
    //添加了之后才能设置
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 20));
        make.centerX.equalTo(weakSelf.view).with.offset(-50);
        //make.centerY.equalTo(weakSelf.view).with.offset(-20);
        //上边界距离上层view的上边界50
        make.top.mas_equalTo(0).with.offset(150);
//        make.centerY.equalTo(weakSelf.view).with.offset(2);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 20));
        make.centerX.equalTo(weakSelf.view).with.offset(-50);
        make.top.equalTo(idLabel.mas_bottom).with.offset(50);
        //make.centerY.equalTo(weakSelf.view).with.offset(0);
        //        make.centerY.equalTo(weakSelf.view).with.offset(2);
    }];
    [commodityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 20));
        make.centerX.equalTo(weakSelf.view).with.offset(-50);
        make.top.equalTo(nameLabel.mas_bottom).with.offset(50);
        //make.centerY.equalTo(weakSelf.view).with.offset(0);
        //        make.centerY.equalTo(weakSelf.view).with.offset(2);
    }];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 20));
        make.centerX.equalTo(weakSelf.view).with.offset(-50);
        make.top.equalTo(commodityLabel.mas_bottom).with.offset(50);
        //        make.centerY.equalTo(weakSelf.view).with.offset(2);
    }];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 20));
        make.centerX.equalTo(weakSelf.view).with.offset(-50);
        make.top.equalTo(addressLabel.mas_bottom).with.offset(50);
        //        make.centerY.equalTo(weakSelf.view).with.offset(2);
    }];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 20));
        make.centerX.equalTo(weakSelf.view).with.offset(-50);
        make.top.equalTo(phoneLabel.mas_bottom).with.offset(50);
        //        make.centerY.equalTo(weakSelf.view).with.offset(2);
    }];
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.centerX.equalTo(weakSelf.view).with.offset(0);
        make.top.equalTo(stateLabel.mas_bottom).with.offset(100);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
