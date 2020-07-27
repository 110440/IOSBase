//
//  UIImage+gradient.m
//  lindou
//
//  Created by tanson on 2019/1/22.
//  Copyright © 2019 lindou. All rights reserved.
//

#import "UIImage+gradient.h"

@implementation UIImage (gradient)

+(UIImage *)tt_gradientWithSize:(CGSize)size from:(UIColor *)from to:(UIColor *)to{
    
    CAGradientLayer * gradientLayer = [CAGradientLayer new];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    gradientLayer.colors = @[(__bridge id)from.CGColor,(__bridge id)to.CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint =  CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.5),@(1)];
    
    UIView * tempView = [[UIView alloc] initWithFrame:gradientLayer.frame];
    [tempView.layer addSublayer:gradientLayer];
    return tempView.snapshotImage;
}

+(UIImage *)tt_v_gradientWithSize:(CGSize)size from:(UIColor *)from to:(UIColor *)to{
    
    CAGradientLayer * gradientLayer = [CAGradientLayer new];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    gradientLayer.colors = @[(__bridge id)from.CGColor,(__bridge id)to.CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint =  CGPointMake(0, 1);
    gradientLayer.locations = @[@(0),@(1)];
    
    UIView * tempView = [[UIView alloc] initWithFrame:gradientLayer.frame];
    [tempView.layer addSublayer:gradientLayer];
    return tempView.snapshotImage;
}

+(UIImage *)tt_HomeBigBtnImageWithSize:(CGSize)size{
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,size.width,size.height);
    gl.startPoint = CGPointMake(0.39, 1);
    gl.endPoint = CGPointMake(0.39, -0.32);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:39/255.0 green:51/255.0 blue:65/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:95/255.0 green:114/255.0 blue:135/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    
    UIView * tempView = [[UIView alloc] initWithFrame:gl.frame];
    [tempView.layer addSublayer:gl];
    return tempView.snapshotImage;
}

@end
