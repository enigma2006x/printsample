//
//  PrintWebViewController.h
//  PrintSample
//
//  Created by Antonio Trejo on 1/9/13.
//  Copyright (c) 2013 Antonio Trejo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PrintWebViewController;


@protocol PrintWebViewControllerDelegate <NSObject>

- (void) dismissPrintWebViewController:(PrintWebViewController *) printController;

@end

@protocol PrintWebViewControllerDataSource <NSObject>

- (UIImage *) imageForPrintInsideWebViewForPrintWebViewController:(PrintWebViewController *) printController;

@end


@interface PrintWebViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIWebView *webview;
@property (nonatomic, weak) id <PrintWebViewControllerDataSource> datasource;
@property (nonatomic, weak) id <PrintWebViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;
- (IBAction)printAction:(id)sender;

@end
