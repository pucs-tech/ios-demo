//
//  Globals.m
//  DigiCoin
//
//  Created by RAMIN NADAF on 7/20/18.
//  Copyright © 2018 Nadaf, Ramin. All rights reserved.
//

#import "Globals.h"

@implementation Globals

@synthesize currentVideo;
@synthesize currentAssetsArray;
@synthesize currentMovieCollections;
@synthesize currentAssetType;
@synthesize currentAssetCategory;
@synthesize selectedAssetIndex;
@synthesize currentTransactionCategory;
@synthesize currentPublisherID;
@synthesize appStatus;
@synthesize currentPublisherAssetType;


-(id)init {
    
    if (self = [super init])
    {
     
        self.currentVideo = [[VimeoVideo alloc] init];
        self.currentAssetsArray = [[NSMutableArray alloc] init];
        self.currentMovieCollections = [[NSMutableArray alloc] init];
        self.currentAssetCategory = ASSET_CATEGORY_MYASSET;
        self.currentAssetType = ASSET_TYPE_MOVIE;
        self.selectedAssetIndex = 0;
        self.currentTransactionCategory = TRANSACTION_STATUS_UNAVAILABLE;
        self.currentPublisherID = PUBLISHER_ID_DISNEY;
        self.currentUserID = 1;
        self.pushFromViewSource = 1;
        self.appStatus = APP_STATUS_HYBRID;
    }
    
    return self;
}



@end
