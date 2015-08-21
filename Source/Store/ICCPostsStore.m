//
//  ICCPostsStore.m
//  AndriiKurshyn_iOSCodeChallenge
//
//  Created by Andrii Kurshyn on 7/24/15.
//  Copyright (c) 2015 Andrii Kurshyn. All rights reserved.
//

#import "ICCPostsStore.h"

#import "ICCPost.h"

NSString *const kAPIAddress = @"http://www.reddit.com/r/";

@implementation ICCPostsStore

+ (instancetype)sharedInstance {
    static ICCPostsStore *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ICCPostsStore alloc] init];
    });
    return sharedInstance;
}

- (void) fetchPostsByCategory:(NSString*)category completion:(void (^)(NSArray *posts, NSError *error))completion {
    
    category = [category stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *path = [kAPIAddress stringByAppendingPathComponent:category];
    NSString* url = [path stringByAppendingPathComponent:@".json"];
    
    [self requestByURL:[NSURL URLWithString:url] completion:^(NSDictionary *responsDic, NSError *error) {
        
        if (error == nil) {
            
            NSMutableArray* posts = [NSMutableArray new];
            for (NSDictionary* postDic in responsDic[@"data"][@"children"]) {
                [posts addObject:[ICCPost postByDictonary:postDic]];
            }
            
            if (completion != nil) {
                completion(posts, error);
            }
            
        } else {
            
            if (completion != nil) {
                completion(nil, error);
            }
        }
        
    }];
}

- (void) requestByURL:(NSURL*)URL completion:(void(^)(NSDictionary *responsDic, NSError *error))completion {
    
    NSURLRequest* request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (completion != nil) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       if (data != nil) {
                                           NSError *error = nil;
                                           NSDictionary *responsDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                           completion(responsDic, error);
                                       } else {
                                           completion(nil, error);
                                       }
                                       
                                   });
                               }
                               
                           }];
}

@end
