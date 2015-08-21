//
//  ICCAvatarImageView.m
//  AndriiKurshyn_iOSCodeChallenge
//
//  Created by Andrii Kurshyn on 7/24/15.
//  Copyright (c) 2015 Andrii Kurshyn. All rights reserved.
//

#import "ICCAvatarImageView.h"

@interface ICCAvatarImageView ()
{
    UIActivityIndicatorView* _activityIndicator;
}

@end

@implementation ICCAvatarImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit {
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect frame = _activityIndicator.frame;
    frame.origin.x = (self.bounds.size.width - frame.size.width) / 2.f;
    frame.origin.y = (self.bounds.size.height - frame.size.height) / 2.f;
    _activityIndicator.frame = frame;
    _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;;
    [self addSubview:_activityIndicator];
    _activityIndicator.hidesWhenStopped = YES;
}

- (void) setURL:(NSURL*)URL {
    _URL = URL;
    
    NSString* absoluteURLString = [URL absoluteString];
    if ([absoluteURLString length] > 0 && URL.scheme && URL.host) {
        [_activityIndicator startAnimating];
        
        [self downloadImageForURL:URL
                       completion: ^(UIImage* image, NSError* error) {
             self.image = image;
             [_activityIndicator stopAnimating];
         }];
    } else {
        self.image = nil;
        [_activityIndicator stopAnimating];
    }
}

- (void)setImage:(UIImage *)image {
    
    if (image == nil) {
        [super setImage:image];
        return;
    }
    
    CGRect imageFrame = self.bounds;
    imageFrame.size.width -= 4;
    imageFrame.size.height -= 4;
    imageFrame.origin.x = CGRectGetMidX(self.bounds)-imageFrame.size.width/2;
    imageFrame.origin.y = CGRectGetMidY(self.bounds)-imageFrame.size.height/2;
    
    UIImage* bgImage = [UIImage imageNamed:@"avatar-bg"];
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [bgImage drawInRect:self.bounds];
    
    [[UIBezierPath bezierPathWithRoundedRect:imageFrame
                                cornerRadius:imageFrame.size.width / 2] addClip];
    [image drawInRect:imageFrame];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [super setImage:image];
    
}

#pragma mark - Helper Methods
- (void) downloadImageForURL:(NSURL*)url completion:(void (^)(UIImage* image, NSError* error))completion {
    
    static NSOperationQueue* refNetworkOperationQueue;
    if (refNetworkOperationQueue == nil) {
        refNetworkOperationQueue = [NSOperationQueue new];
    }
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url
                                                                   cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                               timeoutInterval:10.f];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:refNetworkOperationQueue
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError) {
                               if ([response.URL.absoluteString isEqualToString:self.URL.absoluteString]) {
                                   UIImage* image = nil;
                                   
                                   if (data != nil) {
                                       image = [[UIImage alloc] initWithData:data];
                                   }
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       completion(image, connectionError);
                                   });
                               }
                           }];
}

@end
