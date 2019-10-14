//
//  UINavigationController+DefaultModalPresentation.m
//
//  Created by zyk on 2019/10/12.
//


#import "UINavigationController+DefaultModalPresentation.h"
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (DMPSwizzle)

+ (void)swizzleInstanceSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector;

@end

@implementation NSObject (DMPSwizzle)

+ (void)swizzleInstanceSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector {
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method newMethod = class_getInstanceMethod(self, newSelector);
    
    BOOL methodAdded = class_addMethod([self class], originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (methodAdded) {
        class_replaceMethod([self class], newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

@end


@implementation UINavigationController (DefaultModalPresentation)
+ (void)load{
    if (@available(iOS 13.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self swizzleInstanceSelector:@selector(initWithRootViewController:) withNewSelector:@selector(df_initWithRootViewController:)];
        });
    }
}

- (instancetype)df_initWithRootViewController:(UIViewController *)rootVC {
    UINavigationController *nav = [self df_initWithRootViewController:rootVC];
    if (@available(iOS 13.0, *)) {
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return nav;
}
@end
