//
//  TweetCell.m
//  twitter
//
//  Created by Shirley Zhu on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapFavorite:(id)sender {
    // Update the local tweet model
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
    // Update cell UI
    [self refreshData];
    // TODO: Send a POST request to the POST favorites/create endpoint
}

- (void)refreshData{
    [self.favoriteCount setText:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount]];
}

@end
