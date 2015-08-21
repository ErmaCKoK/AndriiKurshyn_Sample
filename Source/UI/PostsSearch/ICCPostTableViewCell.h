//
//  ICCPostTableViewCell.h
//  AndriiKurshyn_iOSCodeChallenge
//
//  Created by Andrii Kurshyn on 7/24/15.
//  Copyright (c) 2015 Andrii Kurshyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICCPost, ICCAvatarImageView;

@interface ICCPostTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* authorLabel;
@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet UILabel* commentsLabel;
@property (nonatomic, weak) IBOutlet UILabel* upsleLabel;
@property (nonatomic, weak) IBOutlet UILabel* downsLabel;
@property (nonatomic, weak) IBOutlet ICCAvatarImageView* avatarImageView;

- (void) setPost:(ICCPost*)post;

@end
