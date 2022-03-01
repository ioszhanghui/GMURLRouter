//
//  GMURLNavgation.h
//  GMURLRouter
//
//  Created by Gome on 2019/3/4.
//  Copyright © 2019年 Gome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMSingleton.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMURLNavgation : NSObject
GMSingletonH(GMURLNavgation);

/*获取当前的控制器*/
-(UIViewController*)getCurrentViewController;
/*获取当前的导航控制器*/
-(UINavigationController*)getCurrentNaviController;



#pragma mark ############################## push ############################

/*push推出页面  携带参数query*/
+ (void)pushViewController:(UIViewController *)viewController query:(NSDictionary* __nullable)query animated:(BOOL)animated;
/*push推出页面  无参数携带*/
+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
/*push推入  query 页面参数  callBack 回调  animated 弹出动画*/
+ (void)pushViewController:(UIViewController *)viewController query:(NSDictionary* __nullable)query callBack:(void(^__nullable)(id context))callBack animated:(BOOL)animated;


#pragma mark ############################## present ############################
/*present页面无参数*/
+ (void)presentViewController:(UIViewController *)viewController animated: (BOOL)flag;
/*present页面 参数query*/
+ (void)presentViewController:(UIViewController *)viewController query:(NSDictionary* __nullable)param animated: (BOOL)flag;
/*present页面 参数query 回调callback*/
+ (void)presentViewController:(UIViewController *)viewController query:(NSDictionary* __nullable)param animated: (BOOL)flag completion:(void (^ __nullable)(id result))callback;


#pragma mark ############################## pop ############################
/** pop掉一层控制器 */
+(void)popViewControllerAnimated:(BOOL)animated;
+ (void)popTwiceViewControllerAnimated:(BOOL)animated;
+ (void)popViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated;
+ (void)popToRootViewControllerAnimated:(BOOL)animated;


#pragma mark ############################## dismiss ############################
/*dismiss 推出页面*/
+ (void)dismissTwiceViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion;
/**/
+ (void)dismissViewControllerWithTimes:(NSUInteger)times animated: (BOOL)flag completion: (void (^ __nullable)(void))completion;
/*返回到对应的根控制器*/
+ (void)dismissToRootViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion;
/*返回到对应的控制器*/
+(void)dismissToViewController:(NSString *)className animated:(BOOL)animated completion:(void(^ __nullable)(void))completion;

@end


NS_ASSUME_NONNULL_END
