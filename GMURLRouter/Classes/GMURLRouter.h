//
//  GMURLRouter.h
//  GMURLRouter
//
//  Created by Gome on 2019/3/4.
//  Copyright © 2019年 Gome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GMSingleton.h"

NS_ASSUME_NONNULL_BEGIN

/*在推出时的回调 回调出URL param*/
typedef void(^GMRouterHandler)(NSDictionary * routerParams);

@interface GMURLRouter : NSObject
//创建一个单例
GMSingletonH(GMURLRouter);
/*获取当前控制器*/
-(UIViewController*)getCurrentController;
/*获取当前的导航控制器*/
-(UINavigationController*)getCurrentNaviController;


#pragma mark 路由模块注册
-(void)registerModules:(NSArray*)moduleArray;

#pragma mark 注册各个路由

/**
 *  注册 URLPattern 对应的 Handler，在 handler 中可以初始化 VC，然后对 VC 做各种操作
 *  @param URLPattern URLPattern
 *  @param routerclass routerclass 路由的类
 */

+ (void)registerURLPattern:(NSString *)URLPattern class:(NSString*)routerclass;
/**
 *  取消注册某个 URL Pattern
 *
 *  @param URLPattern URLPattern
 */
+ (void)deregisterURLPattern:(NSString *)URLPattern;

/*获取所有注册URLPattern*/
+(NSDictionary*)getAllURLPattern;

/*获取所有注册的模块*/
+(NSDictionary*)getAllRegisteredModule;

/**
 *  取消所有的路由 URL Pattern
 */
+ (void)deregisterAllURLPattern;

#pragma mark ############################## push ############################

/******************普通的控制器跳转******************************/
/*导航push*/
+(void)pushViewController:(UIViewController*)VC Animated:(BOOL)animated;
/*push推出页面  携带参数query*/
+ (void)pushViewController:(UIViewController *)viewController query:(NSDictionary* __nullable)query animated:(BOOL)animated;
/*push推出页面  携带参数query  callBack 回调参数*/
+ (void)pushViewController:(UIViewController *)viewController query:(NSDictionary* __nullable)query callBack:(void(^__nullable)(id context))callBack animated:(BOOL)animated;
/*导航push
 * VC 控制器名字
 * animated 是否动画显示
 */
+(void)pushViewControllerWithName:(NSString*)VCName Animated:(BOOL)animated;
/**
 *  push控制器
 *
 *  @param urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉
 *  @param query     存放参数
 *  @param callBack   存放回调
 */
+ (void)pushURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated callBack:(void (^)(id result))callBack;


#pragma mark --------  pop控制器 --------

/** pop掉一层控制器 */
+(void)popViewControllerAnimated:(BOOL)animated;
/** pop掉两层控制器 */
+(void)popTwiceViewControllerAnimated:(BOOL)animated;
/** pop掉times层控制器 */
+(void)popViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated;
/** pop到根层控制器 */
+(void)popToRootViewControllerAnimated:(BOOL)animated;
+ (void)popViewControllerWithTimes:(NSUInteger)times query:(NSDictionary*)query animated:(BOOL)animated;



#pragma mark --------  modal控制器 --------


#pragma mark ############################## 基本的present ############################
/*present页面无参数*/
+ (void)presentViewController:(UIViewController *)viewController animated: (BOOL)flag;
/*present页面 参数query*/
+ (void)presentViewController:(UIViewController *)viewController query:(NSDictionary* __nullable)param animated: (BOOL)flag;
/*present页面 参数query 回调callback*/
+ (void)presentViewController:(UIViewController *)viewController query:(NSDictionary* __nullable)param animated: (BOOL)flag completion:(void (^ __nullable)(id result))callback;
/*present页面 urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉  query     存放参数  回调callback*/
+ (void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated completion:(void (^ __nullable)(id result))completion;


#pragma mark --------  dismiss控制器 --------
/** dismiss掉1层控制器 */
+ (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion;
/** dismiss掉2层控制器 */
+ (void)dismissTwiceViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion;
/** dismiss掉times层控制器 */
+ (void)dismissViewControllerWithTimes:(NSUInteger)times animated: (BOOL)flag completion: (void (^ __nullable)(void))completion;
/** dismiss到根层控制器 */
+ (void)dismissToRootViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion;
/*dismiss 推出页面*/
+ (void)dismissViewControllerWithTimes:(NSUInteger)times query:(NSDictionary*)query animated: (BOOL)flag;

/*返回到对应的控制器*/
+(void)dismissToViewController:(NSString *)className animated:(BOOL)animated completion:(void(^ __nullable)(void))completion;

#pragma mark --------  模块之间方法调用 --------
+ (id)postModuleWithTarget:(NSString*)moduleStr action:(SEL)aSelector withObject:(id __nullable)obj callBackBlock:(void (^ __nullable)(id blockParam))block;

#pragma mark --------  根据URL 获取附加 --------
/**
 * 查找谁对某个 URL 感兴趣，如果有的话，返回一个 object
 *
 *  @param URL 带 Scheme，
 */
+ (id)objectForURL:(NSString *)URL;
@end

NS_ASSUME_NONNULL_END
