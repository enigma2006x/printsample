//
//  PrintWebViewController.m
//  PrintSample
//
//  Created by Antonio Trejo on 1/9/13.
//  Copyright (c) 2013 Antonio Trejo. All rights reserved.
//

#import "PrintWebViewController.h"
#import "NSData+Base64.h"
#import "WebViewPrintPageRenderer.h"

@interface PrintWebViewController ()<UIWebViewDelegate>

@end

@implementation PrintWebViewController

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
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"template" ofType:@"html"] isDirectory:NO];
    
    self.webview.delegate = self;
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    
    [self.delegate dismissPrintViewController:self];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)printAction:(id)sender {
    
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
    
    WebViewPrintPageRenderer *pageRender = [[WebViewPrintPageRenderer alloc] init];
    pageRender.title = printInfo.jobName;
    
    if(self.printPositionSegment.selectedSegmentIndex == 0)
        pageRender.printPosition = PrintPositionTopLeft;
    else if(self.printPositionSegment.selectedSegmentIndex == 1)
        pageRender.printPosition = PrintPositionMiddleCenter;
    else if(self.printPositionSegment.selectedSegmentIndex == 2)
        pageRender.printPosition = PrintPositionBottomRight;
    
    
    
    UIViewPrintFormatter *viewFormatter = [self.webview viewPrintFormatter];    
    [pageRender addPrintFormatter:viewFormatter startingAtPageAtIndex:0];
    // Set our custom renderer as the printPageRenderer for the print job.
    controller.printPageRenderer = pageRender;
    [controller presentAnimated:YES completionHandler:completionHandler];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    UIImage *image = [self.datasource imageForPrintViewController:self];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSString *imgB64 =  [NSString stringWithFormat: @"data:image/png;base64,%@", [imageData base64Encoding]];
    
    NSString *javascript = [NSString stringWithFormat:@"document.getElementById('image-holder').innerHTML = '<img src=\"%@\" alt=\"The Image\" />';", imgB64];

    [self.webview stringByEvaluatingJavaScriptFromString:javascript];
    
}



@end
