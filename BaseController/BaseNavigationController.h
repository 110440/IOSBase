//
//  BaseNavigationController.h
//  XiangFeiShu
//
//  Created by tanson on 2020/4/2.
//  Copyright © 2020 XiangFeiShu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (nonatomic , strong) UIScreenEdgePanGestureRecognizer * screenEdgePanGestureRecognizer;

@end
