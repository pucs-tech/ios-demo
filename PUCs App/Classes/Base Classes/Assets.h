//
//  Assets.h
//  DigiCoin
//
//  Created by Nadaf, Ramin on 7/5/18.
//  Copyright © 2018 Nadaf, Ramin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Assets : NSObject {
    
}

@property (nonatomic) NSInteger accountID;
@property (nonatomic) NSInteger assetID;
@property (nonatomic, retain) NSString *assetName;
@property (nonatomic, retain) UIImage *assetIcon;
@property (nonatomic) NSInteger numOwned;
@property (nonatomic) NSInteger numBought;
@property (nonatomic) NSInteger numSold;



@end
