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
    
    [self.delegate dismissPrintWebViewController:self];
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
    
    
    // Obtain a printInfo so that we can set our printing defaults.
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    // This application produces General content that contains color.
    printInfo.outputType = UIPrintInfoOutputGeneral;
    // We'll use the URL as the job name.
    //printInfo.jobName = [self.urlField text];
    // Set duplex so that it is available if the printer supports it. We are
    // performing portrait printing so we want to duplex along the long edge.
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    // Use this printInfo for this print job.
    controller.printInfo = printInfo;
    
    // Be sure the page range controls are present for documents of > 1 page.
    controller.showsPageRange = YES;
    
    // This code uses a custom UIPrintPageRenderer so that it can draw a header and footer.
    WebViewPrintPageRenderer *pageRender = [[WebViewPrintPageRenderer alloc] init];
    // The APLPrintPageRenderer class provides a jobtitle that it will label each page with.
    
    // To draw the content of each page, a UIViewPrintFormatter is used.
    UIViewPrintFormatter *viewFormatter = [self.webview viewPrintFormatter];
    
#if SIMPLE_LAYOUT
    /*
     For the simple layout we simply set the header and footer height to the height of the
     text box containing the text content, plus some padding.
     
     To do a layout that takes into account the paper size, we need to do that
     at a point where we know that size. The numberOfPages method of the UIPrintPageRenderer
     gets the paper size and can perform any calculations related to deciding header and
     footer size based on the paper size. We'll do that when we aren't doing the simple
     layout.
     */
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:HEADER_FOOTER_TEXT_HEIGHT];
    CGSize titleSize = [myRenderer.jobTitle sizeWithFont:font];
    render.headerHeight = myRenderer.footerHeight = titleSize.height + HEADER_FOOTER_MARGIN_PADDING;
#endif
    [pageRender addPrintFormatter:viewFormatter startingAtPageAtIndex:0];
    // Set our custom renderer as the printPageRenderer for the print job.
    controller.printPageRenderer = pageRender;
    
    /*
     The method we use to present the printing UI depends on the type of UI idiom that is currently executing. Once we invoke one of these methods to present the printing UI, our application's direct involvement in printing is complete. Our custom printPageRenderer will have its methods invoked at the appropriate time by UIKit.
     */
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
  //      [controller presentFromBarButtonItem:self.printButton animated:YES completionHandler:completionHandler];  // iPad
    }
    else {
        [controller presentAnimated:YES completionHandler:completionHandler];  // iPhone
    }

    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    UIImage *image = [self.datasource imageForPrintInsideWebViewForPrintWebViewController:self];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSString *imgB64 =  [NSString stringWithFormat: @"data:image/png;base64,%@", [imageData base64Encoding]];
    
    NSString *javascript = [NSString stringWithFormat:@"document.getElementById('image-holder').innerHTML = '<img src=\"%@\" alt=\"The Image\" />';", imgB64];
    
    
    
    [self.webview stringByEvaluatingJavaScriptFromString:javascript];
    
}



@end
