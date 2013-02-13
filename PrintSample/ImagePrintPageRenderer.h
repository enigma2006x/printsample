//
//  UIImagePrintPageRenderer.h
//  PrintSample
//
//  Created by Antonio Trejo on 1/9/13.
//  Copyright (c) 2013 Antonio Trejo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePrintPageRenderer : UIPrintPageRenderer

@property (nonatomic) PrintPosition printPosition;
@property (nonatomic) NSString *title;
@property (nonatomic, strong) UIImage *imageToPrint;

@end
