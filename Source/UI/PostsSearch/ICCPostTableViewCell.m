//
//  ICCPostTableViewCell.m
//  AndriiKurshyn_iOSCodeChallenge
//
//  Created by Andrii Kurshyn on 7/24/15.
//  Copyright (c) 2015 Andrii Kurshyn. All rights reserved.
//

#import "ICCPostTableViewCell.h"

#import "ICCPost.h"
#import "ICCAvatarImageView.h"

@implementation ICCPostTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.authorLabel.text = @"";
    self.titleLabel.text = @"";
    self.avatarImageView.URL = nil;
    
    self.commentsLabel.text = @"0 Comments";
    self.upsleLabel.text = @"0 Ups";
    self.downsLabel.text = @"0 Donws";
}

- (void)setPost:(ICCPost *)post {
    self.authorLabel.text = post.author;
    self.titleLabel.text = post.title;
    self.avatarImageView.URL = [NSURL URLWithString:post.thumbnail];
    
    self.commentsLabel.text = [NSString stringWithFormat:@"%li Comments",(long)post.ups.integerValue];
    self.upsleLabel.text = [NSString stringWithFormat:@"%li Ups",(long)post.ups.integerValue];
    self.downsLabel.text = [NSString stringWithFormat:@"%li Donws",(long)post.downs.integerValue];
}

@end
