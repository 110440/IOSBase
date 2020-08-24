//
//  WeakScriptMessageDelegate.h
//  YiPingAudio
//
//  Created by tanson on 2018/1/16.
//  Copyright © 2018年 kuaima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end
