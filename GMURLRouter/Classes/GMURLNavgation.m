//
//  GMURLNavgation.m
//  GMURLRouter
//
//  Created by Gome on 2019/3/4.
//  Copyright © 2019年 Gome. All rights reserved.
//

#import "GMURLNavgation.h"
#import "UIViewController+GMURLRouter.h"

@implementation GMURLNavgation
GMSingletonM(GMURLNavgation);



#pragma mark ############################## push ############################
/*推入 某一个页面*/
+(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self pushViewController:viewController query:nil callBack:nil animated:animated];
}
/*push推入页面*/
+ (void)pushViewController:(UIViewController *)viewController query:(NSDictionary* __nullable)query animated:(BOOL)animated{
    [self pushViewController:viewController query:query callBack:nil animated:animated];
}

/*push推入 某一个页面*/
+ (void)pushViewController:(UIViewController *)viewController query:(NSDictionary* __nullable)query callBack:(void(^__nullable)(id context))callBack animated:(BOOL)animated{
    if(!viewController){
        NSLog(@"viewController 空对象");
        return;
    }
    
    if([viewController isKindOfClass:[UINavigationController class]]){
        [GMURLNavgation setRootViewController:viewController];
        return;
    }
    
    UINavigationController * nviController = [[GMURLNavgation sharedGMURLNavgation]getCurrentNaviController];
    if(nviController){
        //设置参数 或者回调
        [viewController setParam:query callBack:callBack];
        [nviController pushViewController:viewController animated:animated];
    }else{
        [GMURLNavgation setRootViewController:[[UINavigationController alloc]initWithRootViewController:viewController]];
    }
}

#pragma mark ############################## present  ############################

/*present页面无参数*/
+ (void)presentViewController:(UIViewController *)viewController animated: (BOOL)flag{
    [self presentViewController:viewController query:nil animated:flag];
}
/*present页面 参数query*/
+ (void)presentViewController:(UIViewController *)viewController query:(NSDictionary*)param animated: (BOOL)flag{
    [self presentViewController:viewController query:param animated:flag completion:nil];
}
/*present页面 参数query 回调callback*/
+ (void)presentViewController:(UIViewController *)viewController query:(NSDictionary*)query animated: (BOOL)flag completion:(void (^)(id result))callBack{
    if(!viewController){
        NSLog(@"viewController 空对象");
        return;
    }
    UIViewController * currentController = [[GMURLNavgation sharedGMURLNavgation]getCurrentViewController];
    if(currentController){
        //设置参数 或者回调
        [viewController setParam:query callBack:callBack];
        [currentController presentViewController:viewController animated:flag completion:nil];
    }else{
        [GMURLNavgation setRootViewController:viewController];
    }
}

/** pop掉一层控制器 */
+(void)popViewControllerAnimated:(BOOL)animated{
    [GMURLNavgation popViewControllerWithTimes:1 animated:YES];
}

/*推出 某一个页面*/
+ (void)popTwiceViewControllerAnimated:(BOOL)animated{
    [GMURLNavgation popViewControllerWithTimes:2 animated:animated];
}
/*推出任一级页面*/
+ (void)popViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated{
    UINavigationController * nviController = [GMURLNavgation sharedGMURLNavgation].getCurrentNaviController;
    if(nviController){
        NSInteger count = nviController.viewControllers.count;
        if(count>times){
            [nviController popToViewController:[nviController.viewControllers objectAtIndex:count-1-times] animated:animated];
        }else{
            NSLog(@"推出页面有问题");
        }
    }
}
+ (void)popViewControllerWithTimes:(NSUInteger)times query:(NSDictionary*)query animated:(BOOL)animated;{
    UIViewController * VC= [GMURLNavgation sharedGMURLNavgation].getCurrentViewController;
    if (VC.callBack) {
        VC.callBack(query);
    }
    [GMURLNavgation popViewControllerWithTimes:times animated:animated];
}

+ (void)popToRootViewControllerAnimated:(BOOL)animated{
   UINavigationController * nviController =  [[GMURLNavgation sharedGMURLNavgation]getCurrentNaviController];
    if(nviController){
        [nviController popToRootViewControllerAnimated:animated];
    }
}

/*dismiss 推出页面*/
+ (void)dismissTwiceViewControllerAnimated:(BOOL)flag completion:(void (^ __nullable)(void))completion{
    [GMURLNavgation dismissViewControllerWithTimes:2 animated:flag completion:completion];
}
/*推出任意层级的控制器*/
+ (void)dismissViewControllerWithTimes:(NSUInteger)times animated:(BOOL)flag completion:(void (^ __nullable)(void))completion{
    
    UIViewController * viewController =[[GMURLNavgation sharedGMURLNavgation]getCurrentViewController];
    if(viewController){
        while (times>1) {
            viewController = viewController.presentingViewController;
            times--;
        }
        [viewController dismissViewControllerAnimated:flag completion:completion];
    }
}

/*dismiss 推出页面*/
+ (void)dismissViewControllerWithTimes:(NSUInteger)times query:(NSDictionary*)query animated: (BOOL)flag{
    UIViewController * viewController =[[GMURLNavgation sharedGMURLNavgation]getCurrentViewController];
    if (viewController.callBack) {
        viewController.callBack(query);
    }
    [GMURLNavgation dismissViewControllerWithTimes:times animated:flag completion:nil];
}

/*返回到对应的根控制器*/
+ (void)dismissToRootViewControllerAnimated:(BOOL)flag completion:(void(^ __nullable)(void))completion{
    UIViewController * viewController = [GMURLNavgation sharedGMURLNavgation].getCurrentViewController;
    if (viewController) {
        //当前控制器存在 推出的控制器存在
        while (viewController.presentingViewController) {
            viewController = viewController.presentingViewController;
        }
        [viewController dismissViewControllerAnimated:flag completion:completion];
    }
}

/*返回到对应的控制器*/
+(void)dismissToViewController:(NSString *)className animated:(BOOL)animated completion:(void(^ __nullable)(void))completion{
    UIViewController * viewController = [GMURLNavgation sharedGMURLNavgation].getCurrentViewController;
    if (viewController) {
        //当前控制器存在
        if (NSClassFromString(className)!= nil&&[NSClassFromString(className)isKindOfClass:[UIViewController class]]) {
            while (![viewController isMemberOfClass:NSClassFromString(className)]&&viewController) {
                viewController = viewController.presentingViewController;
            }
            [viewController dismissViewControllerAnimated:animated completion:completion];
        }
    }
}

// 设置为根控制器
+ (void)setRootViewController:(UIViewController *)viewController{
    [GMURLNavgation sharedGMURLNavgation].getApplicationDelegate.window.rootViewController = viewController;
}

/*获取当前的导航控制器*/
-(UINavigationController*)getCurrentNaviController{
    return [self getCurrentViewController].navigationController;
}
/*获取当前控制器*/
-(UIViewController *)getCurrentViewController{
    UIViewController * rootViewController = [self getApplicationDelegate].window.rootViewController;
    return [self getCurrentControllerFrom:rootViewController];
}

/*从一个控制器 当中拿到当前控制器啊*/
-(UIViewController*)getCurrentControllerFrom:(UIViewController*)viewController{

    if([viewController isKindOfClass:[UINavigationController class]]){
        //如果是导航控制器
        UINavigationController * nviController = (UINavigationController*)viewController;
        if (nviController.presentedViewController) {
            //处理导航present页面
            return [self getCurrentControllerFrom:nviController.presentedViewController];
        }
        return [nviController.viewControllers lastObject];
    }else if ([viewController isKindOfClass:[UITabBarController class]]){
        //如果当前控制器是 Tabbar
        UITabBarController * tabbarController =(UITabBarController*)viewController;
        return [self getCurrentControllerFrom:tabbarController.selectedViewController];
    }else if (viewController.presentedViewController != nil){
        //如果当前是 普通的控制器
        return [self getCurrentControllerFrom:viewController.presentedViewController];
    }
    return viewController;
}


-(id<UIApplicationDelegate>)getApplicationDelegate{
    return [UIApplication sharedApplication].delegate;
}
@end
