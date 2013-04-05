//
//  BGGalleryViewController.m
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/04.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGGalleryViewController.h"
#import "BGGlobalData.h"
#import "AKSegmentedControl.h"

@interface BGGalleryViewController ()

@end

@implementation BGGalleryViewController
@synthesize delegate;
@synthesize bottomBarView, pageControl, bottomBarImgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        galleries = [[BGGlobalData sharedData] galleryBooks];
        galleryURI = [[BGGlobalData sharedData] galleryURI];
        currentGalleryIndex =0;
        currentGallery = [galleries objectAtIndex:currentGalleryIndex];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // set Page Control
    self.pageControl.numberOfPages = [[currentGallery objectForKey:@"GalleryImageNames"] count];
    self.pageControl.currentPage = 0;
    
    // add and set Segmented Control in bottomBar View
    segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(0,0, galleries.count*100+6, 44)];
    segmentedControl.center = CGPointMake(bottomBarImgView.center.x, bottomBarImgView.center.y+2);
    
    [segmentedControl addTarget:self action:@selector(segmentedViewController:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setSegmentedControlMode:AKSegmentedControlModeSticky];
    [segmentedControl setSelectedIndex:0];
    [self setupSegmentedControl];
    
    [bottomBarView insertSubview:segmentedControl aboveSubview:bottomBarImgView];

    // load image paging view
    self.pagingView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - bottomBarView.frame.size.height);
    self.pagingView.horizontal = YES;
    self.pagingView.currentPageIndex = 0;
//    [self currentPageDidChangeInPagingView:self.pagingView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload{
    
    [bottomBarView release];
    bottomBarView = nil;
    [pageControl release];
    pageControl = nil;
    [bottomBarImgView release];
    bottomBarImgView = nil;
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    
    [bottomBarView release];
    [pageControl release];
    [bottomBarImgView release];
    [super dealloc];
}

- (void) reloadDataWith: (int) galleryIndex {
    // reload data
    currentGallery = [galleries objectAtIndex:galleryIndex];
    
    
    // update page control
    self.pageControl.numberOfPages = [[currentGallery objectForKey:@"GalleryImageNames"] count];
    self.pageControl.currentPage = 0; // always go to first one
//    [self.pageControl reloadInputViews];
    
    // update paging view
    self.pagingView.currentPageIndex = 0;
    [self.pagingView reloadData];
}

- (IBAction)clickReturnHome:(id)sender {
    if (delegate !=nil) {
        [delegate switchViewTo:kPageMain fromView:kPageGallery];
    }
}

- (IBAction)clickPageControl:(id)sender {
    // page control is click to change value, need to move scroll view
    UIPageControl *pc = (UIPageControl*)sender;
    int pageIndex = pc.currentPage;
}

#pragma mark -
#pragma mark Segmented Control Methods
- (void) setupSegmentedControl{
    [segmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    
//    [segmentedControl setSeparatorImage:[UIImage imageNamed:@"sep_border_material.png.png"]];
    
    // normal images
    UIImage *buttonBackgroundImageLeft = [[UIImage imageNamed:@"btn_left_a.png"]
                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
    UIImage *buttonBackgroundImageCenter = [[UIImage imageNamed:@"btn_middle_a.png"]
                                                   resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
    UIImage *buttonBackgroundImageRight = [[UIImage imageNamed:@"btn_right_a.png"]
                                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 1.0, 0.0, 4.0)];
    // pressed images
    UIImage *buttonBackgroundImagePressedLeft = [[UIImage imageNamed:@"btn_left_b.png"]
                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
    UIImage *buttonBackgroundImagePressedCenter = [[UIImage imageNamed:@"btn_middle_b.png"]
                                                   resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
    UIImage *buttonBackgroundImagePressedRight = [[UIImage imageNamed:@"btn_right_b.png"]
                                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 1.0, 0.0, 4.0)];
    
    int totalGalleries = [galleries count];
    NSMutableArray *buttonArray = [NSMutableArray arrayWithCapacity:totalGalleries];
    for (int i=0; i<totalGalleries; i++) {
        UIButton *button = [[UIButton alloc] init];
//        [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 5.0)];
        
        NSString *buttonTitle = [NSString stringWithFormat:@"Gallery %i", i+1];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:124.0 green:202.0 blue:0.0 alpha:1.0] forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
        
        if (i==0) {
            // first one, must use left image
            [button setBackgroundImage:buttonBackgroundImageLeft forState:UIControlStateNormal];
            [button setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
            [button setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
            [button setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
        }else if (i == totalGalleries-1){
            // last one, must use right image
            [button setBackgroundImage:buttonBackgroundImageRight forState:UIControlStateNormal];
            [button setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
            [button setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
            [button setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateHighlighted|UIControlStateSelected)];
        }else{
            // rest use middle image
            [button setBackgroundImage:buttonBackgroundImageCenter forState:UIControlStateNormal];
            [button setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateHighlighted];
            [button setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateSelected];
            [button setBackgroundImage:buttonBackgroundImagePressedCenter forState:(UIControlStateHighlighted|UIControlStateSelected)];
        }



        [buttonArray addObject:button];
    }
    
    [segmentedControl setButtonsArray:buttonArray];
}

- (void)segmentedViewController:(id)sender
{
    AKSegmentedControl *segControl = (AKSegmentedControl *)sender;
    
    NSLog(@"SegmentedControl #1 : Selected Index %@", [segControl selectedIndexes]);

}

#pragma mark -
#pragma mark ATPagingViewDelegate methods

- (NSInteger)numberOfPagesInPagingView:(ATPagingView *)pagingView {
    return [[currentGallery objectForKey:@"GalleryImageNames"] count];
}

- (UIView *)viewForPageInPagingView:(ATPagingView *)pagingView atIndex:(NSInteger)index {
    UIView *view = [pagingView dequeueReusablePage];
    if (view == nil) {
//        view = [[[DemoPageView alloc] init] autorelease];
    }
    return view;
}

- (void)currentPageDidChangeInPagingView:(ATPagingView *)pagingView {
    self.pageControl.currentPage = pagingView.currentPageIndex;
}

@end
