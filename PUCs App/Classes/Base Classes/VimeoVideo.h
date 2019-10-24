//
//  VimeoVideo.h
//  PUCs App
//
//  Created by RAMIN NADAF on 11/6/18.
//  Copyright © 2018 RAMIN NADAF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface VimeoVideo : NSObject

@property (nonatomic) NSInteger        videoControlID;
@property (nonatomic) NSInteger        videoID;
@property (nonatomic, retain) NSString *videoURL;
@property (nonatomic, retain) NSString *videoTitle;
@property (nonatomic, retain) NSString *videoGenre;
@property (nonatomic) NSInteger        videoLength;
@property (nonatomic, retain) UIImage  *videoImage;
@property (nonatomic) NSInteger        videoCategroy;

@end

