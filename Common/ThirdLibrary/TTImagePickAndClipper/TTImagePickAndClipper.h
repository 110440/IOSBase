//
//  TTImagePickAndClipper.h
//  YiPingAudio
//
//  Created by tanson on 2018/7/23.
//  Copyright © 2018年 kuaima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTImagePickAndClipper : UIViewController

@property (nonatomic,copy) void (^completion)(UIImage * img);

@property (nonatomic,assign) CGSize cropSize;

+(instancetype)cameraPicker;
+(instancetype)photoLibraryPicker;

@end

/*
TTImagePickAndClipper * p = [[TTImagePickAndClipper alloc] init];
p.completion = ^(UIImage *img) {
    
};
[self presentViewController:p animated:YES completion:nil];
*/
