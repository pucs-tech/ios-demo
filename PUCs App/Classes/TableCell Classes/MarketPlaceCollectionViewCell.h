//
//  MarketPlaceCollectionViewCell.h
//  DigiCoin
//
//  Created by RAMIN NADAF on 7/13/18.
//  Copyright © 2018 Nadaf, Ramin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarketPlaceCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) IBOutlet UIImageView *assetImage, *assetStatusImage;
@property (nonatomic, retain) IBOutlet UILabel *assetNameLabel;

@end
