//
//  MarketPlaceViewController.m
//  PUCs App
//
//  Created by RAMIN NADAF on 7/13/18.
//  Copyright © 2018 Nadaf, Ramin. All rights reserved.
//

#import "MarketPlaceViewController.h"
#import "YTVimeoExtractor.h"


extern Globals *globalVars;

@interface MarketPlaceViewController ()

    @property (nonatomic, strong) PUCsAdView *pucsAddPlayer;
    @property (nonatomic, strong) NSTimer    *videoStatusTimer;
    @property (nonatomic)         BOOL       videoIsPlaying;

    @property (nonatomic, assign) IBOutlet MarketPlaceCollectionViewCell *assetCell;
    @property (nonatomic, retain) IBOutlet UITableView                   *marketTableView;
    @property (nonatomic, strong) VimeoVideo                             *selectedVideo;
    @property (strong, nonatomic) AVPlayerViewController                 *playerViewController;

    @property (nonatomic, strong) NSString   *clientID;
@end


@implementation MarketPlaceViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.marketTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    globalVars.currentVideo = nil;

    self.clientID = @"446778";
    titleLable.text = @"XYZ Streaming Service";
    
    self.playerViewController = [AVPlayerViewController new];
    self.playerViewController.delegate = self;
    
    self.videoIsPlaying = NO;
    self.pucsAddPlayer = [[PUCsAdView alloc] initWithFrame:self.view.frame];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self displaySelectedCollection];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [self.pucsAddPlayer transitionAdViewToSize:size];
}

-(IBAction)changeAddServer:(id)sender {
    
    if ([self.clientID length] == 0)
    {
        self.clientID = @"446778";
        titleLable.text = @"XYZ Streaming Service";
    }
    else
    {
        self.clientID = @"";
        titleLable.text = @"ACME Streaming Service";
    }
}

-(void)displaySelectedCollection {
    
    while (globalVars.currentMovieCollections.count > 0)
        [globalVars.currentMovieCollections removeObjectAtIndex:0];
    
    for (int i=0; i < globalVars.currentMovieCollections.count; i++)
        [globalVars.currentMovieCollections removeObjectAtIndex:i];
    
    DBAccess *dbAccess = [[DBAccess alloc] init];
    NSArray *assets = [dbAccess getVideosForCategory:ASSET_CATEGORY_MYASSET];
    [globalVars.currentMovieCollections addObject:assets];
    assets = [dbAccess getVideosForCategory:ASSET_CATEGORY_TOPASSET];
    [globalVars.currentMovieCollections addObject:assets];
    assets = [dbAccess getVideosForCategory:ASSET_CATEGORY_SUGGESTION];
    [globalVars.currentMovieCollections addObject:assets];
    assets = [dbAccess getVideosForCategory:ASSET_CATEGORY_TRENDING];
    [globalVars.currentMovieCollections addObject:assets];

    [dbAccess closeDatabase];
    
    [self.marketTableView reloadData];
}


-(IBAction)dbSubmitButtonClicked:(id)sender {
    
    [self performSegueWithIdentifier:@"ShowAddAssetViewController" sender:self];
}


#pragma mark video playback


-(void)playVideo:(VimeoVideo *)vimeoVideo {
    
    NSString *videoURLstring = vimeoVideo.videoURL;
    [[YTVimeoExtractor sharedExtractor] fetchVideoWithVimeoURL:videoURLstring withReferer:nil completionHandler:^(YTVimeoVideo * _Nullable video, NSError * _Nullable error)
     {
         if (video)
         {
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
            NSLog(@"PucsDemo-Video paused ");
            [self.pucsAddPlayer playAdsForClient:self.clientID onAVPlayerViewController:self.playerViewController withFailureBlock:^(NSError * _Nonnull error) {
                NSLog(@"pucsPlayAdsError: %@", error);
            }];
            self.videoStatusTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(checkVideoStatus:) userInfo:nil repeats:YES];
        }
        else
        {
            [self.pucsAddPlayer stopAds];
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
            [self.pucsAddPlayer stopAds];
            [self.videoStatusTimer invalidate];
            self.videoStatusTimer = nil;
        }
    }
}



#pragma mark -
#pragma mark Table Cell delegate


- (void)marketTableCellDidSelectMovie:(MarketPlaceTableViewCell *)marketTableCell movieIndex:(NSInteger)index {
    
    [self playVideo:globalVars.currentVideo];
}


- (void)marketTableCellDidSelectSeeAll:(MarketPlaceTableViewCell *)marketTableCell movieIndex:(NSInteger)index {
    
    [self performSegueWithIdentifier:@"ShowHomeViewController" sender:self];
}

/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ShowPlayMovieViewDirect"])
    {
        PlayMovieViewController *vc = [segue destinationViewController];
        vc.vimeoVideo = self.selectedVideo;
    }
}
*/

#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return globalVars.currentMovieCollections.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MarketPlaceTableViewCell *cell = (MarketPlaceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MarketPlaceTableCell"];
    
    NSInteger row = indexPath.row;
    NSArray *assets = [globalVars.currentMovieCollections objectAtIndex:row];
    
    NSString *titleString;
    if (row == ASSET_CATEGORY_MYASSET)
        titleString = @"Currently watching";
    else if (row == ASSET_CATEGORY_TOPASSET)
        titleString = @"New releases";
    else if (row == ASSET_CATEGORY_SUGGESTION)
        titleString = @"Recommended videos";
    else if (row == ASSET_CATEGORY_TRENDING)
        titleString = @"Trending now";
    cell.titleLabel.text = titleString;
    
    cell.delegate = self;
    cell.seeAllButton.tag = row;
    cell.tag = row;
    cell.marketAssets = assets;
    [cell.marketCollectionView reloadData];
    
    return cell;
}



#pragma mark Table view delegate


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark memory management


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
