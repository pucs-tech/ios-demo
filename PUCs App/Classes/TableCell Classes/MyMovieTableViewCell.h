//
//  MyMovieTableViewCell.h
//  DigiCoin
//
//  Created by RAMIN NADAF on 7/10/18.
//  Copyright © 2018 Nadaf, Ramin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.h"
#import "VimeoVideo.h"



@interface MyMovieTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *movieNameLabel, *lengthLabel;
@property (nonatomic, retain) IBOutlet UIImageView *videoImage;
@property (nonatomic, retain) VimeoVideo *vimeoVideo;

@end
