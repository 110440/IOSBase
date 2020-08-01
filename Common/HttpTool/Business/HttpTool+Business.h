//
//  HttpTool+Business.h
//  YiPingAudio
//
//  Created by tanson on 2018/3/19.
//  Copyright © 2018年 kuaima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpTool.h"

@interface HttpTool(Business)

+(NSDictionary*)commonHttpHeads;
+(NSDictionary*)commonParams;

+(void)recvePostResponseWithTask:(NSURLSessionTask*)task;
+(id)prepareBusinessJson1:(NSDictionary *)jsonObj path:(NSString*)path;

@end
