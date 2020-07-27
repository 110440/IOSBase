//
//  TTLabel.h
//  TTUI
//
//  Created by tanson on 2018/7/19.
//  Copyright © 2018年 tanson. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TTLabel : UILabel

/// 控制label内容的padding，默认为UIEdgeInsetsZero
@property(nonatomic,assign) UIEdgeInsets contentEdgeInsets;

//长按复制功能
-(void)setPerformCopyActionOnWithHighlightedBgColor:(UIColor*)bgColor;

@end
