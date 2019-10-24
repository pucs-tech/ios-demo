//
//  Client.h
//  PUCsAdPlayer
//
//  Created by RAMIN NADAF on 3/7/19.
//  Copyright © 2019 RAMIN NADAF. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Client : NSObject {
    
}

@property (nonatomic, strong) NSString     *clientID;
@property (nonatomic, strong) NSString     *clientName;
@property (nonatomic, strong) NSString     *clientAddServer;
@property (nonatomic, strong) NSString     *clientResourceTag;
@property (nonatomic, strong) NSDictionary *clientOptions;

@end

NS_ASSUME_NONNULL_END
