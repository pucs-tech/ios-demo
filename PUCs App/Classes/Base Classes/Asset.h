//
//  Asset.h
//  DigiCoin
//
//  Created by RAMIN NADAF on 8/4/18.
//  Copyright © 2018 Nadaf, Ramin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Asset : NSObject


@property (nonatomic) NSInteger        assetUUID;
@property (nonatomic) NSInteger        assetID;
@property (nonatomic, retain) NSString *assetURL;
@property (nonatomic) NSInteger        artistID;
@property (nonatomic) NSInteger        publisherID;
@property (nonatomic) NSInteger        labelID;
@property (nonatomic) NSInteger        assetType;
@property (nonatomic) NSInteger        assetCategory;
@property (nonatomic) NSInteger        assetStatusInMarketPlace;
@property (nonatomic, retain) NSString *assetName;
@property (nonatomic, retain) NSString *assetGenre;
@property (nonatomic) NSInteger        assetLength;
@property (nonatomic, retain) NSString *assetDescription;
@property (nonatomic, retain) NSDate  *datePurchased;
@property (nonatomic) float           purchasePrice;
@property (nonatomic, retain) NSString *industryRating;
@property (nonatomic) float           mainRanking;
@property (nonatomic) NSInteger       otherRanking;
@property (nonatomic) NSInteger       otherRankingSource;
@property (nonatomic, retain) UIImage  *otherRankingImage;
@property (nonatomic, retain) UIImage  *image1;
@property (nonatomic, retain) UIImage  *image2;
@property (nonatomic) NSInteger         yearReleased;
@property (nonatomic) NSInteger         numAvailableInMarket;
@property (nonatomic, retain) NSString  *artistName;


@end
