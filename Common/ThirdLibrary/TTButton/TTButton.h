//
//  TTButton.h
//  TTUI
//
//  Created by tanson on 2018/7/19.
//  Copyright © 2018年 tanson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TTBtnImagePosition) {
    TTBtnImagePositionLeft = 0,              //图片在左，文字在右，默认
    TTBtnImagePositionRight = 1,             //图片在右，文字在左
    TTBtnImagePositionTop = 2,               //图片在上，文字在下
    TTBtnImagePositionBottom = 3,            //图片在下，文字在上
};

IB_DESIGNABLE

@interface TTButton : UIButton

@property (nonatomic,assign) IBInspectable NSInteger imgPostion;
@property (nonatomic,assign) IBInspectable CGFloat spacing;

@end

