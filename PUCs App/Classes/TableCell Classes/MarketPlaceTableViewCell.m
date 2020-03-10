//
//  MarketPlaceTableViewCell.m
//  DigiCoin
//
//  Created by RAMIN NADAF on 7/13/18.
//  Copyright © 2018 Nadaf, Ramin. All rights reserved.
//

#import "MarketPlaceTableViewCell.h"

extern Globals *globalVars;


@implementation MarketPlaceTableViewCell

@synthesize marketAssets;


#pragma mark -
#pragma mark Collection view data source


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return marketAssets.count;
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {

    MarketPlaceCollectionViewCell *cell = (MarketPlaceCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MarketPlaceCollectionViewIdentifier" forIndexPath:indexPath];
    
    VimeoVideo *asset = [self.marketAssets objectAtIndex:indexPath.row];

    NSString *string = asset.videoTitle;

    NSInteger videoLength = asset.videoLength;
    NSInteger minutes = videoLength / 60.0;
    NSInteger seconds = videoLength - (minutes * 60);
    NSString *lengthStr = [NSString stringWithFormat:@"%ld:%ld", (long)minutes, (long)seconds];

    
//    NSString *genre;
//    genre = asset.videoGenre;
        
    cell.assetNameLabel.text = [NSString stringWithFormat:@"%@\n%@", string, lengthStr];
    [cell.assetNameLabel sizeToFit];
    
    cell.assetImage.image = asset.videoImage;
    return cell;
}


-(IBAction)seeAllClick:(id)sender {

    UIButton *buttonClicked = (UIButton *)sender;
    NSInteger tag = buttonClicked.tag;
    globalVars.selectedAssetIndex = tag;
    globalVars.currentAssetCategory = self.tag;
    globalVars.currentAssetsArray = self.marketAssets;

    [self.delegate marketTableCellDidSelectSeeAll:self movieIndex:tag];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger row = indexPath.row;
    globalVars.selectedAssetIndex = row;
    globalVars.currentVideo = [self.marketAssets objectAtIndex:row];
    globalVars.currentAssetCategory = self.tag;
    [self.delegate marketTableCellDidSelectMovie:self movieIndex:self.tag];
}



@end
