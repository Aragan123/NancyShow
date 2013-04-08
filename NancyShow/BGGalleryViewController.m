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
#import "BGScrollViewController.h"

@interface BGGalleryViewController ()

@end

@implementation BGGalleryViewController
@synthesize delegate, isOnlineGallery;
@synthesize bottomBarView, pageControl, bottomBarImgView;
@synthesize scrollViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   // default is offline/local galleries
    return [self initWithNibName:nibNameOrNil
                          bundle:nibBundleOrNil
                       galleries:[[BGGlobalData sharedData] galleryBooks]
                 isOnlineGallery:NO
            ];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil galleries:(NSArray*)gBooks isOnlineGallery:(BOOL)online
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isOnlineGallery = online;
        galleries = gBooks;
    
        currentGalleryIndex =0;
        currentGalleryObject = [galleries objectAtIndex:currentGalleryIndex];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *backgroundPattern = [UIImage imageNamed:@"beauty_background.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];
    
    // set Page Control
    self.pageControl.numberOfPages = [self numberOfImagesInGallery];
    self.pageControl.currentPage = 0;
    
    // add and set Segmented Control in bottomBar View
    segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(0,0, galleries.count*100+6, 44)];
    segmentedControl.center = CGPointMake(bottomBarImgView.center.x, bottomBarImgView.center.y+3);
    
    [segmentedControl addTarget:self action:@selector(segmentedViewController:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setSegmentedControlMode:AKSegmentedControlModeSticky];
    [segmentedControl setSelectedIndex:0];
    [self setupSegmentedControl];
    
    [bottomBarView insertSubview:segmentedControl aboveSubview:bottomBarImgView];

    // load image scroll paging view
    self.scrollViewController = [[BGScrollViewController alloc] init];
    self.scrollViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - bottomBarView.frame.size.height);
    self.scrollViewController.delegate = self;
    self.scrollViewController.isOnlineData = isOnlineGallery;
    self.scrollViewController.dataSource = [self getGalleryImageURIs];
    [self.view addSubview:self.scrollViewController.view];
    
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
    
    segmentedControl=nil;
    galleries=nil;
    currentGalleryObject=nil;
    
    self.scrollViewController=nil;
    
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    
    [bottomBarView release];
    [pageControl release];
    [bottomBarImgView release];
    
    [segmentedControl release];
    [galleries release];
    [currentGalleryObject release];
    
    [scrollViewController release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Controls
- (void) reloadDataWith: (int) galleryIndex {
    // reload data
    currentGalleryIndex = galleryIndex;
    currentGalleryObject = [galleries objectAtIndex:galleryIndex];
    
    // update page control
    self.pageControl.numberOfPages = [self numberOfImagesInGallery];
    self.pageControl.currentPage = 0; // always go to first one
//    [self.pageControl reloadInputViews];
    
    // update scroll paging view
    self.scrollViewController.dataSource = [self getGalleryImageURIs];
    [self.scrollViewController reloadDataSource:[self getGalleryImageURIs]];
}

- (IBAction)clickReturnHome:(id)sender {
    if (nil != delegate) {
        [delegate switchViewTo:kPageMain fromView:kPageGallery];
    }
}

- (IBAction)clickPageControl:(id)sender {
    // page control is click to change value, need to move scroll view
    UIPageControl *pc = (UIPageControl*)sender;
    int pageIndex = pc.currentPage;
    [self.scrollViewController updateScrollerPagetoIndex:pageIndex]; // update scroller
}

#pragma mark - 
#pragma mark Private Methods
- (NSArray*) getGalleryImageURIs {
    NSString *uri = [currentGalleryObject objectForKey:@"GalleryURL"];
    NSArray *imgNames = [currentGalleryObject objectForKey:@"GalleryImageNames"];
    NSMutableArray *imgURIs = [NSMutableArray arrayWithCapacity:[imgNames count]];
    
    for (NSString *imgName in imgNames){
        if (!isOnlineGallery) {
            // local gallery
            NSString *imgFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@/%@", uri, imgName];
            [imgURIs addObject:imgFilePath];
        }else{
            // online gallery
            NSString *imgFilePath = [NSString stringWithFormat:@"%@/%@", uri, imgName];
            [imgURIs addObject:imgFilePath];
            
        }
    }

    return  imgURIs;
}

- (int) numberOfImagesInGallery {
    return [[currentGalleryObject objectForKey:@"GalleryImageNames"] count];
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
        
        // get buttontitle from plist data
        NSDictionary *galleryBook = [galleries objectAtIndex:i];
        NSString *buttonTitle = [galleryBook objectForKey:@"GalleryDesc"];
        
//        NSString *buttonTitle = [NSString stringWithFormat:@"Gallery %i", i+1];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:124.0 green:202.0 blue:0.0 alpha:1.0] forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont fontWithName:@"Noteworthy-Bold" size:12.0]];
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
    int selectedSegIndex = [[segControl selectedIndexes] firstIndex];
    
//    NSLog(@"SegmentedControl: Selected Index %@", [segControl selectedIndexes]);
    NSLog(@"SegmentedControl: selected index %i", selectedSegIndex);
    
    [self reloadDataWith:selectedSegIndex]; // reload gallery 
}

#pragma mark --
#pragma mark BGScrollShowViewController delegate methods
- (void) scrollerPageViewChanged:(int)newPageIndex{
    // update page controll index
    self.pageControl.currentPage = newPageIndex;
}

@end
