#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BaseModule.h"
#import "GMRouterConfig.h"
#import "GMRouterDefault.h"
#import "GMSingleton.h"
#import "GMURLNavgation.h"
#import "GMURLRouter.h"
#import "UIViewController+GMURLRouter.h"

FOUNDATION_EXPORT double GMURLRouterVersionNumber;
FOUNDATION_EXPORT const unsigned char GMURLRouterVersionString[];

