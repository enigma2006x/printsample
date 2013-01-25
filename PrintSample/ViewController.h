//
//  ViewController.h
//  PrintSample
//
//  Created by Antonio Trejo on 12/26/12.
//  Copyright (c) 2012 Antonio Trejo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIControl *alphaview;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *containerCollage;
- (IBAction)resetAction:(id)sender;
- (IBAction)hideImagesAction:(id)sender;
- (IBAction)quickLook:(id)sender;

@end
