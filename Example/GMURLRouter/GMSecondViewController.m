//
//  GMSecondViewController.m
//  GMURLRouter_Example
//
//  Created by orange on 2022/3/1.
//  Copyright © 2022 ioszhanghui@163.com. All rights reserved.
//

#import "GMSecondViewController.h"
#import "GMRouterDefault.h"
#import "GMThreeViewController.h"



@interface GMSecondViewController ()

@end

@implementation GMSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"params参数：%@",self.params);
    
    self.view.backgroundColor = [UIColor grayColor];
    self.title =@"present 2";
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(100, 100, 30, 30);
    [btn addTarget:self action:@selector(touchAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
    
    
    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn2.frame = CGRectMake(100, 300, 30, 30);
    [btn2 addTarget:self action:@selector(touchAction2) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn2];
    
    UIButton * btn3 = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn3.frame = CGRectMake(100, 400, 30, 30);
    [btn3 addTarget:self action:@selector(touchAction3) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn3];
    
}

-(void)touchAction3{
    [GMURLRouter postModuleWithTarget:@"GMHomeModule" action:NSSelectorFromString(@"testFunWithOutParam") withObject:@1 callBackBlock:nil];
    [GMURLRouter postModuleWithTarget:@"GMHomeModule" action:NSSelectorFromString(@"testFunWithOutParamWith:") withObject:@{@"1":@"1"} callBackBlock:nil];
    [GMURLRouter postModuleWithTarget:@"GMHomeModule" action:NSSelectorFromString(@"testFunWithOutParamWith:callBlock:") withObject:@{@"1":@"1"} callBackBlock:^(id  _Nonnull blockParam) {
        NSLog(@"blockParam：%@",blockParam);
    }];
//    [self presentViewController:VC animated:YES completion:nil];
}

-(void)touchAction2{
    
    NSLog(@"getCurrentController:%@",[GMURLRouter sharedGMURLRouter].getCurrentController);
    
    GMThreeViewController * VC = [GMThreeViewController new];
    VC.modalPresentationStyle = UIModalPresentationFullScreen;
    [GMURLRouter pushViewController:VC Animated:YES];
//    [self presentViewController:VC animated:YES completion:nil];
}

-(void)touchAction{
    NSLog(@"%s",__func__);
    NSLog(@"presentedViewController:%@",self.presentedViewController);
    NSLog(@"presentingViewController:%@",self.presentingViewController);
    
    if (self.callBack) {
        self.callBack(@{@"success":@"1"});
    }
    NSLog(@"childViewControllers:%@",self.childViewControllers);
    NSLog(@"getCurrentController:%@",[GMURLRouter sharedGMURLRouter].getCurrentController);
//    [GMURLRouter dismissViewControllerAnimated:YES completion:nil];
    
//    [GMURLRouter popViewControllerAnimated:YES];
    [GMURLRouter popViewControllerWithTimes:1 query:@{@"abc":@"abc"} animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];

}


@end
