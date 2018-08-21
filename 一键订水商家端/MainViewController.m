//
//  MainViewController.m
//  一键订水商家端
//
//  Created by Chun Kong on 2018/8/21.
//  Copyright © 2018年 chenzhengang. All rights reserved.
//

#import "MainViewController.h"
#import "Masonry/Masonry.h"
#import "TradeViewController.h"
#import "UIViewController+Cloudox.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

//主菜单
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.image=[UIImage imageNamed:@"bg"];
    [self.view insertSubview:imageView atIndex:0];
    self.navigationItem.title=@"菜单";
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIButton *orderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [orderButton setTitle:@"查看订单" forState:UIControlStateNormal];
    [addButton setTitle:@"发布商品" forState:UIControlStateNormal];
    orderButton.titleLabel.font = [UIFont systemFontOfSize: 20.0];
    addButton.titleLabel.font = [UIFont systemFontOfSize: 20.0];
    [addButton setBackgroundColor:[UIColor clearColor]];
    [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [orderButton setBackgroundColor:[UIColor clearColor]];
    [orderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [orderButton addTarget:self action:@selector(orderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    [self.view addSubview:orderButton];
    //添加了之后才能设置

    [orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.size.mas_equalTo(CGSizeMake(150, 20));
        make.centerX.equalTo(self.view);
        //上边界距离上层view的上边界50
        //with是可以不用的
        make.top.mas_equalTo(0).offset(150);
    }];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.size.mas_equalTo(CGSizeMake(80, 40));
        make.centerX.equalTo(self.view).with.offset(0);
        make.top.equalTo(orderButton.mas_bottom).with.offset(100);
    }];
}

//ios11开始需要把对导航栏的设置放到viewWillAppear中！！否则会有适配问题
- (void)viewWillAppear:(BOOL)animated{
    // 设置导航栏透明度（通过使用category 使用runtime动态添加了一个透明度的属性）
    self.navBarBgAlpha = @"0.5";
    //导航栏设置透明  其实我们看见的是一张背景图片  所以设置他的bgcolor是没有用的  必须要设置图片
    //设置导航栏背景图片为一个空的image，这样就透明了
    //[self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    //[self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}


- (void)viewWillDisappear:(BOOL)animated{
    //    如果不想让其他页面的导航栏变为透明 需要重置
    self.navBarBgAlpha = @"1";
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addButtonClick:(UIButton *)btn{
    
}

- (void)orderButtonClick:(UIButton *)btn{
    TradeViewController* vc = [[TradeViewController alloc] init];
    //要通过导航进行push 而不能用present  否则无导航栏
    [self.navigationController pushViewController:vc animated:YES];
    //[self presentViewController:vc animated:YES completion:nil];
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
