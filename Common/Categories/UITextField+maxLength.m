//
//  UITextField+maxLength.m
//  RenRenDa
//
//  Created by tanson on 2019/9/10.
//  Copyright © 2019 RenRenDa. All rights reserved.
//

#import "UITextField+maxLength.h"
#import <objc/runtime.h>


@implementation UITextField (maxLength)

-(void)setMaxLength:(NSInteger)max{
    
    objc_setAssociatedObject(self,@selector(setMaxLength:),@(max),OBJC_ASSOCIATION_ASSIGN);
    [self addTarget:self action:@selector(editChange:) forControlEvents:UIControlEventEditingChanged];
}

-(NSInteger)getMaxLength{
    NSNumber * max = objc_getAssociatedObject(self, @selector(setMaxLength:));
    return max.integerValue;
}

- (void)editChange:(UITextField*)textfield {
    NSInteger _maxLength = [self getMaxLength];
    NSString * msg = [NSString stringWithFormat:@"不能超过%ld个字符",_maxLength];
    NSString *toBeString = textfield.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textfield markedTextRange];
        UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (toBeString.length > _maxLength){
                [Utils showInfoMsg:msg];
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:_maxLength];
                if (rangeIndex.length == 1){
                    textfield.text = [toBeString substringToIndex:_maxLength];
                }else{
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _maxLength)];
                    textfield.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }else{
        if (toBeString.length > _maxLength){
            [Utils showInfoMsg:msg];
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:_maxLength];
            if (rangeIndex.length == 1){
                textfield.text = [toBeString substringToIndex:_maxLength];
            }else{
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0,_maxLength)];
                textfield.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

@end
