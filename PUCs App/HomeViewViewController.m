//
//  HomeViewViewController.m
//  PUCs App
//
//  Created by RAMIN NADAF on 9/2/18.
//  Copyright © 2018 RAMIN NADAF. All rights reserved.
//

#import "HomeViewViewController.h"
#import "YTVimeoExtractor.h"

extern Globals *globalVars;


@interface HomeViewViewController ()
    
    @property (nonatomic, strong) PUCsAdView *pucsView;
    @property (nonatomic, strong) NSTimer    *videoStatusTimer;
    @property (nonatomic)         BOOL        videoIsPlaying;

    @property (strong, nonatomic) AVPlayerViewController *playerViewController;

@end


@implementation HomeViewViewController



#define DEFAULT_MEDIA_VOLUME 1

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    assetTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.playerViewController = [AVPlayerViewController new];
    self.playerViewController.delegate = self;

    self.videoIsPlaying = NO;
    self.pucsView = [[PUCsAdView alloc] initWithFrame:self.view.frame];

    DBAccess *dbAccess = [[DBAccess alloc] init];
    currentAssets = [dbAccess getVideosForCategory:globalVars.currentAssetCategory];
    [dbAccess closeDatabase];
}

-(void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    NSString *titleString;
    NSInteger categroy = globalVars.currentAssetCategory;
    if (categroy == ASSET_CATEGORY_MYASSET)
        titleString = @"Currently watching";
    else if (categroy == ASSET_CATEGORY_TOPASSET)
        titleString = @"New releases";
    else if (categroy == ASSET_CATEGORY_SUGGESTION)
        titleString = @"Recommended";
    else if (categroy == ASSET_CATEGORY_TRENDING)
        titleString = @"Trending now";
    
    titleButton.title = [NSString stringWithFormat:@"%@ videos", titleString];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [self.pucsView transitionAdViewToSize:size];
}


-(IBAction)viewDone:(id)sender {
    
    [NSNotificationCenter.defaultCenter removeObserver:self];
    
    [self.videoStatusTimer invalidate];
    self.videoStatusTimer = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)refreshTableView:(id)sender {
    
    [assetTableView reloadData];
}


#pragma mark video playback


-(void)playVideo:(VimeoVideo *)vimeoVideo {
  
    NSString *videoURLstring = vimeoVideo.videoURL;
    [[YTVimeoExtractor sharedExtractor] fetchVideoWithVimeoURL:videoURLstring withReferer:nil completionHandler:^(YTVimeoVideo * _Nullable video, NSError * _Nullable error)
    {
        if (video)
        {
            /*
            NSURL *videoURL = [video highestQualityStreamURL];
            [self.playerViewController playVimeoVideo:videoURL];
            [self presentViewController:self.playerViewController animated:YES completion:nil];
             */
            
            NSURL *highQualityURL = [video highestQualityStreamURL];
            AVPlayer *avPlayer = [AVPlayer playerWithURL:highQualityURL];
            [avPlayer addObserver:self forKeyPath:@"rate" options:0 context:0];
            self.playerViewController.player = avPlayer;
            [self presentViewController:self.playerViewController animated:YES completion:nil];
            [avPlayer play];
            self.videoIsPlaying = YES;
            
        }
        else
        {
            UIAlertController *alert;
            UIAlertAction *okAction;
            alert =   [UIAlertController
                       alertControllerWithTitle:@"Video Failed"
                       message:@"Unable to access video. Check your internet connection and try again."
                       preferredStyle:UIAlertControllerStyleAlert];
            
            okAction  = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction *action)
                         {
                         }];
            
            [alert addAction:okAction];
            [self.navigationController presentViewController:alert animated:NO completion:nil];
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"rate"] && !self.playerViewController.isBeingDismissed)
    {
        if (self.playerViewController.player.timeControlStatus == AVPlayerTimeControlStatusPaused)
        {
            NSLog(@"PUCsDemo-Video Paused");
            [self.pucsView playAdsForClient:@"136154" onAVPlayerViewController:self.playerViewController withFailureBlock:^(NSError * _Nonnull error) {
                NSLog(@"pucsPlayAdsError: %@", error);
            }];
            self.videoStatusTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkVideoStatus:) userInfo:nil repeats:YES];
        }
        else
        {
            [self.pucsView stopAds];
            [self.videoStatusTimer invalidate];
            self.videoStatusTimer = nil;
        }
    }
}

-(IBAction)checkVideoStatus:(id)sender {

//    NSLog(@"Timer firing");
    if (self.videoIsPlaying)
    {
        if (self.playerViewController.isBeingDismissed || self.playerViewController.nextResponder == nil)
        {
            self.videoIsPlaying = NO;
            [self.pucsView stopAds];
            [self.videoStatusTimer invalidate];
            self.videoStatusTimer = nil;
        }
    }
}


#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return currentAssets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ClubCellIdentifier = @"MyMovieTableCell";
    
    MyMovieTableViewCell *cell = (MyMovieTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ClubCellIdentifier];
    if (!cell) {
        UINib *accountCellNib = [UINib nibWithNibName:@"MyMovieTableViewCell" bundle:nil];
        [accountCellNib instantiateWithOwner:self options:nil];
        cell = assetCell;
        assetCell = nil;
    }
    
    VimeoVideo *vm = [currentAssets objectAtIndex:indexPath.row];
    cell.vimeoVideo = vm;
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VimeoVideo *vm = [currentAssets objectAtIndex:indexPath.row];
    [self playVideo:vm];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VimeoVideo *vm = [currentAssets objectAtIndex:indexPath.row];
    [self playVideo:vm];
}



#pragma mark -
#pragma mark memory management

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
