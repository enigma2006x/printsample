//
//  PrintBaseViewController.h
//  PrintSample
//
//  Created by Antonio Trejo on 1/25/13.
//  Copyright (c) 2013 Antonio Trejo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PrintBaseViewController;

@protocol PrintBaseViewControllerDataSource <NSObject>

- (UIImage *) imageForPrintViewController:(UIViewController *) printController;

@end

@protocol PrintBaseViewControllerDelegate <NSObject>

- (void) dismissPrintViewController:(UIViewController *) printController;

@end


@interface PrintBaseViewController : UIViewController


@property (nonatomic, weak) id <PrintBaseViewControllerDataSource> datasource;
@property (nonatomic, weak) id <PrintBaseViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *printPositionSegment;

- (IBAction)done:(id)sender;
- (IBAction)printAction:(id)sender;

@end
