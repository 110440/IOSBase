//
//  Macro.h
//  XiangFeiShu
//
//  Created by tanson on 2020/4/2.
//  Copyright © 2020 XiangFeiShu. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

//颜色rgba
#define RGBAColor(r,g,b,a) [UIColor colorWithRed:r / 255.0 green: g/255.0 blue:b/255.0 alpha:a]

//颜色16进制
#define ColorWithHex(value)  [UIColor colorWithRed:((value & 0xFF0000)>>16)/255.0 green:((value & 0x00FF00)>>8)/255.0 blue:(value & 0x0000FF)/255.0 alpha:1.0]

//weakself
#define Weakself __weak typeof(self) weakSelf = self;

//#define  iPhoneX (kScreenWidth >= 375.f && kScreenHeight >= 812.f ? YES : NO)

#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define  kStatus_Height      (IPHONE_X ? 44.f : 20.f)

#define  kNav_Height  (IPHONE_X ? 88.f : 64.f)

#define  kTab_height         (IPHONE_X ? (49.f+34.f) : 49.f)
// 适配iPhone X Tabbar距离底部的距离
#define  kTabbarSafeBottomMargin         (IPHONE_X ? 34.f : 0.f)

//加载网络图片时默认颜色
#define kPlaceholderImage [UIImage imageWithColor:UIColorHex(0xF2F2F7)]

//格式化字符串
#define kStringFormat(fmt, ...) [NSString stringWithFormat:(fmt), ##__VA_ARGS__]

//字体大小
#define kStringFont(font) [UIFont systemFontOfSize:(font)]

//UIImage
#define kImageNamed(imageName) [UIImage imageNamed:(imageName)]


#endif /* Macro_h */
