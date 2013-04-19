//
//  BGAboutViewController.m
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/04.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGAboutViewController.h"

@interface BGAboutViewController (PrivateMethods)
-(void) clickGoHomeButton: (id)sender;

@end

@implementation BGAboutViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIImage *backgroundPattern = [UIImage imageNamed:@"beauty_background.png"]; // background color pattern
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];
    
    UIImage *bottomBarImage = [UIImage imageNamed:@"beauty_bottomBar.png"];
    CGSize imgSize = bottomBarImage.size;
    
    /* construct background view
     */
    UIImageView *backgroundImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-imgSize.height)];
    backgroundImgView.image = [UIImage imageNamed:@"bg_aboutMe.png"];
    backgroundImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundImgView];
    [backgroundImgView release];
    
    /*
     * construct bottom bar view
     */
    UIView *bottomBarView = [[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - imgSize.height, self.view.frame.size.width, imgSize.height)] autorelease];
    // add bottom background image
    UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    bottomImageView.image = bottomBarImage;
    [bottomBarView addSubview:bottomImageView];
    [bottomImageView release];
    
    // add go home button
    UIImage *btnHomeImage = [UIImage imageNamed: @"btn_home_a.png"];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(954, 8, btnHomeImage.size.width, btnHomeImage.size.height)];
    [button setBackgroundImage:btnHomeImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickGoHomeButton:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBarView addSubview:button];
    
    [self.view addSubview:bottomBarView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload{
    
    [super viewDidUnload];
}

- (void) dealloc{
    delegate = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Actions & Priavet Methods
-(void) clickGoHomeButton: (id)sender{
    if (delegate != nil) {
        [delegate switchViewTo:kPageMain fromView:kPageAbout];
    }
}

@end
