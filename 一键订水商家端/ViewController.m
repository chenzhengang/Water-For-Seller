//
//  ViewController.m
//  一键订水商家端
//
//  Created by Chun Kong on 2018/7/22.
//  Copyright © 2018年 chenzhengang. All rights reserved.
//

#import "ViewController.h"
#import "TradeViewController.h"
#import <Lottie/Lottie.h>
#import "Order.h"
#import "OrderViewController.h"

@interface ViewController ()<UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation ViewController

NSString *result;
NSMutableArray *mArray2;
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置一些参数
    _nameTextField.layer.cornerRadius = 13;
    _nameTextField.layer.masksToBounds = true;
    _passwordTextField.layer.cornerRadius = 13;
    _passwordTextField.layer.masksToBounds = true;
    _submitButton.layer.cornerRadius = 8;
    _submitButton.layer.masksToBounds = true;
    mArray2 =[[NSMutableArray alloc] initWithCapacity:100];
     [self getTrade];
    // Do any additional setup after loading the view, typically from a nib.
//    LOTAnimationView *animation = [LOTAnimationView animationNamed:@"Boat_Loader"];
//    animation.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
//    animation.contentMode = UIViewContentModeScaleAspectFill;
//    animation.frame = self.view.bounds;
//    [self.view addSubview:animation];
//    [animation playWithCompletion:^(BOOL animationFinished) {
//        // Do Something
//    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Submit:(UIButton *)sender {
    //[self getTrade];
    //return ;
    //UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
//    OrderViewController *vc2=[[OrderViewController alloc] init];
//    [self presentViewController:vc2 animated:YES completion:nil];
    //UIViewController *vc2 = [board instantiateViewControllerWithIdentifier: @"TradeViewController"];
    //if([_nameTextField.text  isEqual: @"zju"] && [_passwordTextField.text isEqual: @"123"]){
    
    
    UIViewController *vc2=[[TradeViewController alloc] init];
        //要在之后TradeViewController中加入代理
        _nameTextField.hidden = true;
        _passwordTextField.hidden = true;
        _submitButton.hidden = true;
        //vc2.transitioningDelegate = self;
        [self presentViewController:vc2 animated:YES completion:nil];
//}
}

- (void)getTrade {
    //模拟器调试
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/IOS.php"];
    //mac 地址10.180.24.0
    //NSURL *url = [NSURL URLWithString:@"http://10.180.24.0/IOS.php"];
    
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
        for(int i = array.count-1;i>=0;i--){
            //NSString *x = array[1];
            //Order *order = [[Order alloc]initWithAll:array[i]];
            Order *order = [[Order alloc]initWithAll:array[i]];
            [mArray2 addObject:order];
            //一开始因为对all赋值所以输出了四个null！ 直接读all是可以的。
            //Order *order2 = mArray1[i];
            //NSLog(@"%@ %@",order.all,order2.all);
                            }
        //printf("个数 %lu",(unsigned long)array.count);
        
    }];
    [dataTask resume];
}



- (void)_close {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    LOTAnimationTransitionController *animationController = [[LOTAnimationTransitionController alloc] initWithAnimationNamed:@"water-loading"
                                                                                                              fromLayerNamed:@"outLayer"
                                                                                                                toLayerNamed:@"inLayer"
                                                                                                     applyAnimationTransform:NO];
    return animationController;
}

//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
//    LOTAnimationTransitionController *animationController = [[LOTAnimationTransitionController alloc] initWithAnimationNamed:@"vcTransition2"
//                                                                                                              fromLayerNamed:@"outLayer"
//                                                                                                                toLayerNamed:@"inLayer"
//                                                                                                     applyAnimationTransform:NO];
//    return animationController;
//}

@end
