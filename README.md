# PUCs iOS Ad Player Demo & Framework

PUCs AdPlayer is a powerful yet simple-to-use framework to show ads over a AVPlayerViewController when paused. This repo contains the iOS demo app and the framework.

## Demo Usage

Download the code and open PUCs Demo.xcodeproj in Xcode. All the demo app functionality is in MarketPlaceViewController. 

# Using PUCs Framework in Another App

Follow the below steps to use the framework in your own app.

## Framework Installation

Copy the PUCsAdPlayer.framework folder to your iOS app project folder.  In Xcode, click the ‘+’ button under Frameworks, Libraries, and Embedded Content.  Click the Add Other button and select Add Files.  Select the framework folder and click Open.

## Usage

1. Add the following to the .m file of the view controller that will use the framework:

```
#import <PUCsAdPlayer/PUCsAdPlayer.h>
...

@interface MyViewControler()
  ...
  @property (nonatomic, strong) PUCsAdView *pucsAddPlayer;
@end
```

2. Initialize the framework in viewDidLoad:

```
...
self.pucsAddPlayer = [[PUCsAdView alloc] initWithFrame:self.view.frame];
```

3. Add the following to viewWillTransitionToSize:

```
...

[self.pucsAddPlayer transitionAdViewToSize:size];

```

4. Invoke the playAdsForClient method of the framework to display ads, typically when the host app is paused:

```
[self.pucsAddPlayer playAdsForClient:@"446778" onAVPlayerViewController:self.playerViewController 
  withFailureBlock:^(NSError * _Nonnull error) {
                NSLog(@"pucsPlayAdsError: %@", error);
  }];
  ````
  
  Note: the current framework can only be used with an AVPlayerViewController.
  
  4. Invoke the stopAd method of the framework to remove the popup:
  
  ```
  [self.pucsAddPlayer stopAds];
  ````
  
