//
//  TTImageClipperViewController.m
//  CroppingImage
//
//  Created by tanson on 2018/6/4.
//

#import "TTImageClipperViewController.h"

#define SCREENTRECT [UIScreen mainScreen].bounds
#define SCREENTSIZE [UIScreen mainScreen].bounds.size

@interface TTImageClipperViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *rectView;
@property (strong,nonatomic) UIImageView * imageView;
@property (weak, nonatomic) IBOutlet UIView *coverView;

@property (nonatomic,assign) CGRect cropRect;

@end

@implementation TTImageClipperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    if(CGSizeEqualToSize(_cropSize, CGSizeZero)){
        _cropSize = CGSizeMake(200, 200);
    }
    
    NSAssert(_image, @"image 不以为空! ================= ");
    
    [_scrollView addSubview:self.imageView];
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 3;
    _scrollView.zoomScale = 1;
    
    UIBezierPath *alphaPath = [UIBezierPath bezierPathWithRect:SCREENTRECT];
    UIBezierPath *squarePath = [UIBezierPath bezierPathWithRect:self.cropRect];
    if(_needCircleCrop){
        squarePath = [UIBezierPath bezierPathWithRoundedRect:self.cropRect cornerRadius:self.cropRect.size.width/2.0];
        self.rectView.layer.cornerRadius = self.cropRect.size.width/2.0;
    }
    [alphaPath appendPath:squarePath];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = alphaPath.CGPath;
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    self.coverView.layer.mask = shapeLayer;
    self.rectView.frame = self.cropRect;
    self.rectView.backgroundColor = [UIColor clearColor];
    self.rectView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.rectView.layer.borderWidth = 1;
    
    [self reLoadImage:self.image];
}

-(void)reLoadImage:(UIImage*)image{
    self.image = image;
    self.imageView.image = image;
    CGFloat scale = [self minimumScaleFromSize:_image.size toFitTargetSize:self.cropRect.size];
    CGSize  fitSize = CGSizeMake(_image.size.width * scale, _image.size.height * scale);
    self.imageView.frame = CGRectMake(0, 0, fitSize.width, fitSize.height);
    self.imageView.center = CGPointMake(SCREENTSIZE.width/2, SCREENTSIZE.height/2);
    _scrollView.contentSize = self.imageView.frame.size;
    [self setScrollViewOffset];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.didShowBlock? self.didShowBlock():nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(CGRect)cropRect{
    if(CGRectEqualToRect(_cropRect, CGRectZero)){
        CGSize screentSize = SCREENTSIZE;
        CGFloat fitWidth = screentSize.width - 10*2;
        CGFloat fitHeight = _cropSize.height/_cropSize.width * fitWidth;
        CGFloat x = (screentSize.width - fitWidth )/2;
        CGFloat y = (screentSize.height- fitHeight )/2;
        _cropRect = CGRectMake(x,y,fitWidth,fitHeight);
    }
    return _cropRect;
}
       
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        [_imageView setUserInteractionEnabled:YES];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        //_imageView.image = self.image;
    }
    return _imageView;
}

- (void)setScrollViewOffset
{
    CGRect  imgVFrame = self.imageView.frame;
    CGFloat imgToBottom = SCREENTSIZE.height - CGRectGetMaxY(imgVFrame);
    CGFloat imgToRight  = SCREENTSIZE.width - CGRectGetMaxX(imgVFrame);
    CGRect  rect = self.cropRect;
    CGFloat bottom = SCREENTSIZE.height - CGRectGetMaxY(self.cropRect) +imgToBottom;
    CGFloat right  = SCREENTSIZE.width  - CGRectGetMaxX(self.cropRect) +imgToRight;
    CGFloat top    = rect.origin.y - imgVFrame.origin.y;
    CGFloat left   = rect.origin.x - imgVFrame.origin.x;
    [self.scrollView setContentInset:UIEdgeInsetsMake(top, left, bottom, right)];
}

- (CGFloat)minimumScaleFromSize:(CGSize)size toFitTargetSize:(CGSize)targetSize{
    CGFloat widthScale = targetSize.width / size.width;
    CGFloat heightScale = targetSize.height / size.height;
    return (widthScale > heightScale) ? widthScale : heightScale;
}

- (UIImage *)corpImage:(UIImage*)image byRect:(CGRect)rect {
    rect.origin.x *= image.scale;
    rect.origin.y *= image.scale;
    rect.size.width *= image.scale;
    rect.size.height *= image.scale;
    if (rect.size.width <= 0 || rect.size.height <= 0) return nil;
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *newimage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return newimage;
}

- (IBAction)onCancell:(id)sender {
    [self.scrollView setContentInset:UIEdgeInsetsZero];
    self.willHideBlock? self.willHideBlock():nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onOK:(id)sender {
    CGRect  cropRect = [self.imageView convertRect:self.cropRect fromView:self.rectView.superview];
    CGFloat scale = self.image.size.width*self.scrollView.zoomScale /self.imageView.frame.size.width;
    CGRect  rectInImage = CGRectMake(cropRect.origin.x * scale, cropRect.origin.y * scale, cropRect.size.width *scale, cropRect.size.height*scale);
    UIImage * newImage = [self corpImage:self.image byRect:rectInImage];
    self.completion? self.completion(newImage):nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

@end
