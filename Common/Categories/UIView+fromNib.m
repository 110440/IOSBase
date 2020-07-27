//
//  UIView+fromNib.m
//  XiangFeiShu
//
//  Created by tanson on 2020/4/2.
//  Copyright © 2020 XiangFeiShu. All rights reserved.
//

#import "UIView+fromNib.h"

@implementation UIView (fromNib)

+(instancetype)fromNib{
    NSBundle * bundle = [NSBundle bundleForClass:self];
    NSString * nibName = NSStringFromClass(self);
    return [bundle loadNibNamed:nibName owner:nil options:nil].firstObject;
}

@end
