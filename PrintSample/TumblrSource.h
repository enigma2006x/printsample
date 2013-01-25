//
//  TumblrSource.h
//  PrintSample
//
//  Created by Antonio Trejo on 12/26/12.
//  Copyright (c) 2012 Antonio Trejo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Blog;
@class Photo;

typedef enum {
    TumblrStatusFail          = -1,
    TumblrStatusCompleted     = 0,
} TumblrStatus;

typedef void (^TumblrSourceStatusBlock)(TumblrStatus status);

@interface TumblrSource : NSObject

+ searchDefault;
+ searchWithTag:(NSString *) search;

- (id)initWithTag:(NSString *) tag;
- (void)setCompletedResponseBlock:(void (^)(TumblrStatus completed)) block;


- (NSInteger) numberOfBlogsWithImage;
- (Blog *) blogAtIndex:(NSInteger) index;
- (Photo *) thumbnailAtIndex:(NSInteger) index;

@end
