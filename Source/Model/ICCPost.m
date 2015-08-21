//
//  ICCPost.m
//  AndriiKurshyn_iOSCodeChallenge
//
//  Created by Andrii Kurshyn on 7/24/15.
//  Copyright (c) 2015 Andrii Kurshyn. All rights reserved.
//

#import "ICCPost.h"

@implementation ICCPost

+ (instancetype)postByDictonary:(NSDictionary *)dic {
    
    ICCPost* post = [ICCPost new];
    
    NSDictionary* data = dic[@"data"];
    
    post.title = data[@"title"];
    post.author = data[@"author"];
    post.thumbnail = data[@"thumbnail"];
    post.countComments = data[@"countComments"];
    post.ups = data[@"ups"];
    post.downs = data[@"downs"];
    
    return post;
}

@end
