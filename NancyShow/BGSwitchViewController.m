//
//  BGSwitchViewController.m
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/04.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGSwitchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BGGlobalData.h"
#import "BGViewController.h"
#import "BGAboutViewController.h"
#import "BGGalleryViewController.h"
#import "BGTplHomeViewController.h"
#import "BGDiaryViewController.h"


@interface BGSwitchViewController ()

@end

@implementation BGSwitchViewController
@synthesize homePageViewController, aboutPageViewController, galleryPageViewController, tplHomeViewController, diaryViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    BGViewController *homeView = [[BGViewController alloc] initWithNibName:@"BGViewController" bundle:nil];
    self.homePageViewController = homeView;
    self.homePageViewController.delegate = self;
    [homeView release];
    
    [self.view insertSubview:homePageViewController.view atIndex:0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow landscape orientation only.
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    if (self.homePageViewController.view.subviews==nil) {
        self.homePageViewController=nil;
    }
    if (self.aboutPageViewController.view.subviews==nil) {
        self.aboutPageViewController=nil;
    }
}

- (void) viewDidUnload{
    homePageViewController=nil;
    aboutPageViewController=nil;
    galleryPageViewController=nil;
    tplHomeViewController=nil;
    diaryViewController=nil;
}

- (void) dealloc{
    [homePageViewController release];
    [aboutPageViewController release];
    [galleryPageViewController release];
    [tplHomeViewController release];
    [diaryViewController release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark PageSwitcher delegate Functons
-(void) switchViewTo: (int)toPage fromView:(int)fromPage  {
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.55f];
    [animation setType:kCATransitionReveal];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
	// set different transition types
	if (toPage > fromPage) {
        [animation setSubtype:kCATransitionFromTop];
	}else {
        [animation setSubtype:kCATransitionFromBottom];
	}
    
    if (toPage == kPageMain) {
        NSLog(@"toPage = MainPage");
        
        if (self.homePageViewController == nil) {
            BGViewController *controller = [[BGViewController alloc] initWithNibName:@"BGViewController" bundle:nil];
            self.homePageViewController = controller;
            [controller release];
        }
        self.homePageViewController.delegate = self;
    }
    
    else if (toPage == kPageAbout) {
        NSLog(@"toPage = AboutPage");
        
        if (self.aboutPageViewController == nil) {
            BGAboutViewController *controller = [[BGAboutViewController alloc] initWithNibName:@"BGAboutViewController" bundle:nil];
            self.aboutPageViewController = controller;
            [controller release];
        }
        self.aboutPageViewController.delegate = self;
    }
    
    else if (toPage == kPageGallery) {
        NSLog(@"toPage = GalleryPage");
        if (self.galleryPageViewController.view.superview == nil) {
            BGGalleryViewController *controller = [[BGGalleryViewController alloc] initWithNibName:@"BGGalleryViewController" bundle:nil];
            self.galleryPageViewController = controller;
            [controller release];
        }
        self.galleryPageViewController.delegate = self;
    }
    
    else if (toPage == kPageOnlineGallery) {
        NSLog(@"toPage = OnlineGalleryPage");
        if (self.galleryPageViewController.view.superview == nil) {
            BGGalleryViewController *controller = [[BGGalleryViewController alloc] initWithNibName:@"BGGalleryViewController"
                                                                                            bundle:nil
                                                                                         galleries:[[BGGlobalData sharedData] onlineGalleryBooks]
                                                                                   isOnlineGallery:YES];
            self.galleryPageViewController = controller;
            [controller release];
        }
        self.galleryPageViewController.delegate = self;
    }
    
    else if (toPage == kPageDiaryHome) {
        NSLog(@"toPage = DiaryHomePage");
        if (self.tplHomeViewController.view.subviews == nil) {
            BGTplHomeViewController *controller = [[BGTplHomeViewController alloc] initWithNibName:@"BGTplHomeViewController" bundle:nil];
                                                                                        
            self.tplHomeViewController = controller;
            [controller release];
        }
        self.tplHomeViewController.delegate = self;
    }
    
    else if (toPage == kPageDiary) {
        NSLog(@"toPage = DiaryPage");
        if (self.diaryViewController.view.superview == nil) {
            BGDiaryViewController *controller = [[BGDiaryViewController alloc] initWithNibName:@"BGDiaryViewController" bundle:nil];
            self.diaryViewController = controller;
            [controller release];
        }
        self.diaryViewController.delegate = self;
    }
    
    // get from and to view controller
	UIViewController *fromViewController = [self getSwitchViewController:fromPage];
	UIViewController *toViewController = [self getSwitchViewController:toPage];
    
	// show views
	[fromViewController	viewWillDisappear:YES];
	[toViewController viewWillAppear:YES];
	
	[fromViewController.view removeFromSuperview];
	[self.view insertSubview:toViewController.view atIndex:0];
    
	[fromViewController viewDidDisappear:YES];
	[toViewController viewDidAppear:YES];
    
	// commit/start animation
    [self.view.layer addAnimation:animation forKey:@"Switch View Animation"];
    
}

#pragma mark -
#pragma mark Methods
-(UIViewController *) getSwitchViewController: (int) pageNum{
	switch (pageNum) {
		case kPageMain:
			return self.homePageViewController;
			break;
			
		case kPageDiaryHome:
            return self.tplHomeViewController;
			break;
            
		case kPageGallery:
        case kPageOnlineGallery:
            return self.galleryPageViewController;
			break;
            
        case kPageAbout:
            return self.aboutPageViewController;
            break;
            
        case kPageDiary:
            return self.diaryViewController;
            break;
	}
	return nil;
}

@end
