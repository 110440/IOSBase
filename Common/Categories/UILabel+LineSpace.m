//
//  UILabel+LineSpace.m
//  DuoBao
//
//  Created by tanson on 2017/8/24.
//  Copyright © 2017年 tanson. All rights reserved.
//

#import "UILabel+LineSpace.h"

@implementation UILabel (LineSpace)


-(void) setLineSpace:(CGFloat)space{
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:space];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.text length])];
    [self setAttributedText:attributedString1];
    [self sizeToFit];
}

@end
