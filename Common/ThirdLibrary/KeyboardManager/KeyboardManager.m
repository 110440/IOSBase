//
//  KeyboardManager.m
//  QDYongGong
//
//  Created by tanson on 16/7/10.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import "KeyboardManager.h"

@interface KeyboardManager ()


@end

@implementation KeyboardManager

-(instancetype) init{
    if([super init]){
        self.isKeyboradShowNow = NO;
        
        NSNotificationCenter * nt = [NSNotificationCenter defaultCenter];
        [nt addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [nt addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void) keyboardWillChangeFrame:(NSNotification*)notification{
    [self handleKeyboard:notification];
}

-(void) keyboardWillHide:(NSNotification*)notification{
    self.isKeyboradShowNow = NO;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground ){
        return;
    }
    [self handleKeyboard:notification];
}

-(void) handleKeyboard:(NSNotification*)notification{
    
    NSDictionary * userInfo = notification.userInfo ;
    if (!userInfo){
        return;
    }
    
    CGSize screentSize = [UIScreen mainScreen].bounds.size;
    NSTimeInterval animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    CGRect frameBegin = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect frameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.noAnimateWhenKeyboardChange? self.noAnimateWhenKeyboardChange(frameEnd.size.height):nil;
    
    [UIView animateWithDuration:animationDuration delay:0 options: (animationCurve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        
        if ( CGRectGetMinY(frameBegin) >= screentSize.height) {
            //弹出
            self.keyboardheight = frameEnd.size.height;
            self.isKeyboradShowNow = YES;
            if (self.animateWhenKeyboardAppear){
                self.animateWhenKeyboardAppear(frameEnd.size.height);
            }
            
        }else {
            if (CGRectGetMinY(frameEnd) >= screentSize.height ){
                //消失
                self.isKeyboradShowNow = NO;
                if(self.animateWhenKeyboardDisappear){
                    self.animateWhenKeyboardDisappear(frameEnd.size.height);
                }
                
            }else{
                //大小改变
                self.isKeyboradShowNow = YES;
                self.keyboardheight = frameEnd.size.height;
                if (self.animateWhenKeyboardAppear){
                    self.animateWhenKeyboardAppear(frameEnd.size.height);
                }
            }
        }
        
    } completion:^(BOOL finished) {
        if (CGRectGetMinY(frameEnd) >= screentSize.height ){
            self.animateCompeledForDisappear? self.animateCompeledForDisappear(0):nil;
        }
        
    }];
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter ]removeObserver:self];
}

@end
