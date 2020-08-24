//
//  WKWebViewController.h
//  YOY-iOS
//
//  Created by tanson on 2017/3/31.
//  Copyright © 2017年 YOY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTWKWebViewController : UIViewController

@property (nonatomic,copy) void (^titleChangeBlock)(NSString * t);

@property (nonatomic,strong) NSString * rootUrlStr;

-(instancetype) initWithUrlString:(NSString*)urlStr title:(NSString*)title;

@end
