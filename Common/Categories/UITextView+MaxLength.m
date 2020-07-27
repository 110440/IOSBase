//
//  UITextView+MaxLength.m
//  RenRenDa
//
//  Created by tanson on 2019/9/10.
//  Copyright © 2019 RenRenDa. All rights reserved.
//

#import "UITextView+MaxLength.h"
#import <objc/runtime.h>

@implementation UITextView (MaxLength)

-(void)setMaxLength:(NSInteger)max{
    
    objc_setAssociatedObject(self,@selector(setMaxLength:),@(max),OBJC_ASSOCIATION_ASSIGN);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tt_textViewDidChangeText:) name:UITextViewTextDidChangeNotification object:self];
}

-(NSInteger)getMaxLength{
    NSNumber * max = objc_getAssociatedObject(self, @selector(setMaxLength:));
    return max.integerValue;
}

- (void)tt_textViewDidChangeText:(NSNotification*)n {
    NSInteger _maxLength = [self getMaxLength];
    NSString * msg = [NSString stringWithFormat:@"不能超过%ld个字符",_maxLength];
    NSString *toBeString = self.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮选择部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > _maxLength) {
                [Utils showInfoMsg:msg];
                self.text = [toBeString substringToIndex:_maxLength];
            }
        } else { // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }

    }else{
        if (toBeString.length > _maxLength) {
            self.text = [toBeString substringToIndex:_maxLength];
            [Utils showInfoMsg:msg];
        }
    }
}


@end
