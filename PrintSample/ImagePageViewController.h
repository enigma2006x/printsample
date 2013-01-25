//
//  ImagePageViewController.h
//  PrintSample
//
//  Created by Antonio Trejo on 12/28/12.
//  Copyright (c) 2012 Antonio Trejo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImagePageViewController;

@protocol ImagePageViewControllerDelegate <NSObject>

- (void) selectedIndex:(NSInteger) index
    forImagePageViewController:(ImagePageViewController *) imagepage;

@end

@protocol ImagePageViewControllerDataSource <NSObject>

- (NSInteger) validateBtnIndexInImagePageViewController:(ImagePageViewController *) imagepage;

@end

@interface ImagePageViewController : UIViewController

@property (nonatomic) NSUInteger index;
@property (nonatomic, weak) id <ImagePageViewControllerDelegate> delegate;
@property (nonatomic, weak) id <ImagePageViewControllerDataSource> datasource;
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UIButton *btnSelection;

- (IBAction)selectedPrintAction:(id)sender;
- (void) validateIfIndex:(NSInteger) index;

@end
