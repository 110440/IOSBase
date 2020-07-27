//
//  TTButton.m
//  TTUI
//
//  Created by tanson on 2018/7/19.
//  Copyright © 2018年 tanson. All rights reserved.
//

#import "TTButton.h"

@interface TTButton()
@property (nonatomic,strong) UIColor * oldBgColor;
@property (nonatomic,strong) UIColor * oldBorderColor;
@end

@implementation TTButton


//-(void)setHighlighted:(BOOL)highlighted{
//    if(highlighted){
//        UIColor * hColor = [self colorFromColor:_oldBgColor toColor:[UIColor blackColor] progress:0.15];
//        [super setBackgroundColor:hColor];
//        if(self.layer.borderWidth > 0){
//            if(!_oldBorderColor){
//                _oldBorderColor = [UIColor colorWithCGColor:self.layer.borderColor];
//            }
//            UIColor * hColor2 = [self colorFromColor:_oldBorderColor toColor:[UIColor blackColor] progress:0.15];
//            self.layer.borderColor = hColor2.CGColor;
//        }
//    }else{
//        [super setBackgroundColor:_oldBgColor];
//        if(self.layer.borderWidth > 0){
//            self.layer.borderColor = _oldBorderColor.CGColor;
//        }
//    }
//}

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    _oldBgColor = backgroundColor;
}

- (UIColor *) colorFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress {
    progress = MIN(progress, 1.0f);
    CGFloat red; [fromColor getRed:&red green:0 blue:0 alpha:0];
    CGFloat green; [fromColor getRed:0 green:&green blue:0 alpha:0];
    CGFloat blue; [fromColor getRed:0 green:0 blue:&blue alpha:0];
    CGFloat alpha; [fromColor getRed:0 green:0 blue:0 alpha:&alpha];
    CGFloat fromRed = red;
    CGFloat fromGreen = green;
    CGFloat fromBlue = blue;
    CGFloat fromAlpha = alpha;
    
    CGFloat red2; [toColor getRed:&red2 green:0 blue:0 alpha:0];
    CGFloat green2; [toColor getRed:0 green:&green2 blue:0 alpha:0];
    CGFloat blue2; [toColor getRed:0 green:0 blue:&blue2 alpha:0];
    CGFloat alpha2; [toColor getRed:0 green:0 blue:0 alpha:&alpha2];
    CGFloat toRed = red2;
    CGFloat toGreen = green2;
    CGFloat toBlue = blue2;
    CGFloat toAlpha = alpha2;
    
    CGFloat finalRed = fromRed + (toRed - fromRed) * progress;
    CGFloat finalGreen = fromGreen + (toGreen - fromGreen) * progress;
    CGFloat finalBlue = fromBlue + (toBlue - fromBlue) * progress;
    CGFloat finalAlpha = fromAlpha + (toAlpha - fromAlpha) * progress;
    
    return [UIColor colorWithRed:finalRed green:finalGreen blue:finalBlue alpha:finalAlpha];
}

-(void)setImgPostion:(NSInteger)imgPostion{
    _imgPostion = imgPostion;
    [self setImagePosition:_imgPostion spacing:_spacing];
}

-(void)setSpacing:(CGFloat)spacing{
    _spacing = spacing;
    [self setImagePosition:_imgPostion spacing:_spacing];
}

- (void)setImagePosition:(TTBtnImagePosition)postion spacing:(CGFloat)spacing {
    
    [self setTitle:self.currentTitle forState:UIControlStateNormal];
    [self setImage:self.currentImage forState:UIControlStateNormal];
    
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat labelWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font].height;
#pragma clang diagnostic pop
    
    CGFloat imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2;//image中心移动的x距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
    CGFloat labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2;//label中心移动的x距离
    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
    
    CGFloat tempWidth = MAX(labelWidth, imageWidth);
    CGFloat changedWidth = labelWidth + imageWidth - tempWidth;
    CGFloat tempHeight = MAX(labelHeight, imageHeight);
    CGFloat changedHeight = labelHeight + imageHeight + spacing - tempHeight;
    
    switch (postion) {
        case TTBtnImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
            break;
            
        case TTBtnImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing/2), 0, imageWidth + spacing/2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
            break;
            
        case TTBtnImagePositionTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(imageOffsetY, -changedWidth/2, changedHeight-imageOffsetY, -changedWidth/2);
            break;
            
        case TTBtnImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(changedHeight-imageOffsetY, -changedWidth/2, imageOffsetY, -changedWidth/2);
            break;
            
        default:
            break;
    }
    [self layoutIfNeeded];
}

@end

