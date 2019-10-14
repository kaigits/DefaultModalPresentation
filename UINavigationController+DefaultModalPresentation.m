//
//  UINavigationController+DefaultModalPresentation.m
//
//  Created by zyk on 2019/10/12.
//


#import "UINavigationController+DefaultModalPresentation.h"
#import "NSObject+Swizzle.h"
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
