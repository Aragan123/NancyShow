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

@class AKSegmentedControl;

@interface BGGalleryViewController : ATPagingViewController{
    id<BGPageSwitcherDelegate> delegate;
    IBOutlet UIView *bottomBarView;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIImageView *bottomBarImgView;
    
    AKSegmentedControl *segmentedControl;
    NSArray *galleries;
    NSString *galleryURI;
    int currentGalleryIndex;
    NSDictionary *currentGallery;
    
}

@property(nonatomic, retain) id<BGPageSwitcherDelegate> delegate;
@property(nonatomic, retain) IBOutlet UIView *bottomBarView;
@property(nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property(nonatomic, retain) IBOutlet UIImageView *bottomBarImgView;

- (IBAction)clickReturnHome:(id)sender;
- (IBAction)clickPageControl:(id)sender;

@end
