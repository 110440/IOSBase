//
//  Utils.m
//  XiangFeiShu
//
//  Created by tanson on 2020/4/2.
//  Copyright © 2020 XiangFeiShu. All rights reserved.
//

#import "Utils.h"

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
    [SVProgressHUD showWithStatus:nil];
}
+(void)showLoadingWithMsg:(NSString*)msg{
    [SVProgressHUD showWithStatus:msg];
}
+(void)hideLoading{
    [SVProgressHUD dismiss];
}
+(void)showSuccMsg:(NSString *)msg{
    [SVProgressHUD showSuccessWithStatus:msg];
}
+(void)showErrMsg:(NSString *)msg{
    [SVProgressHUD showErrorWithStatus:msg];
}
+(void)showInfoMsg:(NSString *)msg{
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
    
//    NSInteger days = floor(interval/(3600*24));
//    NSInteger hours = floor(fmod(interval, (3600*24))/3600);
//    NSInteger minutes = floor(fmod(fmod(interval,(3600*24)),3600)/60);
//    NSInteger seconds = fmod(fmod(fmod(interval,(3600*24)),3600),60);
//
//    NSString * dayStr = [NSString stringWithFormat:@"%.2ld",days];
//    NSString * hourStr = [NSString stringWithFormat:@"%.2ld",hours];
//    NSString * minuteStr = [NSString stringWithFormat:@"%.2ld",minutes];
//    NSString * secStr = [NSString stringWithFormat:@"%.2ld",seconds];
    
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


//
//+(void)updateShopCartBadgeValue:(NSInteger)badgeValue{
//    UITabBarController * root = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//    UITabBarItem *tabItem = root.tabBar.items[3];
//    if(badgeValue >0){
//        tabItem.badgeValue = [NSString stringWithFormat:@"%ld",badgeValue];
//    }else{
//        tabItem.badgeValue = nil;
//    }
//}


+(NSString *)friendlyDateString:(NSTimeInterval)timeInterval
                forConversation:(BOOL)isShort{
    
    NSString * const FORMAT_PAST_SHORT = @"yyyy-MM-dd";
    NSString * const FORMAT_PAST_TIME = @"ahh:mm";
    NSString * const FORMAT_THIS_WEEK = @"eee ahh:mm";
    NSString * const FORMAT_THIS_WEEK_SHORT = @"eee";
    NSString * const FORMAT_YESTERDAY = @"ahh:mm";
    NSString * const FORMAT_TODAY = @"ahh:mm";
    
    //转为现在时间
    NSDate* theDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *output = nil;
    NSTimeInterval theDiff = -theDate.timeIntervalSinceNow;

    //上述时间差输出不同信息
    if (theDiff < 60) {
        output = @"刚刚";
    } else if (theDiff < 60 * 60) {
        int minute = (int) (theDiff / 60);
        output = [NSString stringWithFormat:@"%d分钟前", minute];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
        [formatter setLocale:locale];
        BOOL isTodayYesterday = NO;
        BOOL isPastLong = NO;

        if ([theDate isToday]) {
            [formatter setDateFormat:FORMAT_TODAY];
        } else if ([theDate isYesterday]) {
            [formatter setDateFormat:FORMAT_YESTERDAY];
            isTodayYesterday = YES;
        } else if ([theDate weekday]==[[NSDate date] weekday]) {
            if (isShort) {
                [formatter setDateFormat:FORMAT_THIS_WEEK_SHORT];
            } else {
                [formatter setDateFormat:FORMAT_THIS_WEEK];
            }
        } else {
          if(isShort) {
            [formatter setDateFormat:FORMAT_PAST_SHORT];
          } else {
            [formatter setDateFormat:FORMAT_PAST_TIME];
            isPastLong = YES;
          }
        }

        if (isTodayYesterday) {
            NSString *todayYesterday = @"昨天";
            if (isShort) {
                output = todayYesterday;
            } else {
                output = [formatter stringFromDate:theDate];
                output = [NSString stringWithFormat:@"%@ %@", todayYesterday, output];
            }
        } else {
            
            if (isPastLong) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateStyle = NSDateFormatterLongStyle;
                formatter.timeStyle = NSDateFormatterNoStyle;
                NSString *thePastDate = [formatter stringFromDate:theDate];
                output = [NSString stringWithFormat:@"%@ %@", thePastDate, output];
            }
        }
    }
    return output;
}

@end
