//
//  Blog.h
//  PrintSample
//
//  Created by Antonio Trejo on 12/26/12.
//  Copyright (c) 2012 Antonio Trejo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Photo;

@interface Blog : NSObject

@property (nonatomic, strong) NSString *blogname;
@property (nonatomic, strong) NSString *posturl;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSMutableArray *photos;

@end
