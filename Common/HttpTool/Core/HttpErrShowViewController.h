//
//  HttpErrShowViewController.h
//
//  Created by tanson on 2018/3/14.
//  Copyright © 2018年 kuaima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HttpErrShowViewController : UIViewController

@property (nonatomic,copy) NSString * html;

+(void) showErrWithHtmlStr:(NSString*)html;

@end
