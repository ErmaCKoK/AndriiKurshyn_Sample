//
//  ICCPost.h
//  AndriiKurshyn_iOSCodeChallenge
//
//  Created by Andrii Kurshyn on 7/24/15.
//  Copyright (c) 2015 Andrii Kurshyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICCPost : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* author;
@property (nonatomic, strong) NSString* thumbnail;
@property (nonatomic, strong) NSString* countComments;
@property (nonatomic, strong) NSString* ups;
@property (nonatomic, strong) NSString* downs;

+ (instancetype)postByDictonary:(NSDictionary*)dic;

@end
