//
//  BGAboutViewController.m
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/04.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGAboutViewController.h"

@interface BGAboutViewController ()

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
    UIImageView *backgroundImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-imgSize.height)] autorelease];
    backgroundImgView.image = [UIImage imageNamed:@"bg_aboutMe.png"];
    backgroundImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundImgView];
    
    /*
     * construct bottom bar view
     */
    UIView *bottomBarView = [[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - imgSize.height, self.view.frame.size.width, imgSize.height)] autorelease];
    // add bottom background image
    UIImageView *bottomImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgSize.width, imgSize.height)] autorelease];
    bottomImageView.image = bottomBarImage;
    [bottomBarView addSubview:bottomImageView];
    
    // add go home button
    UIImage *btnHomeImage = [UIImage imageNamed: @"btn_home_a.png"];
    imgSize = btnHomeImage.size;
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setFrame:CGRectMake(self.view.frame.size.width - 100 + 25, self.view.frame.size.height - 57 + 10, 50, 50)];
    [button setFrame:CGRectMake((bottomBarView.frame.size.width - 100 + imgSize.width*0.5), (bottomBarView.frame.size.height-imgSize.height+10)*0.5, imgSize.width, imgSize.height)];
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
#pragma mark Priavet Methods
-(void) clickGoHomeButton: (id)sender{
    if (delegate != nil) {
        [delegate switchViewTo:kPageMain fromView:kPageAbout];
    }
}

@end
