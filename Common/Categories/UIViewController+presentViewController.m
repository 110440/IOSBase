//
//  UIViewController+presentViewController.m
//  XiangFeiShu
//
//  Created by tanson on 2020/4/2.
//  Copyright © 2020 XiangFeiShu. All rights reserved.
//

#import "UIViewController+presentViewController.h"


@implementation UIViewController (presentViewController)

+ (void)load{
    [self swizzleInstanceMethod:@selector(presentViewController:animated:completion:) with:@selector(myPresentViewController:animated:completion:)];
}

- (void)myPresentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion{
    if(viewControllerToPresent.modalPresentationStyle == UIModalPresentationPageSheet){
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [self myPresentViewController:viewControllerToPresent animated:flag completion:completion];
}
    
@end
