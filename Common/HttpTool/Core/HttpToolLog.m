//
//  HttpToolLog.m
//
//

#import "HttpToolLog.h"

static NSString * const kLxArrayBegin = @"[";
static NSString * const kLxArrayEnd = @"]";
static NSString * const kLxDictionaryBegin = @"{";
static NSString * const kLxDictionaryEnd = @"}";


@implementation HttpToolLog

+(void)Log:(NSString *)format, ...{
    
#ifdef HTTP_TOOL_DEBUG
    va_list args;
    va_start(args, format);
    NSString * str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    NSLog(@"%@",str);
#endif
}

@end


// 改变控制台输出中文乱码
#ifdef HTTP_TOOL_DEBUG

@implementation NSArray (PP)

- (NSString *)descriptionWithLocale:(id)locale {
    
    NSMutableString * string = [NSMutableString string];
    [string appendFormat:@"%@\n", kLxArrayBegin];
    NSUInteger count = self.count;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * temp = nil;
        if ([obj respondsToSelector:@selector(descriptionWithLocale:)]) {
            temp = [obj performSelector:@selector(descriptionWithLocale:) withObject:locale];
            temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"];
        } else {
            temp = [obj performSelector:@selector(description) withObject:nil];
            if ([obj isKindOfClass:[NSString class]]) {
                temp = [NSString stringWithFormat:@"\"%@\"", temp];
            }
        }
        [string appendFormat:@"\t%@", temp];
        if (idx+1 != count) {
            [string appendString:@","];
        }
        [string appendString:@"\n"];
    }];
    [string appendString:kLxArrayEnd];
    return string;
}

@end

@implementation NSDictionary (PP)

- (NSString *)descriptionWithLocale:(id)locale {
    
    NSMutableString * string = [NSMutableString string];
    [string appendFormat:@"%@\n", kLxDictionaryBegin];
    NSUInteger count = self.allKeys.count;
    NSArray * allKeys = self.allKeys;
    BOOL canCom = YES;
    for (id temp in allKeys) {
        if ([temp respondsToSelector:@selector(compare:)] == NO) {
            canCom = NO;
            break;
        }
    }
    if (canCom) {
        allKeys = [self.allKeys sortedArrayUsingSelector:@selector(compare:)];
    }
    for (id key in allKeys) {
        NSInteger index = [self.allKeys indexOfObject:key];
        id value = [self objectForKey:key];
        NSString * temp = nil;
        if ([value respondsToSelector:@selector(descriptionWithLocale:)]) {
            temp = [value performSelector:@selector(descriptionWithLocale:) withObject:locale];
            temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"];
        } else {
            temp = [value performSelector:@selector(description) withObject:nil];
            if ([value isKindOfClass:[NSString class]]) {
                temp = [NSString stringWithFormat:@"\"%@\"", temp];
            }
        }
        [string appendFormat:@"\t%@ = %@", key, temp];
        if (index+1 != count) {
            [string appendString:@";"];
        }
        [string appendString:@"\n"];
    }
    [string appendString:kLxDictionaryEnd];
    return string;
}
@end

#endif
