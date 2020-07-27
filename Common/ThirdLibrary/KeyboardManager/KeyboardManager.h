//
//  KeyboardManager.h
//  QDYongGong
//
//  Created by tanson on 16/7/10.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^KeyboardEvenHandel)(CGFloat);

@interface KeyboardManager : NSObject


@property (nonatomic,assign) BOOL isKeyboradShowNow;
@property (nonatomic,assign) CGFloat keyboardheight;
@property (nonatomic,copy) KeyboardEvenHandel animateWhenKeyboardAppear; // change too
@property (nonatomic,copy) KeyboardEvenHandel animateWhenKeyboardDisappear;
@property (nonatomic,copy) KeyboardEvenHandel noAnimateWhenKeyboardChange;
@property (nonatomic,copy) KeyboardEvenHandel animateCompeledForDisappear;

@end
