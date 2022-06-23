//
//  DetailsViewController.m
//  twitter
//
//  Created by Shirley Zhu on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Convert String to Date
    // Configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    // Convert Date to String
    self.detailsDate.text = [formatter stringFromDate:self.detailsTweet.date];
    
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

@end
