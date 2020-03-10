//
//  AddVideoViewController.m
//  PUCs App
//
//  Created by RAMIN NADAF on 11/6/18.
//  Copyright © 2018 RAMIN NADAF. All rights reserved.
//

#import "AddVideoViewController.h"
#import "YTVimeoExtractor.h"


@implementation AddVideoViewController

@synthesize assetCell, assets, assetTableView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.assets = [[NSMutableArray alloc] init];
    self.assetTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}



-(IBAction)search:(id)sender {
    
    [searchField resignFirstResponder];

    NSString *videoID = searchField.text;
    NSString *videoURL = [NSString stringWithFormat:@"%@%@", @"https://vimeo.com/", videoID];
    [[YTVimeoExtractor sharedExtractor]fetchVideoWithVimeoURL:videoURL withReferer:nil
                        completionHandler:^(YTVimeoVideo * _Nullable video, NSError * _Nullable error) {
         if (video) {
             VimeoVideo *vm = [[VimeoVideo alloc] init];
             vm.videoID = [videoID integerValue];
             vm.videoURL = videoURL;
             vm.videoTitle = video.title;
             vm.videoLength = video.duration;
             NSURL *highestURL = video.thumbnailURLs[@(YTVimeoVideoThumbnailQualityHD)];
             NSData *data = [NSData dataWithContentsOfURL:highestURL];
             vm.videoImage = [[UIImage alloc] initWithData:data];
             
             [self.assets addObject:vm];
             [self.assetTableView reloadData];
         }
         else {
             NSString *errorTiltle = error.localizedDescription;
             NSString *errorMessage = error.localizedFailureReason;
             UIAlertController *alert;
             UIAlertAction *okAction;
             alert =   [UIAlertController
                        alertControllerWithTitle:errorTiltle
                        message:errorMessage
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




#pragma mark Textfield Delegate


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self search:searchButton];
    return YES;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [searchField resignFirstResponder];
}


-(IBAction)viewDone:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.assets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ClubCellIdentifier = @"MyMovieTableCell";
    
    MyMovieTableViewCell *cell = (MyMovieTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ClubCellIdentifier];
    if (!cell) {
        UINib *accountCellNib = [UINib nibWithNibName:@"MyMovieTableViewCell" bundle:nil];
        [accountCellNib instantiateWithOwner:self options:nil];
        cell = self.assetCell;
        self.assetCell = nil;
    }
    
    VimeoVideo *vm = [self.assets objectAtIndex:indexPath.row];
    cell.vimeoVideo = vm;
    return cell;
}

#pragma mark -
#pragma mark Table view delegate



- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VimeoVideo *vm = [self.assets objectAtIndex:indexPath.row];
    [self addAsset:vm];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VimeoVideo *vm = [self.assets objectAtIndex:indexPath.row];
    [self addAsset:vm];
}


-(void)addAsset:(VimeoVideo *)vm {
    
    DBAccess *dbAccess = [[DBAccess alloc] init];
    BOOL result = [dbAccess addVimeoVideo:vm];
    [dbAccess closeDatabase];
    
    NSString *title;
    NSString *message;
    if (result) {
        title = @"SUCCESS";
        message = @"Video added successfully!";
    }
    else {
        title = @"ERROR";
        message = @"There was an error to add asset %@.\nThe asset was NOT added.";
    }
    UIAlertController *alert;
    UIAlertAction *okAction;
    alert =   [UIAlertController
               alertControllerWithTitle:title
               message:message
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


#pragma mark -
#pragma mark memory management

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}




@end
