//
//  BGDiaryModalViewController
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/21.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGDiaryModalViewController.h"
#import <Social/Social.h>

@interface BGDiaryModalViewController ()

@end

@implementation BGDiaryModalViewController
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    self.view.frame = CGRectMake(0, 0, 400, 220);
    
    // add background image
    UIImage *backgroundPattern = [UIImage imageNamed:@"beauty_background.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];
    //    self.view.backgroundColor = [UIColor blackColor];
    
    // add text label strings
    UILabel *lbl_title = [[[UILabel alloc] initWithFrame:CGRectMake(20, 20, 360, 40)] autorelease];
    lbl_title.backgroundColor = [UIColor clearColor];
    lbl_title.textColor = [UIColor whiteColor];
    lbl_title.text = NSLocalizedString(@"DiarySaveView Title", nil);
    lbl_title.textAlignment = NSTextAlignmentCenter;
    lbl_title.font = [UIFont fontWithName:@"Noteworthy" size:22];
    [self.view addSubview:lbl_title];
    
    UILabel *lbl_shareTo = [[[UILabel alloc] initWithFrame:CGRectMake(20, 116, 360, 40)] autorelease];
    lbl_shareTo.backgroundColor = [UIColor clearColor];
    lbl_shareTo.textColor = [UIColor whiteColor];
    lbl_shareTo.text = NSLocalizedString(@"DiarySaveView ShareTo", nil);
    lbl_shareTo.textAlignment = NSTextAlignmentLeft;
    lbl_shareTo.font = [UIFont fontWithName:@"Noteworthy" size:16];
    [self.view addSubview:lbl_shareTo];
    
    BOOL isSocialClassAvailable = ((NSClassFromString(@"SLComposeViewController") == nil) ? NO : YES);
    if (!isSocialClassAvailable) {
        NSLog(@"social share is not available");
        UILabel *lbl_noShare = [[[UILabel alloc] initWithFrame:CGRectMake(20, 192, 360, 22)] autorelease];
        lbl_noShare.backgroundColor = [UIColor clearColor];
        lbl_noShare.textColor = [UIColor whiteColor];
        lbl_noShare.text = NSLocalizedString(@"DiarySaveView NoShare", nil);
        lbl_noShare.textAlignment = NSTextAlignmentLeft;
        lbl_noShare.font = [UIFont fontWithName:@"Noteworthy" size:14];
        [self.view addSubview:lbl_noShare];
    }
    
    // add ok button
    UIButton *btn_ok = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_ok setFrame:CGRectMake(169, 67, 62, 32)];
    [btn_ok setBackgroundImage:[UIImage imageNamed: @"btn_forgetpassword_a.png"] forState:UIControlStateNormal];
    [btn_ok addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [btn_ok setTitle:NSLocalizedString(@"OK Button", nil) forState:UIControlStateNormal];
    [btn_ok setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_ok.titleLabel.font = [UIFont fontWithName:@"Noteworthy-Bold" size:16];
    [self.view addSubview:btn_ok];
    
    // add sharing buttons
    UIButton *btn_sinaweibo = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_sinaweibo setFrame:CGRectMake(20, 150, 40, 40)];
    [btn_sinaweibo setImage:[UIImage imageNamed: @"logo_share_sinaweibo.png"] forState:UIControlStateNormal];
    [btn_sinaweibo addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_sinaweibo];
    
    UIButton *btn_twitter = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_twitter setFrame:CGRectMake(80, 150, 40, 40)];
    [btn_twitter setImage:[UIImage imageNamed: @"logo_share_twitter.png"] forState:UIControlStateNormal];
    [btn_twitter addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_twitter];
    
    UIButton *btn_facebook = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_facebook setFrame:CGRectMake(140, 150, 40, 40)];
    [btn_facebook setImage:[UIImage imageNamed: @"logo_share_facebook.png"] forState:UIControlStateNormal];
    [btn_facebook addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_facebook];
    
    // set share buttons
    if ( isSocialClassAvailable) {
        btn_sinaweibo.enabled = YES;
        btn_sinaweibo.alpha = 1.0f;
        btn_twitter.enabled = YES;
        btn_twitter.alpha = 1.0f;
        btn_facebook.enabled = YES;
        btn_facebook.alpha = 1.0f;
    }else{
        btn_sinaweibo.enabled = NO;
        btn_sinaweibo.alpha = 0.5f;
        btn_twitter.enabled = NO;
        btn_twitter.alpha = 0.5f;
        btn_facebook.enabled = NO;
        btn_facebook.alpha = 0.5f;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow landscape orientation only.
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload{
    
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    
    [super dealloc];
}

- (IBAction)clickCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^(void){
        if (nil != delegate) {
            [delegate clickSaveViewCloseButton];
        }
    }];
}

- (IBAction)clickShareButton:(id)sender {
    int shareType = [(UIButton*)sender tag];
    
    if (nil != delegate) {
        [delegate clickSaveViewShareButton:shareType]; // call delegate method
    }
    
}

-(BOOL)socialShareAvailable {
    if ( NSClassFromString(@"SLComposeViewController") != nil ) {
        BOOL facebookAvailable = [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook];
        BOOL twitterAvailable = [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
        BOOL weiboAvailable = [SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo];
        
        return ( facebookAvailable || twitterAvailable || weiboAvailable );
    }
    else {
        return NO;
    }
}
@end
