//
//  MarketPlaceTableViewCell.h
//  DigiCoin
//
//  Created by RAMIN NADAF on 7/13/18.
//  Copyright © 2018 Nadaf, Ramin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.h"
#import "Globals.h"
#import "Assets.h"
#import "VimeoVideo.h"
#import "RateView.h"
#import "MarketPlaceCollectionViewCell.h"

@class MarketPlaceTableViewCell;

@protocol MarketPlaceTableViewCellDelegate
    - (void)marketTableCellDidSelectMovie:(MarketPlaceTableViewCell *)marketTableCell movieIndex:(NSInteger)index;
    - (void)marketTableCellDidSelectSeeAll:(MarketPlaceTableViewCell *)marketTableCell movieIndex:(NSInteger)index;
@end


@interface MarketPlaceTableViewCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) IBOutlet UICollectionView *marketCollectionView;
@property (nonatomic, retain) IBOutlet UILabel          *titleLabel;
@property (nonatomic, retain) IBOutlet UIButton         *seeAllButton;
@property (nonatomic, retain) NSArray                   *marketAssets;

@property (nonatomic, assign) id<MarketPlaceTableViewCellDelegate>   delegate;


@end
