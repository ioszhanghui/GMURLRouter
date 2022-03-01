//
//  GMViewController.m
//  GMURLRouter
//
//  Created by ioszhanghui@163.com on 11/29/2019.
//  Copyright (c) 2019 ioszhanghui@163.com. All rights reserved.
//

#import "GMViewController.h"
#import "GMSecondViewController.h"
#import "GMRouterDefault.h"


@interface GMViewController ()

@end

@implementation GMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"%s",__func__);
//    [self presentBaseVCWithParamWithCallback];
    [self pushBaseVCWithParamWithCallback];
    
}

-(void)presentBaseVC{
    
    NSLog(@"self:%@",self);
    GMSecondViewController * VC  =[GMSecondViewController new];
    VC.modalPresentationStyle = UIModalPresentationFullScreen;
    [GMURLRouter presentViewController:VC animated:YES];
    
}

-(void)presentBaseVCWithParam{
    
    NSLog(@"self:%@",self);
    GMSecondViewController * VC  =[GMSecondViewController new];
    VC.modalPresentationStyle = UIModalPresentationFullScreen;
    NSDictionary * param = @{
        @"type":@""
    };
    [GMURLRouter presentViewController:VC query:param animated:YES];
}

-(void)presentBaseVCWithParamWithCallback{
    
    NSLog(@"self:%@",self);
    GMSecondViewController * VC  =[GMSecondViewController new];
    VC.modalPresentationStyle = UIModalPresentationFullScreen;
    NSDictionary * param = @{
        @"type":@""
    };
//    [self presentViewController:VC animated:YES completion:nil];
    
    [GMURLRouter presentViewController:VC query:param animated:YES completion:^(id  _Nonnull result) {
        NSLog(@"result：%@",result);
    }];
}

-(void)pushBaseVCWithParamWithCallback{
    NSLog(@"self:%@",self);
    GMSecondViewController * VC  =[GMSecondViewController new];
    VC.modalPresentationStyle = UIModalPresentationFullScreen;
    NSDictionary * param = @{
        @"type":@""
    };
    [GMURLRouter pushViewController:VC query:param callBack:^(id  _Nonnull context) {
        NSLog(@"context：%@",context);
    } animated:YES];
}

@end
