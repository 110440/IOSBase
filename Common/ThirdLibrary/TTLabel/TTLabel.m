//
//  TTLabel.m
//  TTUI
//
//  Created by tanson on 2018/7/19.
//  Copyright © 2018年 tanson. All rights reserved.
//


#import "TTLabel.h"

#define UIColorMake(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface TTLabel()

@property(nonatomic, strong) UILongPressGestureRecognizer *longGestureRecognizer;
@property(nonatomic, assign) BOOL canPerformCopyAction;
@property(nonatomic, strong) UIColor * highlightedBgColor;
@property(nonatomic, strong) UIColor * originalBackgroundColor;

@end

@implementation TTLabel

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    _contentEdgeInsets = contentEdgeInsets;
    [self invalidateIntrinsicContentSize];
}

- (CGSize)sizeThatFits:(CGSize)size {
    size = [super sizeThatFits:CGSizeMake(size.width - (self.contentEdgeInsets.left + self.contentEdgeInsets.right), size.height - (self.contentEdgeInsets.top + self.contentEdgeInsets.bottom))];
    size.width += (self.contentEdgeInsets.left + self.contentEdgeInsets.right);
    size.height += (self.contentEdgeInsets.top + self.contentEdgeInsets.bottom);
    return size;
}

- (CGSize)intrinsicContentSize {
    CGFloat preferredMaxLayoutWidth = self.preferredMaxLayoutWidth;
    if (preferredMaxLayoutWidth <= 0) {
        preferredMaxLayoutWidth = CGFLOAT_MAX;
    }
    return [self sizeThatFits:CGSizeMake(preferredMaxLayoutWidth, CGFLOAT_MAX)];
}

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.contentEdgeInsets)];
}

#pragma mark - 长按复制功能

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    self.originalBackgroundColor = backgroundColor;
}

-(void)setPerformCopyActionOnWithHighlightedBgColor:(UIColor*)bgColor{
    _originalBackgroundColor = self.backgroundColor;
    _highlightedBgColor = bgColor? :UIColorMake(238, 239, 241);
    _canPerformCopyAction = YES;
    if (_canPerformCopyAction && !self.longGestureRecognizer) {
        self.userInteractionEnabled = YES;
        self.longGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureRecognizer:)];
        [self addGestureRecognizer:self.longGestureRecognizer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMenuWillHideNotification:) name:UIMenuControllerWillHideMenuNotification object:nil];

    } else if (!_canPerformCopyAction && self.longGestureRecognizer) {
        [self removeGestureRecognizer:self.longGestureRecognizer];
        self.longGestureRecognizer = nil;
        self.userInteractionEnabled = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (BOOL)canBecomeFirstResponder {
    return self.canPerformCopyAction;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if ([self canBecomeFirstResponder]) {
        return action == @selector(copyString:);
    }
    return NO;
}

- (void)copyString:(id)sender {
    if (self.canPerformCopyAction) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        if (self.text) {
            pasteboard.string = self.text;
        }
    }
}

- (void)handleLongPressGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (!self.canPerformCopyAction) {
        return;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyString:)];
        [[UIMenuController sharedMenuController] setMenuItems:@[copyMenuItem]];
        [menuController setTargetRect:self.frame inView:self.superview];
        [menuController setMenuVisible:YES animated:YES];
        [super setBackgroundColor:self.highlightedBgColor];
    } else if (gestureRecognizer.state == UIGestureRecognizerStatePossible) {
        [super setBackgroundColor:self.originalBackgroundColor];
    }
}

- (void)handleMenuWillHideNotification:(NSNotification *)notification {
    if (!self.canPerformCopyAction) {
        return;
    }
    [super setBackgroundColor:self.originalBackgroundColor];
}


@end
