//
//  TTImagePickAndClipper.m
//  YiPingAudio
//
//  Created by tanson on 2018/7/23.
//  Copyright © 2018年 kuaima. All rights reserved.
//

#import "TTImagePickAndClipper.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+TTImagePicker.h"
#import "TTImageClipperViewController.h"

@interface TTImagePickAndClipper ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic,assign) UIImagePickerControllerSourceType sourceType;
@property(nonatomic,strong) UIImagePickerController * imgPicker;
@property(nonatomic,strong) TTImageClipperViewController * clipper;

@end

@implementation TTImagePickAndClipper



+(instancetype)photoLibraryPicker{
    TTImagePickAndClipper * vc = [TTImagePickAndClipper new];
    vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    return vc;
}

+(instancetype)cameraPicker{
    TTImagePickAndClipper * vc = [TTImagePickAndClipper new];
    vc.sourceType = UIImagePickerControllerSourceTypeCamera;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgPicker.view.hidden = NO;
    self.imgPicker.navigationBar.translucent = NO;
}

-(UIImagePickerController *)imgPicker{
    if(!_imgPicker){
        UIImagePickerController * p = [UIImagePickerController new];
        p.delegate = self;
        p.mediaTypes = @[(NSString *)kUTTypeImage];
        p.sourceType = _sourceType;
        [self addChildViewController:p];
        [self.view addSubview:p.view];
        [p didMoveToParentViewController:self];
        _imgPicker = p;
    }
    return _imgPicker;
}

-(TTImageClipperViewController *)clipper{
    if(!_clipper){
        _clipper = [TTImageClipperViewController new];
        
        if(CGSizeEqualToSize(self.cropSize, CGSizeZero)){
            _clipper.cropSize = CGSizeMake(500, 500);
        }else{
            _clipper.cropSize = self.cropSize;
        }
        CGSize cropSize = _clipper.cropSize;
        __weak typeof(self) ws = self;
        _clipper.completion = ^(UIImage * img) {
            if(ws.completion){
                img = [img tt_imageByResizeToSize:cropSize];
                ws.completion(img);
            }
            [ws dismissViewControllerAnimated:YES completion:nil];
        };
        _clipper.didShowBlock = ^{
            if(ws.sourceType == UIImagePickerControllerSourceTypeCamera){
                [ws.imgPicker.view removeFromSuperview];
                [ws.imgPicker removeFromParentViewController];
                ws.imgPicker = nil;
            }
        };
        _clipper.willHideBlock = ^{
            if(ws.sourceType == UIImagePickerControllerSourceTypeCamera){
                ws.clipper.view.hidden = YES;
                ws.imgPicker.view.hidden = NO;
            }
        };
    }
    return _clipper;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _imgPicker.view.frame = self.view.bounds;
    if(self.sourceType == UIImagePickerControllerSourceTypeCamera){
        _clipper.view.frame = self.view.bounds;
    }
}

#pragma mark-

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * img = [info objectForKey:UIImagePickerControllerOriginalImage];
    img = [img tt_normalizedImage];
    self.clipper.image = img;
    
    if(self.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        TTImageClipperViewController *vc = self.clipper;
        self.clipper = nil;
        [self.imgPicker pushViewController:vc animated:YES];
    }else{
        if(!self.clipper.parentViewController){
            [self addChildViewController:self.clipper];
            [self.view addSubview:self.clipper.view];
        }
        self.clipper.view.hidden = NO;
        [self.clipper reLoadImage:img];
        [self.imgPicker.view removeFromSuperview];
        [self.imgPicker removeFromParentViewController];
        self.imgPicker = nil;
    }
}

-(void)dealloc{
    NSLog(@"==========dealloc");
}

@end
