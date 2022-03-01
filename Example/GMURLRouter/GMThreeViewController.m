//
//  GMThreeViewController.m
//  GMURLRouter
//
//  Created by orange on 2022/3/1.
//  Copyright © 2022 ioszhanghui@163.com. All rights reserved.
//

#import "GMThreeViewController.h"
#import "GMRouterDefault.h"

@interface GMThreeViewController ()

@end

@implementation GMThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [GMURLRouter dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"getCurrentController:%@",[GMURLRouter sharedGMURLRouter].getCurrentController);
//    [GMURLRouter dismissTwiceViewControllerAnimated:YES completion:nil];
//    [GMURLRouter dismissViewControllerWithTimes:3 animated:YES completion:nil];
    
    [GMURLRouter popTwiceViewControllerAnimated:YES];
    
}

@end
