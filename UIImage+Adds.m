//
//  UIImage+Adds.m
//  PrintSample
//
//  Created by Antonio Trejo on 1/3/13.
//  Copyright (c) 2013 Antonio Trejo. All rights reserved.
//

#import "UIImage+Adds.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (Adds)


+ (UIImage *) screenshotForView:(UIView *) theview{
    
    UIGraphicsBeginImageContextWithOptions(theview.frame.size, YES, 0);
    [[theview layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenshot;
    
}
+ (UIImage *) maskImage:(UIImage *)image
                 withMask:(UIImage *)maskImage {
    
	CGImageRef maskRef = maskImage.CGImage;
    
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
	CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    
	return [UIImage imageWithCGImage:masked];
}

@end
