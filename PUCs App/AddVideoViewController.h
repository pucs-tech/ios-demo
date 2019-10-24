//
//  AddVideoViewController.h
//  PUCs App
//
//  Created by RAMIN NADAF on 11/6/18.
//  Copyright © 2018 RAMIN NADAF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBAccess.h"
#import "MyMovieTableViewCell.h"

@interface AddVideoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{

    IBOutlet UITextField     *searchField;
    IBOutlet UIBarButtonItem *searchButton;
}

@property (nonatomic, assign) IBOutlet UITableView          *assetTableView;
@property (nonatomic, assign) IBOutlet MyMovieTableViewCell *assetCell;
@property (nonatomic, retain) NSMutableArray *assets;


@end
