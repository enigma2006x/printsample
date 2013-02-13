//
//  UIImagePrintPageRenderer.m
//  PrintSample
//
//  Created by Antonio Trejo on 1/9/13.
//  Copyright (c) 2013 Antonio Trejo. All rights reserved.
//

#import "ImagePrintPageRenderer.h"
#import "UIImage+Adds.h"

@implementation ImagePrintPageRenderer


- (void)drawHeaderForPageAtIndex:(NSInteger)pageIndex inRect:(CGRect)headerRect{

    UIImage *headerImage = [UIImage imageNamed:@"header.png"];
    [[UIImage imageWithImage:headerImage scaledToSize:headerRect.size] drawInRect:headerRect];
    
}


- (void)drawContentForPageAtIndex:(NSInteger)pageIndex inRect:(CGRect)contentRect{
     NSLog(@"drawContentForPageAtIndex");
    if(self.printPosition == PrintMosaicMode){
        
        float width = contentRect.size.width / 5;
        float scale = width / self.imageToPrint.size.width;
        
        CGRect frameMosaic = CGRectMake(contentRect.origin.x, contentRect.origin.y, 0, 0);

        for (int i = 0; i < 5; i++) {
        
            if (frameMosaic.origin.y > contentRect.size.height) break;

            frameMosaic.size.width = width;
            frameMosaic.size.height = self.imageToPrint.size.height * scale;
            [self.imageToPrint drawInRect:frameMosaic];
            frameMosaic.origin.x += width;
            
            if(frameMosaic.origin.y < contentRect.size.height && i == 4){
                
                frameMosaic.origin.y += frameMosaic.size.height;
                frameMosaic.origin.x = contentRect.origin.x;
                i = -1;
                
            }            
            
        }
        
    }else if(self.printPosition == PrintPositionMiddleCenter){
        
        CGRect destRect = CGRectMake(0, 0, self.imageToPrint.size.width, self.imageToPrint.size.height);
        destRect.origin.x = CGRectGetMidX(contentRect) - (CGRectGetWidth(destRect) / 2);
        destRect.origin.y = CGRectGetMidY(contentRect) - (CGRectGetHeight(destRect) / 2);
        
        [self.imageToPrint drawInRect:destRect];
        
    }

}

- (void)drawFooterForPageAtIndex:(NSInteger)pageIndex  inRect:(CGRect)footerRect{

    UIImage *headerImage = [UIImage imageNamed:@"footerPattern.png"];
    
    CGImageRef image_to_tile_ret_ref = CGImageRetain(headerImage.CGImage);
    
    CGRect image_rect;
    image_rect.size = headerImage.size; 
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToRect(context, footerRect);
    CGContextDrawTiledImage(context, image_rect, image_to_tile_ret_ref);
    
    CGImageRelease(image_to_tile_ret_ref);
 
    //[finishedImage drawInRect:footerRect];

}

- (NSInteger) numberOfPages{
    
    return 1;
    
}


@end
