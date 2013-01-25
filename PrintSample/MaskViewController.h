//
//  MaskViewController.h
//  PrintSample
//
//  Created by Antonio Trejo on 12/28/12.
//  Copyright (c) 2012 Antonio Trejo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MaskViewController;

@protocol MaskViewControllerDataSource <NSObject>

- (UIImage *) screenshotContainerViewForMaskViewController:(MaskViewController *) maskview;

@end

@interface MaskViewController : UIViewController<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic, weak) id <MaskViewControllerDataSource> datasource;

@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *printButton;

@end
