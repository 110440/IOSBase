//
//  UIImage+TTImagePicker.h
//  lindou
//
//  Created by tanson on 2019/3/8.
//  Copyright © 2019 lindou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TTImagePicker)

- (UIImage *)tt_normalizedImage;
- (UIImage *)tt_imageByResizeToSize:(CGSize)size;

@end
