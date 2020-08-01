//
//  HttpToolLog.h
//
//

#import <Foundation/Foundation.h>

#define HTTP_TOOL_DEBUG 1

//#define HttpLog(format,...) NSLog(@"%@", [NSString stringWithFormat:format,##__VA_ARGS__] ) ;

@interface HttpToolLog : NSObject

+ (void) Log:(NSString *)format, ... ;

@end
