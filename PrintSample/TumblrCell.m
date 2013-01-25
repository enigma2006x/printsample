//
//  TumblrCell.m
//  PrintSample
//
//  Created by Antonio Trejo on 12/26/12.
//  Copyright (c) 2012 Antonio Trejo. All rights reserved.
//

#import "TumblrCell.h"

@implementation TumblrCell



- (id) initWithCoder:(NSCoder *)aDecoder{

    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
       
        //NSLog(@"initWithCoder");
        
    }
    return self;
    
}

- (void) awakeFromNib{
    [super awakeFromNib];
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) panGesture:(UIPanGestureRecognizer *) pan{
    NSLog(@"panGesture");
    
    UIView *view = self.superview.superview;
    CGPoint point = [pan translationInView:view];
    [view bringSubviewToFront:self.imageview];
    self.imageview.center = point;
    
    
}


@end
