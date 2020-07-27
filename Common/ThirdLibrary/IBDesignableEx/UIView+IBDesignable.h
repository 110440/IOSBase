//
//  UIView+IBDesignable.h
//  TTUI
//
//  Created by tanson on 2018/11/22.
//  Copyright © 2018年 tanson. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UIView (IBDesignable)

@property (assign, nonatomic) IBInspectable CGFloat tt_cornerRadius;
@property (nonatomic) IBInspectable UIColor *tt_borderColor;
@property (nonatomic) IBInspectable CGFloat tt_borderWidth;

@property (nonatomic) IBInspectable UIColor *tt_shadowColor;
@property (nonatomic) IBInspectable CGSize tt_shadowOffset;
@property (nonatomic) IBInspectable CGFloat tt_shadowOpacity;
@property (nonatomic) IBInspectable CGFloat tt_shadowRadius;

@end
