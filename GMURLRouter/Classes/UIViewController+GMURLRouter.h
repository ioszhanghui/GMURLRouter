//
//  UIViewController+GMURLRouter.h
//  GMURLRouter
//
//  Created by 小飞鸟 on 2019/03/11.
//  Copyright © 2019 Gome. All rights reserved.
//

#import <UIKit/UIKit.h>

//跳转的回调
typedef void(^PageFreeblock)(_Nullable id context);

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (GMURLRouter)
/** 跳转后控制器能拿到的url */
@property(nonatomic, strong) NSURL * originUrl;
/** url路径 */
@property(nonatomic,copy) NSString * path;
/** 跳转后控制器能拿到的参数 */
@property(nonatomic,strong) NSDictionary *params;
/** 回调的控制器 */
@property(nonatomic,copy)PageFreeblock callBack;


//初始化 参数和回调block
-(void)setParam:(NSDictionary*)query callBack:(void(^__nullable)(id context))callBack;
// 根据参数创建控制器
+ (UIViewController *)initFromString:(NSString *)urlString fromConfig:(NSDictionary *)configDict callBack:( void (^ _Nullable)(id result))callBack;
// 根据参数创建控制器
+ (UIViewController *)initFromString:(NSString *)urlString withQuery:(NSDictionary * _Nullable)query fromConfig:(NSDictionary *)configDict callBack:(void (^ _Nullable)(id result))callBack;
@end

NS_ASSUME_NONNULL_END
