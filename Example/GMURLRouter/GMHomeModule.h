//
//  GMHomeModule.h
//  GMURLRouter_Example
//
//  Created by orange on 2022/3/1.
//  Copyright © 2022 ioszhanghui@163.com. All rights reserved.
//

//#import <GMURLRouter/GMURLRouter.h>
#import "BaseModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface GMHomeModule : BaseModule

-(void)testFunWithOutParam;
-(void)testFunWithOutParamWith:(NSDictionary*)dict ;
-(void)testFunWithOutParamWith:(NSDictionary*)dict  callBlock:(void(^)(id result))callback;

@end

NS_ASSUME_NONNULL_END
