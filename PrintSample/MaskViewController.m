//
//  MaskViewController.m
//  PrintSample
//
//  Created by Antonio Trejo on 12/28/12.
//  Copyright (c) 2012 Antonio Trejo. All rights reserved.
//

#import "MaskViewController.h"
#import "ImagePageViewController.h"
#import "PrintWebViewController.h"
#import "UIImage+Adds.h"
#import "ImagePrintPageRenderer.h"



@interface MaskViewController ()<UIActionSheetDelegate, PrintWebViewControllerDataSource, ImagePageViewControllerDelegate, PrintWebViewControllerDelegate, ImagePageViewControllerDataSource>{
    NSInteger indexImageToPrint;
}

@property (nonatomic, strong) NSArray *maskImages;

@end

@implementation MaskViewController

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
	// Do any additional setup after loading the view.
    
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:
                      [[NSBundle mainBundle] bundlePath] error:nil];
    self.maskImages = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self BEGINSWITH[cd] 'mask'"]];
   
    //NSLog(@"%@", self.maskImages);
    
    
    [self setupPageViewController];
    
    if(![UIPrintInteractionController isPrintingAvailable]){
         self.printButton.enabled = NO;
    }
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupPageViewController{
    
    NSDictionary *pageViewOptions = [NSDictionary dictionaryWithObjectsAndKeys:UIPageViewControllerOptionSpineLocationKey,
                                     [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMax],
                                     nil];
    
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle: UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal options:pageViewOptions];
    
    
    ImagePageViewController *imagePageViewController = [self createImagePageViewControllerInstanceWithIndex:0];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    [self.pageViewController setViewControllers:[NSArray arrayWithObject:imagePageViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward | UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    
    self.pageViewController.view.frame = self.container.bounds;
    [self addChildViewController:self.pageViewController];
    [self.container addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    self.container .gestureRecognizers = self.pageViewController.view.gestureRecognizers;
    
    
}


- (IBAction)printOptions:(id)sender {
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Imprimir" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Inside WebView",
                                  @"Custom Layout",
                                  nil];
    
    UIBarButtonItem *btn = (UIBarButtonItem *) sender;
    [actionSheet showFromBarButtonItem:btn animated:YES];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet
    clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"buttonIndex:%d", buttonIndex);
    
    if(buttonIndex == 0){
        
        [self launchHTMLPrint];
        
    }else if(buttonIndex == 1){
        
        [self launchUIImagePrint];
        
    }
    
    
}

#pragma mark - UIPageViewController Methods

- (void) hideBtnSelectionInControllers{
    for(ImagePageViewController *controller in self.pageViewController.viewControllers){
        
        controller.btnSelection.hidden = YES;
        
    }
}

- (void) showBtnSelectionInControllers{
    for(ImagePageViewController *controller in self.pageViewController.viewControllers){
        
        controller.btnSelection.hidden = NO;
        
    }
}

- (ImagePageViewController *) createImagePageViewControllerInstanceWithIndex:(NSInteger) index{
    
    ImagePageViewController *imagePageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ImagePageViewController"];
    imagePageViewController.delegate = self;
    imagePageViewController.datasource = self;
    imagePageViewController.image = [self maskWithImageAtIndex:index];
    imagePageViewController.index = index;

    return imagePageViewController;
    
}

#pragma mark - UIPageViewControllerDataSource Methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
  
    return UIPageViewControllerSpineLocationMin;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    ImagePageViewController *previousViewController = (ImagePageViewController *)viewController;
        
    if(previousViewController.index == 0){
        return nil;
    }

    int index = previousViewController.index - 1;
    
    return [self createImagePageViewControllerInstanceWithIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    ImagePageViewController *previousViewController = (ImagePageViewController *)viewController;
    
    if(previousViewController.index == self.maskImages.count - 1){
        return nil;
    }
    

    int index = previousViewController.index + 1;
    
    return [self createImagePageViewControllerInstanceWithIndex:index];
    
}

- (UIImage *) maskWithImageAtIndex:(NSInteger) index{
    
    UIImage *mask = [UIImage imageNamed:self.maskImages[index]];
    UIImage *masked = [UIImage maskImage:[self.datasource screenshotContainerViewForMaskViewController:self]
                                withMask:mask];
    return masked;
    
    
}


#pragma mark - ImagePageViewControllerDelegate Methods

- (void) selectedIndex:(NSInteger) index
        forImagePageViewController:(ImagePageViewController *) imagepage{
    
    indexImageToPrint = index;
    
}

#pragma mark - ImagePageViewControllerDataSource Methods

- (NSInteger) validateBtnIndexInImagePageViewController:(ImagePageViewController *) imagepage{
    
    return indexImageToPrint;
    
}


#pragma mark - HTML Print

- (void) launchUIImagePrint{
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
    ImagePrintPageRenderer *pageRender = [[ImagePrintPageRenderer alloc] init];
    pageRender.image = [UIImage screenshotForView:self.container];
    // The APLPrintPageRenderer class provides a jobtitle that it will label each page with.
    

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

#pragma mark - HTML Print

- (void) launchHTMLPrint{

    [self hideBtnSelectionInControllers];
    PrintWebViewController *printViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"printwebview"];
    printViewController.datasource = self;
    printViewController.delegate = self;
    printViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:printViewController animated:YES completion:nil];
       
}

#pragma mark - PrintWebViewControllerDelegate Methods

- (void) dismissPrintWebViewController:(PrintWebViewController *) printController{

    [self showBtnSelectionInControllers];
    
}

#pragma mark - PrintWebViewControllerDataSource Methods

- (UIImage *) imageForPrintInsideWebViewForPrintWebViewController:(PrintWebViewController *) printController{
    
    return [UIImage screenshotForView:self.container];
    
}



@end
