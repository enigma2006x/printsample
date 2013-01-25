//
//  ImagePageViewController.m
//  PrintSample
//
//  Created by Antonio Trejo on 12/28/12.
//  Copyright (c) 2012 Antonio Trejo. All rights reserved.
//

#import "ImagePageViewController.h"

@interface ImagePageViewController ()

@end

@implementation ImagePageViewController

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
    NSLog(@"viewdidload!!");
 
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.imageview addGestureRecognizer:tap];
    self.imageview.userInteractionEnabled = YES;


}

- (void) tapGesture:(UITapGestureRecognizer *) tap{
    
    [self randBackGroundImageView];
    
}

- (void) randBackGroundImageView{
    
    self.imageview.backgroundColor = [UIColor colorWithRed:(arc4random() % 255) / 255.0f
                                                     green:(arc4random() % 255) / 255.0f
                                                      blue:(arc4random() % 255) / 255.0f
                                                     alpha:1.0];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    [self layoutPictures];
    NSInteger index = [self.datasource validateBtnIndexInImagePageViewController:self];
    [self validateIfIndex:index];
    
}

- (void) layoutPictures{
    
    self.imageview.image = self.image;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectedPrintAction:(id)sender {

    [self.delegate selectedIndex:self.index
      forImagePageViewController:self];
     
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
       
        self.btnSelection.highlighted = YES;
        
    }];
}

- (void) validateIfIndex:(NSInteger) index{
    if(index != self.index){
        self.btnSelection.highlighted = NO;
    }
}

@end
