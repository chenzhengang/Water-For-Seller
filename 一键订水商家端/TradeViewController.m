//
//  TradeViewController.m
//  一键订水商家端
//
//  Created by Chun Kong on 2018/7/22.
//  Copyright © 2018年 chenzhengang. All rights reserved.
//

#import "TradeViewController.h"
#import "LoginViewController.h"
#import "OrderViewController.h"
#import "Order.h"
#import <Lottie/Lottie.h>
#import <AFNetworking.h>
#import <YYModel.h>
@interface TradeViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

//订单显示界面
@implementation TradeViewController
extern NSMutableArray *mArray2;
NSMutableArray *mArray1;
- (void)viewDidLoad {
    //mArray1 =[[NSMutableArray alloc] initWithCapacity:30];  这样会清空的！
    //[self loadOrder];
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
//    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, aiScreenWidth, 60)];
//    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"订单"];
//    [navigationBar pushNavigationItem:navigationItem animated:NO];
//    [self.view addSubview:navigationBar];
    self.navigationItem.title=@"订单";
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate =self;
    mArray1 =[[NSMutableArray alloc] initWithCapacity:50];
    [self getTrade];
    //[self AFNgetTrade];
    //[self AFNgetTrade_JSON];
    [self setupRefresh];
    [self.tableView reloadData];// 刷新tableView即可
    //去除tableview预留的空白
    //self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    Order *item = mArray1[indexPath.row];
    cell.textLabel.text = item.all;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:self];
    
    OrderViewController *vc2=[[OrderViewController alloc] init];
    //[navi pushViewController:vc2 animated:nil];
    vc2.order = mArray1[indexPath.row];
    [self.navigationController pushViewController:vc2 animated:YES];
}

- (void)setupRefresh {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshClick:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    [refreshControl beginRefreshing];
    [self refreshClick:refreshControl];
}
// 下拉刷新触发，在此获取数据
- (void)refreshClick:(UIRefreshControl *)refreshControl {
    //NSLog(@"refreshClick: -- 刷新触发");r
    // 此处添加刷新tableView数据的代码
    [self getTrade];
    //[self AFNgetTrade_JSON];
    [refreshControl endRefreshing];
    [self.tableView reloadData];// 刷新tableView即可
    //NSLog(@" %@",[mArray1 objectAtIndex:0]);
    [self addToastWithString:@"刷新成功~" inView:self.view];
}

- (void)loadOrder
{
    Order *order = [[Order alloc]initWithOrderName:@"zhang"
                                  commodity:@"Water"
                                    address:@"32-101"
                                      phone:@"18867110000"
                                             state:@"未发货"];
//    Order *order = [[Order alloc]initWithAll:@"zhang"];
    //[mArray1 insertObject:order atIndex:1];
    //mArray1[0]=order;
    [mArray1 addObject:order];
    NSLog(@"%@ %@",order,[mArray1 objectAtIndex:0]);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
// Incomplete implementation, return the number of sections
    //NSLog(@"计算倍数");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
// Incomplete implementation, return the number of rows
    //NSLog(@"%lu", (unsigned long)[mArray1 count]);
    return [mArray1 count];
}

- (void)getTrade {
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/IOS.php"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    //设置请求方式 POST
    request.HTTPMethod = @"POST";
    
    //设置请求的超时时间
    request.timeoutInterval = 60;
    
    NSString *user = @"ZJU";
    //%@用来打印对象
    request.HTTPBody = [[NSString stringWithFormat:@"User=%@",user] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    __block NSString *result;
    //4 创建网络任务 NSURLSessionTask
    //通过网络会话 来创建数据任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", result);
        //处理数据
        NSArray *array = [result componentsSeparatedByString:@"\n"];
        [mArray1 removeAllObjects];
        for(int i = array.count-1;i>=0;i--){
            //NSString *x = array[1];
            //Order *order = [[Order alloc]initWithAll:array[i]];
            Order *order = [[Order alloc]initWithAll:array[i]];
            [mArray1 addObject:order];
            //一开始因为对all赋值所以输出了四个null！ 直接读all是可以的。
            //Order *order2 = mArray1[i];
            //NSLog(@"%@ %@",order.all,order2.all);
        }
        //printf("个数 %lu",(unsigned long)array.count);
        
    }];
    [dataTask resume];
}

- (void) AFNgetTrade{
    //NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/IOS.php"];
    //注意这个URL参数是NSString
    NSString *URL= @"http://127.0.0.1/IOS.php";
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //AFN不支持text/html
    manager.responseSerializer = [AFJSONResponseSerializer new];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    //AFN它内部默认把服务器响应的数据当做json来进行解析，所以如果服务器返回给我的不是JSON数据那么请求报错，这个时候需要设置AFN对响应信息的解析方式。
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //2.创建参数
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"ZJU" forKey:@"User"];
    //[dict setObject:@"123" forKey:@"passward"];
    //3.发送POST请求
    [manager POST:URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //注意：responseObject:请求成功返回的响应结果（AFN内部已经把响应体转换为OC对象，通常是字典或数组）
        //把二进制数据解码
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"请求成功---%@\n",result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败---%@",error);
    }];
}

- (void) AFNgetTrade_JSON{
    //NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/IOS_JSON.php"];
    //注意这个URL参数是NSString
    NSString *URL= @"http://127.0.0.1/IOS_JSON.php";
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //AFN不支持text/html
    manager.responseSerializer = [AFJSONResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //2.创建参数
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"ZJU" forKey:@"User"];
    //[dict setObject:@"123" forKey:@"passward"];
    //3.发送POST请求
    [manager POST:URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //注意：responseObject:请求成功返回的响应结果（AFN内部已经把响应体转换为OC对象，通常是字典或数组）
        //NSLog(@"请求成功---%@",responseObject);
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"请求成功---%@",result);
        mArray1 = [NSArray yy_modelArrayWithClass:[Order class] json:result];
        NSLog(@"%@",mArray1);
        //Order *order = [Order yy_modelWithJSON:result];
        //NSLog(@"%@",orders[1]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败---%@",error);
    }];
}


- (void) addToastWithString:(NSString *)string inView:(UIView *)view {
    
    CGRect initRect = CGRectMake(0, STATUS_BAR_HEIGHT - 20, aiScreenWidth, 0);
    CGRect rect = CGRectMake(0, STATUS_BAR_HEIGHT - 20, aiScreenWidth, 22);
    UILabel* label = [[UILabel alloc] initWithFrame:initRect];
    label.text = string;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor colorWithRed:0 green:0.6 blue:0.9 alpha:0.6];
    
    [view addSubview:label];
    
    //弹出label
    [UIView animateWithDuration:0.5 animations:^{
        
        label.frame = rect;
        
    } completion:^ (BOOL finished){
        //弹出后持续1s
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(removeToastWithView:) userInfo:label repeats:NO];
    }];
}

- (void) removeToastWithView:(NSTimer *)timer {
    
    UILabel* label = [timer userInfo];
    
    CGRect initRect = CGRectMake(0, STATUS_BAR_HEIGHT - 20, aiScreenWidth, 0);
    //    label消失
    [UIView animateWithDuration:0.5 animations:^{
        
        label.frame = initRect;
    } completion:^(BOOL finished){
        
        [label removeFromSuperview];
    }];
}


@end
