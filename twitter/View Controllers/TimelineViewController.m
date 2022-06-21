//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"

@interface TimelineViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)didTapLogout:(id)sender;
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.arrayOfTweets = (NSMutableArray*) tweets;
            for (Tweet *tweet in tweets) {
                NSLog(@"%d", tweet.favoriteCount);
//                [self.arrayOfTweets addObject:tweet];
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
//    [[APIManager shared] logout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
//    cell.profilePic = [UIImage imageWithData:urlData];
    cell.tweet.text = tweet.text;
    cell.username.text = tweet.user.name;
    [cell.retweetCount setText:[NSString stringWithFormat:@"%d", tweet.retweetCount]];
    [cell.favoriteCount setText:[NSString stringWithFormat:@"%d", tweet.favoriteCount]];
    [cell.profilePic setImageWithURL:url];
    NSString *at = @"@";
    NSString *username = tweet.user.screenName;
    NSString *date = tweet.createdAtString;
    cell.usernameAndDate.text = [NSString stringWithFormat:@"%@%@ • %@", at, username, date];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

@end
