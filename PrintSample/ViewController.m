//
//  ViewController.m
//  PrintSample
//
//  Created by Antonio Trejo on 12/26/12.
//  Copyright (c) 2012 Antonio Trejo. All rights reserved.
//

#import "ViewController.h"
#import "TumblrSource.h"
#import "Blog.h"
#import "Photo.h"
#import "UIImageView+AFNetworking.h"
#import "TumblrCell.h"
#import "MaskViewController.h"
#import "UIImage+Adds.h"

@interface ViewController ()<MaskViewControllerDataSource>{
    
    NSString *tempPathImage;
    
}

@property (nonatomic, strong) TumblrSource *source;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableview.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.tableview.layer setShadowOffset:CGSizeMake(5, 0)];
    [self.tableview.layer setShadowRadius:5.0];
    [self.tableview.layer setShadowOpacity:0.35];
    self.tableview.clipsToBounds = NO;
  
    self.source = [TumblrSource searchDefault];
    [self loadTumblrImages];
    
}

- (void) loadTumblrImages{
 
    [self.source setCompletedResponseBlock:^(TumblrStatus completed){
        
        if(completed == TumblrStatusCompleted){
            
            
            NSLog(@"response true");
            [self.tableview reloadData];
            
        }
        
        
        
    }];

    
}

- (void) awakeFromNib{
    [super awakeFromNib];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.source numberOfBlogsWithImage];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *idCell = @"idcell";
    TumblrCell *cell = [tableView dequeueReusableCellWithIdentifier:idCell
                                                            forIndexPath:indexPath];
    
    
    
    Photo *photo = [self.source thumbnailAtIndex:indexPath.row];
    [cell.imageview setImageWithURL:[NSURL URLWithString:photo.url] placeholderImage:nil];
    
    return cell;

}

- (void) tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.containerCollage.center.x - 75,
                                                                       self.view.bounds.size.height,
                                                                       150,
                                                                       150)];
    imageview.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    
    [imageview addGestureRecognizer:pan];
    
    Photo *photo = [self.source thumbnailAtIndex:indexPath.row];
    [imageview setImageWithURL:[NSURL URLWithString:photo.url] placeholderImage:nil];
    
    imageview.backgroundColor = [UIColor blackColor];
    [UIView animateWithDuration:0.35 animations:^{
        imageview.center = self.containerCollage.center;
    }];
    
    
    [self.containerCollage addSubview:imageview];
    

    [self hideImagesAction:nil];
    
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    UINavigationController *nav = (UINavigationController *) segue.destinationViewController;
    MaskViewController *maskview = (MaskViewController *) nav.visibleViewController;
    maskview.datasource = self;
    
}

- (IBAction)showImages:(id)sender {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.tableview.alpha = 1;
        self.alphaview.alpha = 0.65;
        
    }];
}


- (void) panGestureAction:(UIPanGestureRecognizer *) pan{
    
    UIImageView *imageview = (UIImageView *)pan.view;
    [self.containerCollage bringSubviewToFront:imageview];
    CGPoint point = [pan translationInView:self.containerCollage];
  
    imageview.center = CGPointMake(imageview.center.x + point.x,
                                         imageview.center.y + point.y);
    [pan setTranslation:CGPointMake(0, 0) inView:self.containerCollage];
    
}


- (UIImage *) screenshotContainerViewForMaskViewController:(MaskViewController *) maskview{
    
    return [UIImage screenshotForView:self.containerCollage];
    
}

- (IBAction)returnAction:(UIStoryboardSegue *)sender{}

- (IBAction)resetAction:(id)sender {
    
    [self loadTumblrImages];
    
}

- (IBAction)hideImagesAction:(id)sender {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.tableview.alpha = 0;
        self.alphaview.alpha = 0;
        
    }];

    
}


- (IBAction)quickLook:(id)sender {
    
    [self cacheImage:[UIImage screenshotForView:self.containerCollage]];
   
    [self launchQuickLook];
    
}


#pragma mark - QLPreviewControllerDataSource Methods


- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{

    return 1;

}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
        
    return [[NSURL alloc] initFileURLWithPath:[self cacheImage]];
    
}

- (void) launchQuickLook{
   
    QLPreviewController *previewer = [[QLPreviewController alloc] init];
    previewer.dataSource = self;
    previewer.currentPreviewItemIndex = 0;
    
    [self presentViewController:previewer
                       animated:YES
                     completion:nil];
    
}

- (void) cacheImage: (UIImage *) image{
    
    NSString *str = [NSString stringWithFormat:@"tempImage%d.png", arc4random() % 2000];
    
    tempPathImage = [NSHomeDirectory() stringByAppendingPathComponent: str];
     
    NSLog(@"Is deletable file at path: %d", [[NSFileManager defaultManager] isDeletableFileAtPath:tempPathImage]);
    
    // Check for file existence
    if(![[NSFileManager defaultManager] fileExistsAtPath:tempPathImage]){
    
        [UIImagePNGRepresentation(image) writeToFile:tempPathImage atomically:YES];
    
    }
    
}

- (NSString *) cacheImage{
    
    return tempPathImage;
    
}

- (void) removeCacheImage{
    
    if([[NSFileManager defaultManager] fileExistsAtPath:tempPathImage]){
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:tempPathImage error:&error];
        
        NSLog(@"error:%@", error);
    }
    
}


@end