//
//  Globals.h
//  DigiCoin
//
//  Created by RAMIN NADAF on 7/20/18.
//  Copyright © 2018 Nadaf, Ramin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "constants.h"
#import "DBAccess.h"
#import "Asset.h"


@interface Globals : NSObject {
    
}

@property (nonatomic, retain) NSMutableArray *currentMovieCollections;
@property (nonatomic, retain) NSArray        *currentAssetsArray;
@property (nonatomic, retain) VimeoVideo     *currentVideo;
@property (nonatomic) NSInteger              currentAssetType;
@property (nonatomic) NSInteger              currentAssetCategory;
@property (nonatomic) NSInteger              selectedAssetIndex;
@property (nonatomic) NSInteger              currentTransactionCategory;
@property (nonatomic) NSInteger              currentPublisherID;
@property (nonatomic) NSInteger              currentPublisherAssetType;
@property (nonatomic) NSInteger              currentUserID;
@property (nonatomic) NSInteger              pushFromViewSource;
@property (nonatomic) NSInteger              appStatus;


@end
