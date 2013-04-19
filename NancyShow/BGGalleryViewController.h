//
//  BGGalleryViewController.h
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/04.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPageSwitcherDelegate.h"
#import "BGScrollViewController.h"

@class AKSegmentedControl;
@class ATPagingView;

@interface BGGalleryViewController : UIViewController <BGScrollViewControllerDelegate>{
    id<BGPageSwitcherDelegate> delegate;
    // views
    UIView *bottomBarView;
    UIPageControl *pageControl;
    UIImageView *bottomBarImgView;
    AKSegmentedControl *segmentedControl;
    BGScrollViewController *scrollViewController;
    // data
    NSArray *galleries;
    BOOL isOnlineGallery; // default is NO
    int currentGalleryIndex; // init with 0
    NSDictionary *currentGalleryObject;
}

@property(nonatomic, assign) id<BGPageSwitcherDelegate> delegate;
@property(nonatomic, retain) IBOutlet UIView *bottomBarView;
@property(nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property(nonatomic, retain) IBOutlet UIImageView *bottomBarImgView;
@property(nonatomic, retain) AKSegmentedControl *segmentedControl;
@property(nonatomic, retain) BGScrollViewController *scrollViewController;

@property(nonatomic, retain) NSArray *galleries;
@property(nonatomic, assign) BOOL isOnlineGallery;
@property(nonatomic, assign) int currentGalleryIndex;
@property(nonatomic, retain) NSDictionary *currentGalleryObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil galleries:(NSArray*)gBooks isOnlineGallery:(BOOL)online;

- (IBAction)clickReturnHome:(id)sender;
- (IBAction)clickPageControl:(id)sender;

@end
