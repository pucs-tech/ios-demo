//
//  MyMovieTableViewCell.m
//  DigiCoin
//
//  Created by RAMIN NADAF on 7/10/18.
//  Copyright © 2018 Nadaf, Ramin. All rights reserved.
//

#import "MyMovieTableViewCell.h"


@implementation MyMovieTableViewCell

@synthesize vimeoVideo;


- (void)setVimeoVideo:(VimeoVideo *)newVM {
    
    if (vimeoVideo != newVM) {
        vimeoVideo = newVM;

        _movieNameLabel.text = vimeoVideo.videoTitle;
        NSInteger videoLength = vimeoVideo.videoLength;
        NSInteger minutes = videoLength / 60.0;
        NSInteger seconds = videoLength - (minutes * 60);
        _lengthLabel.text = [NSString stringWithFormat:@"%ld:%ld minutes", (long)minutes, (long)seconds];
        _videoImage.image = vimeoVideo.videoImage;
    }
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    selectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    selectedBackgroundView.backgroundColor = STANDARD_BLUE_COLOR;
    self.selectedBackgroundView = selectedBackgroundView;
}

@end
