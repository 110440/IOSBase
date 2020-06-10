//
//  Utils.m
//  XiangFeiShu
//
//  Created by tanson on 2020/4/2.
//  Copyright © 2020 XiangFeiShu. All rights reserved.
//

#import "Utils.h"
#import "JXSDKHelper.h"
#import "JXMCSUserManager.h"

@implementation Utils


+ (UIViewController *)topViewController{
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+(UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

+(void)showLoading{
    [SVProgressHUD setMinimumDismissTimeInterval:CGFLOAT_MAX];
    [SVProgressHUD setMaximumDismissTimeInterval:CGFLOAT_MAX];
    //[SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    UIImage * loadImg = [UIImage imageNamed:@"comm_loading"];
    [SVProgressHUD setImageViewSize:CGSizeMake(60, 60)];
    [SVProgressHUD showImage:loadImg status:nil];
    //[SVProgressHUD showWithStatus:nil];
}
+(void)showLoadingWithMsg:(NSString*)msg{
    [self hideLoading];
    [SVProgressHUD showWithStatus:msg];
}
+(void)hideLoading{
    [SVProgressHUD dismiss];
    [SVProgressHUD setImageViewSize:CGSizeMake(28, 28)];
    [SVProgressHUD setMinimumDismissTimeInterval:5.0];
    [SVProgressHUD setMaximumDismissTimeInterval:1.0f];
}
+(void)showSuccMsg:(NSString *)msg{
    [self hideLoading];
    [SVProgressHUD showSuccessWithStatus:msg];
}
+(void)showErrMsg:(NSString *)msg{
    [self hideLoading];
    [SVProgressHUD showErrorWithStatus:msg];
}
+(void)showInfoMsg:(NSString *)msg{
    [self hideLoading];
    [SVProgressHUD showInfoWithStatus:msg];
}

+(void)showAlertWithTitle:(NSString *)title btn1:(NSString *)btn1 btn2:(NSString *)btn2 btn1Block:(void (^)(void))btn1Block btn2Block:(void (^)(void))btn2Block{
    
    UIAlertController * a = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * act0 = [UIAlertAction actionWithTitle:btn1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        btn1Block? btn1Block():nil;
    }];
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:btn2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        btn2Block? btn2Block():nil;
    }];
    [a addAction:act0];
    [a addAction:act1];
    [[self topViewController] presentViewController:a animated:YES completion:nil];
}

+ (void)showAlertWithTitle:(NSString*)title
                       msg:(NSString*)msg
                      btn1:(NSString*)btn1
                      btn2:(NSString*)btn2
                 btn1Block:(void(^)(void))btn1Block
                 btn2Block:(void(^)(void))btn2Block{
    
    UIAlertController * a = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * act0 = [UIAlertAction actionWithTitle:btn1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        btn1Block? btn1Block():nil;
    }];
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:btn2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        btn2Block? btn2Block():nil;
    }];
    [a addAction:act0];
    [a addAction:act1];
    [[self topViewController] presentViewController:a animated:YES completion:nil];
}

+(NSString*)timeStrFromInterval:(NSTimeInterval)interval{
    
    double secondsElapsed = floor(fmod(interval,60.0));
    double minutesElapsed = floor(fmod(interval/ 60.0,60.0));
    double hourElapsed = floor(interval/ 3600.0);
    
    NSString * hourStr = [NSString stringWithFormat:@"%.0f",hourElapsed].length >= 2? [NSString stringWithFormat:@"%.0f",hourElapsed]:[NSString stringWithFormat:@"0%.0f",hourElapsed];
    NSString * minutStr = [NSString stringWithFormat:@"%.0f",minutesElapsed].length >= 2? [NSString stringWithFormat:@"%.0f",minutesElapsed]:[NSString stringWithFormat:@"0%.0f",minutesElapsed];
    NSString * secondStr = [NSString stringWithFormat:@"%.0f",secondsElapsed].length >= 2? [NSString stringWithFormat:@"%.0f",secondsElapsed]:[NSString stringWithFormat:@"0%.0f",secondsElapsed];
    NSString * timeStr = [NSString stringWithFormat:@"%@:%@:%@",hourStr,minutStr,secondStr];
    return timeStr;
}

+(BOOL)isFirstInstallApp{
    id v = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_FIRST_INSTALL];
    if(!v){
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:KEY_FIRST_INSTALL];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return !v;
}

+(void)updateShopCartBadgeValue:(NSInteger)badgeValue{
    UITabBarController * root = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    UITabBarItem *tabItem = root.tabBar.items[3];
    if(badgeValue >0){
        tabItem.badgeValue = [NSString stringWithFormat:@"%ld",badgeValue];
    }else{
        tabItem.badgeValue = nil;
    }
}

+(void)pushJXServiceVC{
    
    UIViewController * top = [Utils topViewController];
    if(![[UserManager shareManager] isLogined]){
        [UserManager showLoginWithVc:top completion:^{}];
        return;
    }
    
    JXMCSUserManager * jxMgr = [JXMCSUserManager sharedInstance];
    JXMcsChatConfig * config = [JXMcsChatConfig defaultConfig];
    config.navTitleColor = [UIColor whiteColor];
    config.showMsgBoxItem = NO;
    
    if([jxMgr isLogin]){
        [[XFServiceViewController sharedController] hide];
        [jxMgr requestCSForUI:top.navigationController witConfig:config];
        return;
    }
    
    [sJXHUD showMessageWithActivityIndicatorView:@"正在登录..."];
    [jxMgr loginWithCallback:^(BOOL success, id response) {
        [sJXHUD hideHUD];
        if(success){
            [[XFServiceViewController sharedController] hide];
            [jxMgr requestCSForUI:top.navigationController witConfig:config];
        }else{
            [Utils showErrMsg:@"登陆失败"];
        }
    }];
}
@end
