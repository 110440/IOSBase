//
//  DDPaoMaView.m
//  iphoneLive
//
//  Created by Mac on 2020/8/14.
//  Copyright © 2020 cat. All rights reserved.
//

#import "DDPaoMaView.h"

#define space 100

@implementation DDPaoMaView

-(void)setUpWithText:(NSString*)text{
    [self removeAllSubViews];
    
    CGSize size = self.size;
    
    UILabel * lab1 = [UILabel new];
    lab1.textColor = ColorWithHex(0xFF2898);
    lab1.text = text;
    [lab1 sizeToFit];
    lab1.height = size.height;
    [self addSubview:lab1];
    
    [self animateLab:lab1 start:0];
    
    CGFloat start = lab1.width + space;

    UILabel * lab2 = [UILabel new];
    lab2.textColor = ColorWithHex(0xFF2898);
    lab2.text = text;
    [lab2 sizeToFit];
    lab2.height = size.height;
    lab2.left = start;
    [self addSubview:lab2];

    [self animateLab:lab2 start:start];
}


-(void)animateLab:(UILabel*)lab start:(CGFloat)start{
    
    lab.left = start;
    CGFloat virtalWidth = lab.width + space;
    CGFloat duration = (virtalWidth + start)/70;
    WeakSelf
    [lab.layer removeAllAnimations];

    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        lab.left = -(virtalWidth);
    } completion:^(BOOL finished) {
        [weakSelf animateLab:lab start:lab.width + space];
    }];

}

@end
