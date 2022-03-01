//
//  UIViewController+GMURLRouter.m
//  GMURLRouter
//
//  Created by 小飞鸟 on 2019/03/11.
//  Copyright © 2019 Gome. All rights reserved.
//

#import "UIViewController+GMURLRouter.h"
#import <objc/runtime.h>
#import "GMRouterConfig.h"


#define GMK_Str_Class(str) [str isKindOfClass:[NSString class]]
#define GMK_Str_Is_Valid(str) ((str) && (GMK_Str_Class(str)) && ([str length] > 0))


/// 是否NSDictionary类型（单独处理NSMutableDictionary）
#define GMK_Dic_Class(dic) [dic isKindOfClass:[NSDictionary class]]
/// 是否有效，不为空，且是NSDictionary类型，且count值大于0（单独处理NSMutableDictionary）
#define GMK_Dic_Is_Valid(dic) ((dic) && (GMK_Dic_Class(dic)) && ([dic count] > 0))


static const char URLoriginUrl; //原始路由
static const char URLpath; //访问路径
static const char URLparams; //页面传递参数
static const char CallBack; //回调

@implementation UIViewController (GMURLRouter)


#pragma mark ############################## setter  getter ############################

#pragma mark 添加属性

- (void)setOriginUrl:(NSURL *)originUrl {
    // 为分类设置属性值
    objc_setAssociatedObject(self, &URLoriginUrl,
                             originUrl,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSURL*)originUrl {
    // 获取分类的属性值
    return objc_getAssociatedObject(self, &URLoriginUrl);
}

- (NSString *)path {
    return objc_getAssociatedObject(self, &URLpath);
}

- (void)setPath:(NSURL *)path{
    objc_setAssociatedObject(self, &URLpath,
                             path,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)params {
    return objc_getAssociatedObject(self, &URLparams);
}

- (void)setParams:(NSDictionary *)params{
    objc_setAssociatedObject(self, &URLparams,
                             params,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setCallBack:(PageFreeblock)callBack{
    
    objc_setAssociatedObject(self, &CallBack,
                             callBack,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(PageFreeblock)callBack{
    return objc_getAssociatedObject(self, &CallBack);
}



#pragma mark ############################## function ############################

-(void)setParam:(NSDictionary*)query callBack:(void(^__nullable)(id context))callBack{
    self.params =query;
    self.callBack = callBack;
}



#pragma mark 创建当前跳转 控制器
+ (UIViewController *)initFromString:(NSString *)urlString fromConfig:(NSDictionary *)configDict callBack:(void (^)(id result))callBack{
    return [self initFromString:urlString withQuery:nil fromConfig:configDict callBack:callBack];
}

+ (UIViewController *)initFromString:(NSString *)urlString withQuery:(NSDictionary *)query fromConfig:(NSDictionary *)configDict callBack:(void (^)(id result))callBack{
    
    if (!GMK_Str_Is_Valid(urlString)) {
        //路由不合规
        return nil;
    }
    // 支持对中文字符的编码
    NSString *encodeStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [UIViewController initFromURL:[NSURL URLWithString:encodeStr] withQuery:query fromConfig:configDict callBack:callBack] ;
}

+ (UIViewController *)initFromURL:(NSURL *)url withQuery:(NSDictionary *)query fromConfig:(NSDictionary *)configDict callBack:(void (^)(id result))callBack{
    
    UIViewController *VC = nil;
    NSString *home;
    if(url.path == nil){ // 处理url,去掉有可能会拼接的参数
        home = [NSString stringWithFormat:@"%@://%@", url.scheme, url.host==nil? @"":url.host];
    }else{
        home = [NSString stringWithFormat:@"%@://%@%@", url.scheme, url.host==nil? @"":url.host,url.path==nil? @"":url.path];
    }
    
    if([configDict.allKeys containsObject:url.scheme]){ // 字典中的所有的key是否包含传入的协议头
        id config = [configDict objectForKey:url.scheme]; // 根据协议头取出值
         Class class = nil;
        if([config isKindOfClass:[NSDictionary class]]){ // 自定义的url情况
            NSDictionary *dict = (NSDictionary *)config;
            if([dict.allKeys containsObject:home]){
                NSDictionary * subConfig = (NSDictionary *)config[home];
                class =  NSClassFromString([subConfig objectForKey:GMRouterParamterClass]);// 根据key拿到对应的控制器名称
            }
        }
        if(class !=nil){
            VC = [[class alloc]init];
            if([VC respondsToSelector:@selector(open:withQuery: callBack:)]){
                [VC open:url withQuery:query callBack:callBack];
            }
        }
    }
    return VC;
}

- (void)open:(NSURL *)url withQuery:(NSDictionary *)query callBack:(void (^)(id result))callBack{
    self.path = [url path];
    self.originUrl = url;
    NSMutableDictionary * pathParam = [self paramsURL:url];
    
    // 如果自定义url后面有拼接参数,而且又通过query传入了参数,那么合并两个参数
    if (GMK_Dic_Is_Valid(query)) {
        [pathParam  addEntriesFromDictionary:query];
    }
    self.params = pathParam;
    if (callBack) {
        self.callBack = callBack;
    }
}


// 将url的参数部分转化成字典
- (NSMutableDictionary *)paramsURL:(NSURL *)url {
    
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    if (NSNotFound != [url.absoluteString rangeOfString:@"?"].location) {
        NSString *paramString = [url.absoluteString substringFromIndex:
                                 ([url.absoluteString rangeOfString:@"?"].location + 1)];
        
        NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&"];
        NSScanner* scanner = [[NSScanner alloc] initWithString:paramString];
        while (![scanner isAtEnd]) {
            NSString* pairString = nil;
            [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
            [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
            NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
            if (kvPair.count == 2) {
                NSString* key = [[kvPair objectAtIndex:0] stringByRemovingPercentEncoding];
                NSString* value = [[kvPair objectAtIndex:1] stringByRemovingPercentEncoding];
                [pairs setValue:value forKey:key];
            }
        }
    }
    return pairs;
}

@end
