//
//  UIImage+gradient.h
//  lindou
//
//  Created by tanson on 2019/1/22.
//  Copyright © 2019 lindou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (gradient)

+(UIImage*)tt_gradientWithSize:(CGSize)size from:(UIColor*)from to:(UIColor*)to;
+(UIImage *)tt_v_gradientWithSize:(CGSize)size from:(UIColor *)from to:(UIColor *)to;
+(UIImage *)tt_HomeBigBtnImageWithSize:(CGSize)size;

@end
