//
//  BaseNavigationController.m
//  XiangFeiShu
//
//  Created by tanson on 2020/4/2.
//  Copyright © 2020 XiangFeiShu. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
    
    UIFont * font  = [UIFont systemFontOfSize:14];
    NSDictionary* dict = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:font};
    
    if (@available(iOS 13.0, *)) {
        UIBarButtonItemAppearance *  appearance =  self.navigationBar.standardAppearance.buttonAppearance.copy;
        appearance.normal.titleTextAttributes = dict;
        appearance.highlighted.titleTextAttributes = dict;
        self.navigationBar.standardAppearance.buttonAppearance = appearance;
        //self.navigationBar.standardAppearance.backgroundColor = [UIColor whiteColor];
        
        UIFont * titleFont  = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
        if(!titleFont) titleFont = [UIFont systemFontOfSize:20];
        NSDictionary* titleDict = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:titleFont};
        self.navigationBar.standardAppearance.titleTextAttributes = titleDict;
    }
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 判断上一个控制器和现在的控制器是不是同一个，如果是，返回。如果不是push到当前控制器，这就有效避免了同一个控制器连续push的问题
    if ([self.topViewController isEqual:viewController]) {
        return;
    }
    
    if (self.viewControllers.count > 0) {
        self.interactivePopGestureRecognizer.enabled = true;
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (navigationController.viewControllers.count == 1) {
        self.interactivePopGestureRecognizer.enabled  = false;
    }
}

- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer
{
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (self.view.gestureRecognizers.count > 0)
    {
        for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers)
        {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
            {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    return screenEdgePanGestureRecognizer;
}



- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

@end
