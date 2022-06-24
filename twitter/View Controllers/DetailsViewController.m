//
//  DetailsViewController.m
//  twitter
//
//  Created by Shirley Zhu on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"


@interface DetailsViewController ()
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // name
    self.detailsName.text = self.detailsTweet.user.name;
    // text
    self.detailsTweetText.text = self.detailsTweet.text;
    // username
    self.detailsUsername.text = [NSString stringWithFormat:@"@%@", self.detailsTweet.user.screenName];
    // profile picture
    NSString *URLString = self.detailsTweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    [self.detailsProfilePic setImageWithURL:url];
    
    // date
    NSDateFormatter *formatterTime = [[NSDateFormatter alloc] init];
    NSDateFormatter *formatterDate = [[NSDateFormatter alloc] init];
    // Configure output format
    formatterTime.timeStyle = NSDateFormatterShortStyle;
    formatterDate.dateStyle = NSDateFormatterShortStyle;
    // Convert Date to String
    NSString *time = [formatterTime stringFromDate:self.detailsTweet.date];
    NSString *date = [formatterDate stringFromDate:self.detailsTweet.date];
    self.detailsDate.text = [NSString stringWithFormat:@"%@ • %@", time, date];
    
    // favorite count
    [self.detailsLikeCount setText:[NSString stringWithFormat:@"%d", self.detailsTweet.favoriteCount]];
    
    // retweet count
    [self.detailsRetweetCount setText:[NSString stringWithFormat:@"%d", self.detailsTweet.retweetCount]];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)detaisTapRetweet:(id)sender {
    if (self.detailsTweet.retweeted == NO) {
        self.detailsTweet.retweeted = YES;
        self.detailsTweet.retweetCount += 1;
        // Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] retweet:self.detailsTweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    else {
        self.detailsTweet.retweeted = NO;
        self.detailsTweet.retweetCount -= 1;
        // Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] unretweet:self.detailsTweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    // Update cell UI
    [self refreshData];
}

- (IBAction)detailsTapFavorite:(id)sender {
    // Update the local tweet model
    if (self.detailsTweet.favorited == NO) {
        self.detailsTweet.favorited = YES;
        self.detailsTweet.favoriteCount += 1;
        // Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] favorite:self.detailsTweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    else {
        self.detailsTweet.favorited = NO;
        self.detailsTweet.favoriteCount -= 1;
        // Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] unfavorite:self.detailsTweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    // Update cell UI
    [self refreshData];
}

- (void)refreshData{
    [self.detailsLikeCount setText:[NSString stringWithFormat:@"%d", self.detailsTweet.favoriteCount]];
    [self.detailsRetweetCount setText:[NSString stringWithFormat:@"%d", self.detailsTweet.retweetCount]];
    // heart button should be red if liked
    if (self.detailsTweet.favorited == YES) {
        [self.detailsFavButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    }
    
    // retweet button is colored if retweeted
    if (self.detailsTweet.retweeted == YES) {
        [self.detailsRetweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    }
    else {
        [self.detailsRetweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    }
}

@end
