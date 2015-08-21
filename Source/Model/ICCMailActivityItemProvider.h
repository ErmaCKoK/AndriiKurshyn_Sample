//
//  ICCMailActivityItemProvider.h
//  AndriiKurshyn_iOSCodeChallenge
//
//  Created by Andrii Kurshyn on 7/24/15.
//  Copyright (c) 2015 Andrii Kurshyn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ICCPost;

@interface ICCMailActivityItemProvider : UIActivityItemProvider

@property (nonatomic, strong) ICCPost *post;

+ (instancetype)itemByPost:(ICCPost *)post;

@end
