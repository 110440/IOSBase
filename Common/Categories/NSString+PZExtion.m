//
//  NSString+PZExtion.m
//  OLive
//
//  Created by ZSW on 2019/7/30.
//  Copyright © 2019 oldManLive. All rights reserved.
//

#import "NSString+PZExtion.h"

@implementation NSString (PZExtion)

//链接转字典  （参数）
+ (NSDictionary *)dictionaryWithUrlString:(NSString *)urlStr
{
    if (urlStr && urlStr.length && [urlStr rangeOfString:@"?"].length == 1) {
        NSArray *array = [urlStr componentsSeparatedByString:@"?"];
        if (array && array.count == 2) {
            NSString *paramsStr = array[1];
            if (paramsStr.length) {
                NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
                NSArray *paramArray = [paramsStr componentsSeparatedByString:@"&"];
                for (NSString *param in paramArray) {
                    if (param && param.length) {
                        NSArray *parArr = [param componentsSeparatedByString:@"="];
                        if (parArr.count == 2) {
                            [paramsDict setObject:parArr[1] forKey:parArr[0]];
                        }
                    }
                }
                return paramsDict;
            }else{
                return nil;
            }
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

//传入 秒  得到 时分秒
- (NSString *)getHHMMSSFromSS {
    
    NSInteger seconds = [self integerValue];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
    
}

//传入 秒  得到 分秒
- (NSString *)getMMSSFromSS {
    
    NSInteger seconds = [self integerValue];
    
    //format of hour
    //    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60 + seconds/3600 * 60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    return format_time;
    
}

//传入 秒  得到 天:时:分:秒
- (NSString *)getDDHHMMSSFromSS {
    
    NSInteger seconds = [self integerValue];
    
    //format of day
    NSString *str_day = [NSString stringWithFormat:@"%ld",seconds/(24*3600)];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",(seconds%(24*3600))/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@:%@",str_day,str_hour,str_minute,str_second];
    
    return format_time;
    
}

//价格格式化 金额必须用标准会计表示方式(￥94,862.57).
+ (NSString *)stringChangeMoneyWithStr:(NSString *)str {
    
    // 判断是否null 若是赋值为0 防止崩溃
    if (([str isEqual:[NSNull null]] || str == nil)) {
        str = 0;
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    // 注意传入参数的数据长度，可用double
    NSString *money = [formatter stringFromNumber:[NSNumber numberWithDouble:[str doubleValue]]];
    
    money = [NSString stringWithFormat:@"¥%@",money];
    
    return money;
}

//字典转json
+ (NSString *)stringToJsonByDictionary:(NSDictionary *)dictionary {
    
    NSError *err = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&err];
    
    NSAssert(data != nil, @"请传入有效的字典");
    
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    json = [json stringByReplacingOccurrencesOfString:@" " withString:@""];
    json = [json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return json;
    
}

//数组转json
+ (NSString *)stringToJsonByArray:(NSArray <NSDictionary *>*)array {
    
    NSAssert(array.count > 0, @"请传入有效的数组");
    
    __block NSString *json = @"[";
    [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx != array.count - 1) {
           json = [NSString stringWithFormat:@"%@%@,",json,[self stringToJsonByDictionary:obj]];
        }else {
            json = [NSString stringWithFormat:@"%@%@",json,[self stringToJsonByDictionary:obj]];
        }
    }];
    json = [NSString stringWithFormat:@"%@%@",json,@"]"];
    return json;
    
}

//数组转json
+ (NSString *)stringToJsonByStringArray:(NSArray <NSString *>*)array {
    
    NSAssert(array.count > 0, @"请传入有效的数组");
    
    __block NSString *json = @"[";
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx != array.count - 1) {
            json = [NSString stringWithFormat:@"%@\"%@\",",json,obj];
        }else {
            json = [NSString stringWithFormat:@"%@\"%@\"",json,obj];
        }
    }];
    json = [NSString stringWithFormat:@"%@%@",json,@"]"];
    return json;
    
}

+ (NSString *)stringTransNullString:(NSString *)text {
    
    if ([text isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return text;
    
}

@end
