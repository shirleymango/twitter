//
//  DetailsViewController.h
//  twitter
//
//  Created by Shirley Zhu on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *detailsProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *detailsName;
@property (weak, nonatomic) IBOutlet UILabel *detailsUsername;
@property (weak, nonatomic) IBOutlet UILabel *detailsTweetText;
@property (weak, nonatomic) IBOutlet UILabel *detailsDate;
@property (weak, nonatomic) Tweet *detailsTweet;
@property (weak, nonatomic) IBOutlet UILabel *detailsRetweetCount;
@property (weak, nonatomic) IBOutlet UILabel *detailsLikeCount;

@end

NS_ASSUME_NONNULL_END
