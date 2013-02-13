//
//  PrintImageViewController.m
//  PrintSample
//
//  Created by Antonio Trejo on 1/25/13.
//  Copyright (c) 2013 Antonio Trejo. All rights reserved.
//

#import "PrintImageViewController.h"
#import "ImagePrintPageRenderer.h"
#import "UIImage+Adds.h"

@interface PrintImageViewController ()

@end

@implementation PrintImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *image = [self.datasource imageForPrintViewController:self];
    self.imageview.image = image;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)done:(id)sender{
    [self.delegate dismissPrintViewController:self];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)printAction:(id)sender{

    UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
    if(!controller){
        NSLog(@"Couldn't get shared UIPrintInteractionController!");
        return;
    }
    
    UIPrintInteractionCompletionHandler completionHandler =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if(!completed && error){
            NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
        }
    };
    
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    // This application produces General content that contains color.
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"Print Sample";
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    
    controller.printInfo = printInfo;
    
    controller.showsPageRange = YES;
    
    ImagePrintPageRenderer *pageRender = [[ImagePrintPageRenderer alloc] init];
    pageRender.title = printInfo.jobName;

    pageRender.headerHeight = 80;
    pageRender.footerHeight = 20;
    
    if(self.printPositionSegment.selectedSegmentIndex == 0)
        pageRender.printPosition = PrintMosaicMode;
    else if(self.printPositionSegment.selectedSegmentIndex == 1)
        pageRender.printPosition = PrintPositionMiddleCenter;
    else if(self.printPositionSegment.selectedSegmentIndex == 2)
        pageRender.printPosition = PrintRandom;
    
    pageRender.imageToPrint = self.imageview.image;
    
    controller.printPageRenderer = pageRender;
    [controller presentAnimated:YES completionHandler:completionHandler];
}

@end
