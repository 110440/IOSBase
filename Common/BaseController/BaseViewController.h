//
//  BaseViewController.h
//  XiangFeiShu
//
//  Created by tanson on 2020/4/2.
//  Copyright © 2020 XiangFeiShu. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BaseViewController : UIViewController

/* params */
@property (nonatomic, strong) NSDictionary *params;
/* 在线客服按钮 */
@property (nonatomic, strong) UIControl *service;

+(void)setupAppearance;

-(BOOL)showNavShadow;
-(void)onBack;

@end
