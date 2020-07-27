//
//  BaseViewController.m
//  XiangFeiShu
//
//  Created by tanson on 2020/4/2.
//  Copyright © 2020 XiangFeiShu. All rights reserved.
//


#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)dealloc {
    NSLog(@"*****class:%@ title:%@ dealloc*****", [self class], self.title);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavbar];
    
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIScrollView class]]){
            if (@available(iOS 11.0, *)) {
                UIScrollView * s = obj;
                s.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
        }
    }];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    

    UIImage * bg = [UIImage imageNamed:@"navigation_bar_bj"];
    if([self showNavShadow]){
        if (@available(iOS 13.0, *)) {
            self.navigationController.navigationBar.standardAppearance.shadowImage = nil;
            self.navigationController.navigationBar.standardAppearance.backgroundImage = bg;
            
        }else{
            [self.navigationController.navigationBar setBackgroundImage:bg forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:nil];
        }
    }else{
        
        if (@available(iOS 13.0, *)) {
            self.navigationController.navigationBar.standardAppearance.shadowImage = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(1, 1)];
            self.navigationController.navigationBar.standardAppearance.backgroundImage = bg;
        }else{
            [self.navigationController.navigationBar setBackgroundImage:bg forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

+(void)setupAppearance{
    UIFont * font  = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    if(!font) font = [UIFont systemFontOfSize:15];
    NSDictionary* dict = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:font};
    [[UIBarButtonItem appearance] setTitleTextAttributes:dict forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:dict forState:UIControlStateHighlighted];
    
    [[UINavigationBar appearance] setBarTintColor:ColorWithHex(0x52973F)];
}

- (void)initNavbar{

    UIFont * titleFont  = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    if(!titleFont) titleFont = [UIFont systemFontOfSize:20];
    NSDictionary* titleDict = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:titleFont};
    self.navigationController.navigationBar.titleTextAttributes = titleDict;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

    
    if(self.navigationController.viewControllers.count > 1){
        UIImage * b = [[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithImage:b style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
        self.navigationItem.leftBarButtonItem = back;
    }

}



-(BOOL)showNavShadow{
    return NO;
}

-(void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
