//
//  NSString+PZExtion.h
//  OLive
//
//  Created by ZSW on 2019/7/30.
//  Copyright © 2019 oldManLive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PZExtion)

//链接转字典  （参数）
+ (NSDictionary *)dictionaryWithUrlString:(NSString *)urlStr;
//传入 秒  得到 xx:xx:xx
- (NSString *)getHHMMSSFromSS;
//传入 秒  得到 分秒
- (NSString *)getMMSSFromSS;
//传入 秒  得到 天:时:分:秒
- (NSString *)getDDHHMMSSFromSS;
//价格格式化 金额必须用标准会计表示方式(￥94,862.57).
+ (NSString *)stringChangeMoneyWithStr:(NSString *)str;
//字典转json
+ (NSString *)stringToJsonByDictionary:(NSDictionary *)dictionary;
//数组转json
+ (NSString *)stringToJsonByArray:(NSArray <NSDictionary *>*)array;
//数组转json
+ (NSString *)stringToJsonByStringArray:(NSArray <NSString *>*)array;
//将NSNull类型转换
+ (NSString *)stringTransNullString:(NSString *)text;

@end
