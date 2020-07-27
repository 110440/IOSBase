//
//  UIView+IBDesignable.m
//  TTUI
//
//  Created by tanson on 2018/11/22.
//  Copyright © 2018年 tanson. All rights reserved.
//

#import "UIView+IBDesignable.h"


@implementation UIView (IBDesignable)


-(void)setTt_cornerRadius:(CGFloat)tt_cornerRadius{
    self.layer.cornerRadius = tt_cornerRadius;
    self.layer.masksToBounds = (tt_cornerRadius > 0);
}

-(CGFloat)tt_cornerRadius{
    return self.layer.cornerRadius;
}

-(void)setTt_borderColor:(UIColor *)tt_borderColor{
    self.layer.borderColor = tt_borderColor.CGColor;
}

-(UIColor *)tt_borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

-(void)setTt_borderWidth:(CGFloat)tt_borderWidth{
    self.layer.borderWidth = tt_borderWidth;
}

-(CGFloat)tt_borderWidth{
    return self.layer.borderWidth;
}


-(void)setTt_shadowColor:(UIColor *)tt_shadowColor{
    self.layer.shadowColor = tt_shadowColor.CGColor;
}
-(UIColor *)tt_shadowColor{
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}
-(void)setTt_shadowOffset:(CGSize)tt_shadowOffset{
    self.layer.shadowOffset = tt_shadowOffset;
}
-(CGSize)tt_shadowOffset{
    return self.layer.shadowOffset;
}
-(void)setTt_shadowRadius:(CGFloat)tt_shadowRadius{
    self.layer.shadowRadius = tt_shadowRadius;
}
-(CGFloat)tt_shadowRadius{
    return self.layer.shadowRadius;
}
-(void)setTt_shadowOpacity:(CGFloat)tt_shadowOpacity{
    self.layer.shadowOpacity = tt_shadowOpacity;
}
-(CGFloat)tt_shadowOpacity{
    return self.layer.shadowOpacity;
}


@end
