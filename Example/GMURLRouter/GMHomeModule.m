//
//  GMHomeModule.m
//  GMURLRouter_Example
//
//  Created by orange on 2022/3/1.
//  Copyright © 2022 ioszhanghui@163.com. All rights reserved.
//

#import "GMHomeModule.h"

@implementation GMHomeModule
-(void)testFunWithOutParam{
    NSLog(@"无参数调用");
    
}
-(void)testFunWithOutParamWith:(NSDictionary*)dict{
    NSLog(@"有参数调用:%@",dict);
    
}
-(void)testFunWithOutParamWith:(NSDictionary*)dict  callBlock:(void(^)(id result))callback{
    
    NSLog(@"有参数且调用:%@",dict);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (callback) {
            callback(@{@"key":@"value"});
        }
    });
}
@end
