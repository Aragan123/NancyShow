//
//  BGSwitchViewController.h
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/04.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPageSwitcherDelegate.h"

@class BGViewController;
@class BGAboutViewController;
@class BGGalleryViewController;
@class BGTplHomeViewController;
@class BGDiaryViewController;

@interface BGSwitchViewController : UIViewController <BGPageSwitcherDelegate>{
    BGViewController *homePageViewController;
    BGAboutViewController *aboutPageViewController;
    BGGalleryViewController *galleryPageViewController;
    BGTplHomeViewController *tplHomeViewController;
    BGDiaryViewController *diaryViewController;
}

@property(nonatomic, retain) BGViewController *homePageViewController;
@property(nonatomic, retain) BGAboutViewController *aboutPageViewController;
@property(nonatomic, retain) BGGalleryViewController *galleryPageViewController;
@property(nonatomic, retain) BGTplHomeViewController *tplHomeViewController;
@property(nonatomic, retain) BGDiaryViewController *diaryViewController;

-(UIViewController*) getSwitchViewController: (int) pageNum;

@end
