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



@interface MaskViewController ()<UIActionSheetDelegate, ImagePageViewControllerDelegate, ImagePageViewControllerDataSource, PrintBaseViewControllerDataSource, PrintBaseViewControllerDelegate>{
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
    
    if(![self hasBtnSelected]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Print Sample" message:@"For continue, please select an image..." delegate:nil cancelButtonTitle:@"accept" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Print Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"WebView",
                                  @"View",
                                  nil];
    
    UIBarButtonItem *btn = (UIBarButtonItem *) sender;
    [actionSheet showFromBarButtonItem:btn animated:YES];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet
    clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        
        [self launchHTMLPrint];
        
    }else if(buttonIndex == 1){
        
        [self launchUIImagePrint];
        
    }
    
    
}

#pragma mark - UIPageViewController Methods

- (BOOL) hasBtnSelected{

    for(ImagePageViewController *controller in self.pageViewController.viewControllers){
        
        if(controller.btnSelection.highlighted){
            return YES;
        }
        
    }
 
    return NO;
}

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
    
    [self hideBtnSelectionInControllers];
    ImagePageViewController *printViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"printimage"];
    printViewController.datasource = self;
    printViewController.delegate = self;
    printViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:printViewController animated:YES completion:nil];

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

#pragma mark - PrintBaseViewControllerDelegate Methods

- (void) dismissPrintViewController:(UIViewController *) printController{

    [self showBtnSelectionInControllers];
    
}

#pragma mark - PrintBaseViewControllerDataSource Methods

- (UIImage *) imageForPrintViewController:(UIViewController *) printController{
    
    return [UIImage screenshotForView:self.container];
    
}



@end
