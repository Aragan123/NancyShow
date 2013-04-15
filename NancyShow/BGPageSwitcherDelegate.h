//
//  BGPageSwitcherDelegate.h
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/03.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef kPageMain
#define kPageMain 0
#define kPageGallery 1
#define kPageOnlineGallery 2
#define kPageAbout 3
#define kPageDiaryHome 4
#define kPageDiary 5

#endif

#define kOnlineGalleryURI @"http://122.70.133.214/GalleryNancy/GetGalleryData.php?FileType=plist"
#define kOnlineTemplateURI @"http://122.70.133.214/GalleryNancy/GetTemplateData.php?FileType=json"

enum enumPage {
	pageMain =0,
	pageGallery,
    pageOnlineGallery,
    pageAbout,
    pageDiaryHome,
    pageDiary,

}PageNumber;


@protocol BGPageSwitcherDelegate <NSObject>

-(void) switchViewTo: (int)toPage fromView:(int)fromPage;

@end
