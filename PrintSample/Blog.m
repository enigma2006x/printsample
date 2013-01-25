//
//  Blog.m
//  PrintSample
//
//  Created by Antonio Trejo on 12/26/12.
//  Copyright (c) 2012 Antonio Trejo. All rights reserved.
//

#import "Blog.h"

@implementation Blog

- (NSMutableArray *) photos{
    
    if(!_photos){
        _photos = [[NSMutableArray alloc] init];
    }
    
    return _photos;
    
}

@end
