//
//  BGGlobalData.h
//  SophiaShow
//
//  Created by Jeff Zhong on 2013/03/23.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef kGlobalDataFileName
#define kGlobalDataFileName @"SettingData"
#endif

@interface BGGlobalData : NSObject{
    NSArray *galleryBooks;
    NSString *galleryURI;
    NSDictionary *diaryTemplates;
    
    NSArray *onlineGalleryBooks;
    NSDictionary *onlineDiaryTemplates;
    
    UIImage *diaryTplImage; // used to share between diary page and other pages
    NSArray *diaryTplDetail;
}

@property (nonatomic, retain) NSArray *galleryBooks;
@property (nonatomic, copy) NSString *galleryURI;
@property (nonatomic, retain) NSArray *onlineGalleryBooks;

@property (nonatomic, retain) NSDictionary *diaryTemplates;
@property (nonatomic, retain) NSDictionary *onlineDiaryTemplates;

@property (nonatomic, retain) UIImage *diaryTplImage;
@property (nonatomic, retain) NSArray *diaryTplDetail;

+ (BGGlobalData *) sharedData;
-(void) loadSettingsDataFile;
-(void) writeToSettingsDataFile;
-(NSString *) settingsDataFilePath;

@end
