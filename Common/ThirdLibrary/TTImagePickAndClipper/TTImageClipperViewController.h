//
//  TTImageClipperViewController.h
//  CroppingImage
//
//  Created by tanson on 2018/6/4.
//

#import <UIKit/UIKit.h>

@interface TTImageClipperViewController : UIViewController

@property (nonatomic,assign) CGSize cropSize;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,assign) BOOL needCircleCrop;

@property (nonatomic,copy) void (^completion)(UIImage*);
@property (nonatomic,copy) void (^didShowBlock)(void);
@property (nonatomic,copy) void (^willHideBlock)(void);

-(void)reLoadImage:(UIImage*)image;

@end
