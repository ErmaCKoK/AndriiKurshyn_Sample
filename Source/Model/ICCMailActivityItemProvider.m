//
//  ICCMailActivityItemProvider.m
//  AndriiKurshyn_iOSCodeChallenge
//
//  Created by Andrii Kurshyn on 7/24/15.
//  Copyright (c) 2015 Andrii Kurshyn. All rights reserved.
//

#import "ICCMailActivityItemProvider.h"

#import "ICCPost.h"

@implementation ICCMailActivityItemProvider

+ (instancetype)itemByPost:(ICCPost *)post {
    ICCMailActivityItemProvider* activity = [ICCMailActivityItemProvider new];
    activity.post = post;
    return activity;
}

#pragma mark - UIActivityItemSource
- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    return ([activityType isEqualToString:UIActivityTypeMail]) ? self.post.title : [NSString string];
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return [NSString string];
}

@end
