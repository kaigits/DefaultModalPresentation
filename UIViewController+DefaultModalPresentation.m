//
//  UIViewController+DefaultModalPresentation.m
//
//  Created by zyk on 2019/10/12.
//

#import "UIViewController+DefaultModalPresentation.h"
#import "NSObject+Swizzle.h"

@implementation UIViewController (DefaultModalPresentation)

+ (void)load{
    if (@available(iOS 13.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self swizzleInstanceSelector:@selector(init) withNewSelector:@selector(df_init)];
        });
    }
}

- (instancetype)df_init{
    [self df_init];
    if (@available(iOS 13.0, *)) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

@end
