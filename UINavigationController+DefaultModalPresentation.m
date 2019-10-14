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
            [self swizzleInstanceSelector:@selector(viewDidLoad) withNewSelector:@selector(df_viewDidLoad)];
        });
    }
}

- (instancetype)df_viewDidLoad{
    [self df_viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}
@end
