//
//  UIView_PUCsAdView.h
//  PUCsAdPlayer
//
//  Created by RAMIN NADAF on 2/24/19.
//  Copyright © 2019 FADAN LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <WebKit/WebKit.h>
#import "Client.h"


NS_ASSUME_NONNULL_BEGIN

extern NSString *const PlayerEventTrackerNotification;

@interface PUCsAdView : UIView <WKScriptMessageHandler, WKNavigationDelegate> {
    
    AVPlayerViewController *pucs_parentAVPlayerViewController;
    WKWebView              *pucs_webView;
    NSString               *pucs_tagUrl;
    Client                 *pucs_client;
}

-(void)playAdsForClient:(NSString *)clientID onAVPlayerViewController:(AVPlayerViewController *)parentPlayerController withFailureBlock:(void(^)(NSError *error))failure;
-(void)transitionAdViewToSize:(CGSize)size;
-(void)stopAds;

@end

NS_ASSUME_NONNULL_END
