//
//  HomeViewViewController.h
//  PUCs App
//
//  Created by RAMIN NADAF on 9/2/18.
//  Copyright © 2018 RAMIN NADAF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <PUCsAdPlayer/PUCsAdPlayer.h>
#import "constants.h"
#import "DBAccess.h"
#import "MyMovieTableViewCell.h"


@interface HomeViewViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AVPlayerViewControllerDelegate> {
    
    IBOutlet UITableView          *assetTableView;
    IBOutlet MyMovieTableViewCell *assetCell;
    IBOutlet UIBarButtonItem      *titleButton;
    NSArray                       *currentAssets;
}


@end
