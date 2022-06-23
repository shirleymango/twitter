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
#import "ComposeViewController.h"
#import "DetailsViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)didTapLogout:(id)sender;
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;

@end

@implementation TimelineViewController

- (void)viewWillAppear:(BOOL)animated{
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.arrayOfTweets = (NSMutableArray*) tweets;
            for (Tweet *tweet in tweets) {
                NSLog(@"%d", tweet.favoriteCount);
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    
    //Initialize UIRefreshControl
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"TweetCompose"]){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"TweetDetails"]) {
        DetailsViewController *detailVC = [segue destinationViewController];
        // Pass the selected object to the new view controller.
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        detailVC.detailsTweet = self.arrayOfTweets[indexPath.row];
    }
}



- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    Tweet *currentTweet = self.arrayOfTweets[indexPath.row];
    cell.tweet = currentTweet;
    NSString *URLString = currentTweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
//    cell.profilePic = [UIImage imageWithData:urlData];
    cell.tweetText.text = currentTweet.text;
    cell.username.text = currentTweet.user.name;
    [cell.retweetCount setText:[NSString stringWithFormat:@"%d", currentTweet.retweetCount]];
    [cell.favoriteCount setText:[NSString stringWithFormat:@"%d", currentTweet.favoriteCount]];
    [cell.profilePic setImageWithURL:url];
    NSString *at = @"@";
    NSString *username = currentTweet.user.screenName;
    NSString *date = currentTweet.date.shortTimeAgoSinceNow;
    cell.usernameAndDate.text = [NSString stringWithFormat:@"%@%@ • %@", at, username, date];
    
    // heart button should be red if liked
    if (currentTweet.favorited == YES) {
        [cell.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    }
    
    // retweet button is colored if retweeted
    if (currentTweet.retweeted == YES) {
        [cell.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.arrayOfTweets = (NSMutableArray*) tweets;
            for (Tweet *tweet in tweets) {
                NSLog(@"%d", tweet.favoriteCount);
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [refreshControl endRefreshing];
    }];
}

- (void)didTweet:(Tweet *)tweet {
    // Add tweet to tweets array
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

@end
