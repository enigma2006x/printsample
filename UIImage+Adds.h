//
//  UIImage+Adds.h
//  PrintSample
//
//  Created by Antonio Trejo on 1/3/13.
//  Copyright (c) 2013 Antonio Trejo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Adds)

+ (UIImage *) screenshotForView:(UIView *) theview;
+ (UIImage *) maskImage:(UIImage *)image
               withMask:(UIImage *)maskImage;

+ (UIImage *)imageWithImage:(UIImage *)image
               scaledToSize:(CGSize)newSize;

@end
