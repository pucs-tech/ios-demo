//
//  DBAccess.m
//  DesignerApparels
//
//  Created by Ramin on 11/23/10.
//  Copyright 2010 FADAN LLC. All rights reserved.
//

#import "DBAccess.h"


@implementation DBAccess


sqlite3 *database;



-(NSArray *)getVimeoVideos {
    
    NSMutableArray *videos = [[NSMutableArray alloc] init];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT VimeoVideos.video_control_id, VimeoVideos.video_id, VimeoVideos.video_url, VimeoVideos.video_title, VimeoVideos.video_length, VimeoVideos.video_image FROM VimeoVideos ORDER BY VimeoVideos.video_title"];
    
    sqlite3_stmt *statement;
    int sqlResult = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
    
    if (sqlResult == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            VimeoVideo *vm = [[VimeoVideo alloc] init];
            vm.videoControlID = sqlite3_column_int(statement, 0);
            vm.videoID = sqlite3_column_int(statement, 1);
            char *name = (char *)sqlite3_column_text(statement, 2);
            vm.videoURL = (name) ? [NSString stringWithUTF8String:name] : @"";
            name = (char *)sqlite3_column_text(statement, 3);
            vm.videoTitle = (name) ? [NSString stringWithUTF8String:name] : @"";
            vm.videoLength = sqlite3_column_int(statement, 4);
            NSData *data1 = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 5) length:sqlite3_column_bytes(statement, 5)];
            vm.videoImage = [UIImage imageWithData:data1];
            
            [videos addObject:vm];
        }
    }
    else
    {
        NSString *message=[NSString stringWithUTF8String:sqlite3_errmsg(database)];
        [self showDatabaseAlert:message];
    }
    
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return videos;
}

-(BOOL)addVimeoVideo:(VimeoVideo *)vimeoVideo {
    
    NSString *sql = @"INSERT INTO VimeoVideos (video_ID, video_url, video_title, video_length, video_image) VALUES (?, ?, ?, ?, ?)";
    sqlite3_stmt *statement;
    
    int sqlResult = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
    if (sqlResult != SQLITE_OK)
    {
        NSString *message=[NSString stringWithUTF8String:sqlite3_errmsg(database)];
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
        [self showDatabaseAlert:message];
        return NO;
    }

    sqlite3_bind_int64(statement, 1, vimeoVideo.videoID);
    sqlite3_bind_text(statement,  2, [vimeoVideo.videoURL UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,  3, [vimeoVideo.videoTitle UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int64(statement, 4, vimeoVideo.videoLength);
    NSData *imageData = UIImagePNGRepresentation(vimeoVideo.videoImage);
    sqlite3_bind_blob(statement,  5, imageData.bytes, (int)imageData.length, NULL);

    if (sqlite3_step(statement) != SQLITE_DONE)
    {
        NSString *message=[NSString stringWithUTF8String:sqlite3_errmsg(database)];
        [self showDatabaseAlert:message];
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
        return NO;
    }
    
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return YES;
}



-(NSArray *)getVideosForCategory:(NSInteger)assetCategory {
    
    NSMutableArray *videos = [[NSMutableArray alloc] init];
    NSString *sql = [NSString stringWithFormat:@"SELECT VimeoVideos.video_control_id, VimeoVideos.video_id, VimeoVideos.video_url, VimeoVideos.video_title, VimeoVideos.video_length, VimeoVideos.video_image, VimeoVideos.asset_category, VimeoVideos.asset_genre FROM VimeoVideos WHERE VimeoVideos.asset_category = %ld ORDER BY VimeoVideos.video_title ", (long)assetCategory];
    
    sqlite3_stmt *statement;
    int sqlResult = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
    
    if (sqlResult == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            VimeoVideo *video = [[VimeoVideo alloc] init];
            video.videoControlID = sqlite3_column_int(statement, 0);
            video.videoID = sqlite3_column_int(statement, 1);

            char *text = (char *)sqlite3_column_text(statement, 2);
            video.videoURL = (text) ? [NSString stringWithUTF8String:text] : @"";
            
            text = (char *)sqlite3_column_text(statement, 3);
           video.videoTitle = (text) ? [NSString stringWithUTF8String:text] : @"";
            
            video.videoLength = sqlite3_column_int(statement, 4);
            
            NSData *data1 = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 5) length:sqlite3_column_bytes(statement, 5)];
           video.videoImage = [UIImage imageWithData:data1];
            
            video.videoCategroy = sqlite3_column_int(statement, 6);
            
            text = (char *)sqlite3_column_text(statement, 7);
            video.videoGenre = (text) ? [NSString stringWithUTF8String:text] : @"";

            [videos addObject:video];
        }
    }
    else
    {
        NSString *message=[NSString stringWithUTF8String:sqlite3_errmsg(database)];
        [self showDatabaseAlert:message];
    }
    
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return videos;
}


-(Asset *)parseAssetFromDBstatement:(sqlite3_stmt *)statement {
    
    Asset *asset = [[Asset alloc] init];

    asset.assetID = sqlite3_column_int(statement, 0);
    asset.assetUUID = sqlite3_column_int(statement, 1);
    
    char *name = (char *)sqlite3_column_text(statement, 2);
    asset.assetURL = (name) ? [NSString stringWithUTF8String:name] : @"";

    name = (char *)sqlite3_column_text(statement, 3);
    asset.assetName = (name) ? [NSString stringWithUTF8String:name] : @"";
    
    asset.assetLength = sqlite3_column_int(statement, 4);

    NSData *data1 = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 5) length:sqlite3_column_bytes(statement, 5)];
    asset.image1 = [UIImage imageWithData:data1];

    asset.assetCategory = sqlite3_column_int(statement, 6);
    
    name = (char *)sqlite3_column_text(statement, 7);
    asset.assetGenre = (name) ? [NSString stringWithUTF8String:name] : @"";
    
    return asset;
}


- (NSInteger)randomNumberBetween:(float)min maxNumber:(float)max {
    float randomNum = (((float)arc4random()/0x100000000)*((max-min)+min));
    return round(randomNum);
}


-(NSString *)randomAlphanumericStringWithLength:(NSInteger)length {
    static NSString * const letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    static dispatch_once_t onceToken;
    NSInteger i = time(NULL);
    dispatch_once(&onceToken, ^{
        srand((int)i);
    });
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random() % [letters length]]];
    }
    
    return randomString;
}


#pragma mark -
#pragma mark DB Access

/********************** DB ACCESS **********************/

-(NSDate *)convertCharToDate:(char *)dateChar {
    
    NSString *sDate = (dateChar) ? [NSString stringWithUTF8String:dateChar] : @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    
    NSDate *date = [dateFormatter dateFromString:sDate];
    
    return date;
}


-(NSDate *)convertStringToDate:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if ([dateString length] > 10)
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:MM"];
    else
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    return date;
}


-(NSDate *)convertStringToTime:(char *)timeString {
    
    NSString *sDate = (timeString) ? [NSString stringWithUTF8String:timeString] : @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm:ss"];
    
    NSDate *time = [dateFormatter dateFromString:sDate];
    
    return time;
}


-(NSString *)convertDateToString:(NSDate *)theDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:theDate];
}



- (id) init {
	
	if (self = [super init])
		[self initializeDatabase];
	
	return self;
}



- (void) initializeDatabase {

    NSString *dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"PUCs.db"];
//    NSString *dbPath = @"/Users/raminnadaf/Desktop/PUCs/Apps/PUCs App with Framework/PUCs App/PUCs.db";

    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSString *message=[NSString stringWithUTF8String:sqlite3_errmsg(database)];
        [self showDatabaseAlert:message];
    }
}


- (void) closeDatabase {
	
	if (sqlite3_close(database) != SQLITE_OK)
        [self showDatabaseAlert:@"failed to close DB"];
}

-(void)showDatabaseAlert:(NSString *)theMessage {
    /*
     */
}


@end
