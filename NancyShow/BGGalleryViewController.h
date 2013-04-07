//
//  BGGalleryViewController.h
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/04.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPageSwitcherDelegate.h"
#import "ATPagingView.h"
#import "BGScrollViewController.h"

@class AKSegmentedControl;

@interface BGGalleryViewController : UIViewController <BGScrollViewControllerDelegate>{
    id<BGPageSwitcherDelegate> delegate;
    IBOutlet UIView *bottomBarView;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIImageView *bottomBarImgView;
    
    AKSegmentedControl *segmentedControl;
    NSArray *galleries;
    int currentGalleryIndex; // init with 0
    NSDictionary *currentGalleryObject;
    BOOL isOnlineGallery; // default is NO
    
    BGScrollViewController *scrollViewController;
    
}

@property(nonatomic, retain) id<BGPageSwitcherDelegate> delegate;
@property(nonatomic, retain) IBOutlet UIView *bottomBarView;
@property(nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property(nonatomic, retain) IBOutlet UIImageView *bottomBarImgView;
@property (nonatomic, retain) BGScrollViewController *scrollViewController;
@property (nonatomic, assign) BOOL isOnlineGallery;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil galleries:(NSArray*)gBooks isOnlineGallery:(BOOL)online;

- (IBAction)clickReturnHome:(id)sender;
- (IBAction)clickPageControl:(id)sender;

@end
