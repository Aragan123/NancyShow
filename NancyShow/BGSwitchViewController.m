//
//  BGSwitchViewController.m
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/04.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGSwitchViewController.h"
#import "BGViewController.h"
#import "BGAboutViewController.h"
#import "BGGalleryViewController.h"

@interface BGSwitchViewController ()

@end

@implementation BGSwitchViewController
@synthesize homePageViewController, aboutPageViewController, galleryPageViewController;

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
    self.homePageViewController=nil;
    self.aboutPageViewController=nil;
    self.galleryPageViewController=nil;
}

- (void) dealloc{
    [homePageViewController release];
    [aboutPageViewController release];
    [galleryPageViewController release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark PageSwitcher delegate Functons
-(void) switchViewTo: (int)toPage fromView:(int)fromPage  {
	[UIView beginAnimations:@"PageSwitch" context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	// set different transition types
	if (toPage > fromPage) {
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
	}else {
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
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
    
	// commit animation
	[UIView commitAnimations];
    
}

#pragma mark -
#pragma mark Methods
-(UIViewController *) getSwitchViewController: (int) pageNum{
	switch (pageNum) {
		case kPageMain:
			return self.homePageViewController;
			break;
			
		case kPageDiaryHome:
            //			return self.galleryHomePageViewController;
			break;
            
		case kPageGallery:
            return self.galleryPageViewController;
			break;
            
        case kPageAbout:
            return self.aboutPageViewController;
            break;
            
        case kPageDiary:
            // return self.uiPageViewController;
            break;
        case kPageOnlineGallery:
            // return self.olGalleryPageViewController;
            break;
	}
	return nil;
}

@end
