//
//  MarketPlaceViewController.h
//  DigiCoin
//
//  Created by RAMIN NADAF on 7/13/18.
//  Copyright © 2018 Nadaf, Ramin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <PUCsAdPlayer/PUCsAdPlayer.h>
#import "constants.h"
#import "DBAccess.h"
#import "Globals.h"
#import "MarketPlaceTableViewCell.h"


@interface MarketPlaceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AVPlayerViewControllerDelegate, MarketPlaceTableViewCellDelegate> {
    
}



@end
