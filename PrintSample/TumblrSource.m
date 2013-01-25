//
//  TumblrSource.m
//  PrintSample
//
//  Created by Antonio Trejo on 12/26/12.
//  Copyright (c) 2012 Antonio Trejo. All rights reserved.
//

#import "TumblrSource.h"
#import "AFNetworking.h"
#import "Blog.h"
#import "Photo.h"
static NSString const *apiurl = @"http://api.tumblr.com/v2/tagged?api_key=fuiKNFp9vQFvjLNvx4sUwti4Yb5yGutBN4Xh10LXZhhRKjWlV4&limit=50&tag=";


@interface TumblrSource ()

@property (nonatomic, strong) NSString *urlWithTag;
@property (nonatomic, strong) NSMutableArray *blogs;

@end

@implementation TumblrSource

+ searchDefault{
    
    return [[self alloc] initWithTag:@"gangnamstyle"];
    
}

+ searchWithTag:(NSString *) tag{
    
    return [[self alloc] initWithTag:tag];
    
}

- (id)initWithTag:(NSString *) tag{
    
    if(self = [super init]){
    
        NSString *urlSearch = [apiurl stringByAppendingString:tag];
        self.urlWithTag = urlSearch;
        
    }
    
    return self;
    
}


- (void)setCompletedResponseBlock:(void (^)(TumblrStatus completed)) block{
    
//    NSLog(@"self.urlWithTag:%@", self.urlWithTag);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlWithTag]];
    AFJSONRequestOperation *json = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    [json setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        
       // NSLog(@"responseObject:%@", responseObject);

        NSDictionary *json = responseObject;

            for(NSDictionary *currentBlog in json[@"response"]){
            
                Blog *blog = [[Blog alloc] init];
                blog.blogname = currentBlog[@"blog_name"];
                blog.posturl = currentBlog[@"post_url"];
                
                if([currentBlog objectForKey:@"photos"]){
                    
                    for(NSDictionary *currentPhoto in [currentBlog[@"photos"] lastObject][@"alt_sizes"]){
                        
                        Photo *photo = [[Photo alloc] init];
                        photo.width = currentPhoto[@"width"];
                        photo.height = currentPhoto[@"height"];
                        photo.url = currentPhoto[@"url"];
                    
                        [blog.photos addObject:photo];
                        
                    }
                    
                    
                    [self.blogs addObject:blog];
                    
                }



            
                
            }
        

        block(TumblrStatusCompleted);
        
    }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                    
               block(TumblrStatusFail);
                                    
                                }];
    
    [json start];

    
}

- (NSMutableArray *) blogs{
    
    if(!_blogs){
        
        _blogs = [[NSMutableArray alloc] init];
        
    }
    
    return _blogs;
    
}

- (NSInteger) numberOfBlogsWithImage{
    
    return self.blogs.count;
    
}

- (Blog *) blogAtIndex:(NSInteger) index{
    
    return self.blogs[index];
    
}


- (Photo *) thumbnailAtIndex:(NSInteger) index{
    
    Blog *blog = self.blogs[index];
    return blog.photos[0];
    
}

@end
