//
//  TradeViewController.m
//  一键订水商家端
//
//  Created by Chun Kong on 2018/7/22.
//  Copyright © 2018年 chenzhengang. All rights reserved.
//

#import "TradeViewController.h"
#import "ViewController.h"
#import "Order.h"

@interface TradeViewController ()

@end

@implementation TradeViewController
extern NSMutableArray *mArray1;
- (void)viewDidLoad {
    //mArray1 =[[NSMutableArray alloc] initWithCapacity:30];  这样会清空的！
    //[self loadOrder];
    [super viewDidLoad];
    [self setupRefresh];
    self.view.backgroundColor = UIColor.whiteColor;
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, aiScreenWidth, 60)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    [navigationItem setTitle:@"订单"];
    [navigationBar pushNavigationItem:navigationItem animated:NO];     
    [self.view addSubview:navigationBar];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    //NSString *result0= [self getTrade];
    //self.tableView.dataSource = self ;
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    TradeTableViewCell *cell;
//    cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    if (!cell) {
//        cell = [[TradeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    }
    // Get a new or recycled cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    // Configure the cell...
    //NSLog(@"%@",mArray1[0]);
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.textLabel.numberOfLines = 0;
    Order *item = mArray1[indexPath.row];
    cell.textLabel.text = item.all;
    //cell.textLabel.text = [item description];
    //cell.textLabel.text = @"XXXXXXX";
    //Order *item = mArray1[indexPath.row];
    //cell.user.text = @"xiaoming";
    //cell.commodity.text = @"water";
    //cell.address.text = @"ZJU";
    //cell.phone.text = @"18867111100";
    //cell.textLabel.text = @"101";
    return cell;
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
    NSLog(@"refreshClick: -- 刷新触发");
    // 此处添加刷新tableView数据的代码
    [self getTrade];
    [refreshControl endRefreshing];
    [self.tableView reloadData];// 刷新tableView即可
    [self addToastWithString:@"刷新成功~" inView:self.view];
}

- (void)loadOrder
{
    Order *order = [[Order alloc]initWithOrderName:@"zhang"
                                  commodity:@"Water"
                                    address:@"32-101"
                                      phone:@"18867110000"];
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
    //NSLog(@"计算行数2");
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

- (void) addToastWithString:(NSString *)string inView:(UIView *)view {
    
    CGRect initRect = CGRectMake(0, NAVIGATION_BAR_HEIGHT+40, aiScreenWidth, 0);
    CGRect rect = CGRectMake(0, NAVIGATION_BAR_HEIGHT+40, aiScreenWidth, 22);
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
    
    CGRect initRect = CGRectMake(0, STATUS_BAR_HEIGHT + 44, aiScreenWidth, 0);
    //    label消失
    [UIView animateWithDuration:0.5 animations:^{
        
        label.frame = initRect;
    } completion:^(BOOL finished){
        
        [label removeFromSuperview];
    }];
}


@end
