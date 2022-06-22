//
//  TweetCell.m
//  twitter
//
//  Created by Shirley Zhu on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "APIManager.h"

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
    if (self.tweet.favorited == NO) {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        // Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
        // Change the image
        [sender setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    }
    else {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        // Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
        // Change the image
        [sender setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    }
    // Update cell UI
    [self refreshData];
}

- (void)refreshData{
    [self.favoriteCount setText:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount]];
}

@end
