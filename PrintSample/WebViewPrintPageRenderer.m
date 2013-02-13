//
//  WebViewPrintPageRenderer.m
//  PrintSample
//
//  Created by Antonio Trejo on 1/9/13.
//  Copyright (c) 2013 Antonio Trejo. All rights reserved.
//

#import "WebViewPrintPageRenderer.h"
#import "UIImage+Adds.h"

#define kHeaderHeight     25
#define kFooterHeight     20

#define kLeftMargin 12
#define kTopMargin 30
#define kRightMargin 12
#define kBottomMargin 25

@implementation WebViewPrintPageRenderer

- (void)drawPageAtIndex:(NSInteger)pageIndex
                 inRect:(CGRect)printableRect{

    [self textWithString:@"RAY"
                    font:[UIFont fontWithName:@"Verdana" size:22]
                   color:[UIColor colorWithRed:0/255.0f
                                         green:104/255.0f
                                          blue:55/255.0f
                                         alpha:1.0]
               starPoint:CGPointMake(120, 10)];
    
    [self textWithString:@"WENDERLICH"
                    font:[UIFont fontWithName:@"Verdana" size:22]
                   color:[UIColor blackColor]
               starPoint:CGPointMake(160, 10)];

    UIViewPrintFormatter *printFormat = (UIViewPrintFormatter *)self.printFormatters[pageIndex];
    
    UIImage *image = [UIImage screenshotForView:printFormat.view];

    CGRect destRect = printFormat.view.frame;

    if(self.printPosition == PrintPositionTopLeft){
        
        destRect.origin.x = kLeftMargin;
        destRect.origin.y = kTopMargin;
        
    }else if(self.printPosition == PrintPositionMiddleCenter){
       
        destRect.origin.x = CGRectGetMidX(self.paperRect) - (CGRectGetWidth(destRect) / 2);
        destRect.origin.y = CGRectGetMidY(self.paperRect) - (CGRectGetHeight(destRect) / 2);
        
    }else if(self.printPosition == PrintPositionBottomRight){
    
        destRect.origin.x = self.paperRect.size.width - CGRectGetWidth(destRect) - kRightMargin;
        destRect.origin.y = self.paperRect.size.height - CGRectGetHeight(destRect) - kBottomMargin;
    
    }
    

    [image drawInRect:destRect];
    
    if(self.title){
        
        UIFont *font = [UIFont fontWithName:@"Verdana" size:10];
        NSString *localizedPageNumberString = NSLocalizedString(@"Page %d of %d", @"Page Count String");
        NSString *pageNumberString = [NSString stringWithFormat:localizedPageNumberString,
                                      pageIndex+1, self.numberOfPages];
        CGSize pageNumSize = [pageNumberString sizeWithFont:font];
        CGFloat startY = CGRectGetMaxY(self.printableRect) - pageNumSize.height - kFooterHeight;
        CGPoint startPoint = CGPointMake(120, startY);
        
        [self.title drawAtPoint:startPoint withFont: font];
        
    }


}

#pragma mark - Text Methods

- (void) textWithString:(NSString *) string
                   font:(UIFont *) font
                  color:(UIColor *) color
              starPoint:(CGPoint) startPoint{
    

    [color set];
    [string drawAtPoint:startPoint withFont:font];
    
}

@end
