//
//  DBAccess.h
//  DesignerApparels
//
//  Created by Ramin on 11/23/10.
//  Copyright 2010 FADAN LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "VimeoVideo.h"
#import "constants.h"
#import "Globals.h"
#import "Asset.h"



@interface DBAccess : NSObject {

}

-(NSArray *)getVideosForCategory:(NSInteger)assetCategory;

-(NSArray *)getVimeoVideos;
-(BOOL)addVimeoVideo:(VimeoVideo *)vimeoVideo;
-(void)showDatabaseAlert:(NSString *)theMessage;

/********************** Init **********************/

- (void) initializeDatabase;
- (void) closeDatabase;

@end
