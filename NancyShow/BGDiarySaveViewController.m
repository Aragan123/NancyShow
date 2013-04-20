//
//  BGDiarySaveViewController.m
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/13.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGDiarySaveViewController.h"
#import <Social/Social.h>

@interface BGDiarySaveViewController ()

@end

@implementation BGDiarySaveViewController
@synthesize delegate, sharing_facebook, sharing_sinaweibo, sharing_twitter, sharing_desc;

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
    
    self.view.frame = CGRectMake(0, 0, 400, 260);
    // add background image
    UIImage *backgroundPattern = [UIImage imageNamed:@"beauty_background.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];

    // set text label string
    if (![self socialShareAvailable]) {
        self.sharing_desc.alpha = 1.0f;
    }else{
        self.sharing_desc.alpha = 0.0f;
    }
    
    // set share buttons
    BOOL isSocialClassAvailable = (NSClassFromString(@"SLComposeViewController") != nil) ? YES : NO;
    if ( isSocialClassAvailable && [SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        sharing_sinaweibo.enabled = YES;
        sharing_sinaweibo.alpha = 0.1f;
    }else{
        sharing_sinaweibo.enabled = NO;
        sharing_sinaweibo.alpha = 0.5f;
    }
    
    if (isSocialClassAvailable && [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        sharing_facebook.enabled = YES;
        sharing_facebook.alpha = 1.0f;
    }else{
        sharing_facebook.enabled = NO;
        sharing_facebook.alpha = 0.5f;
    }
    
    if (isSocialClassAvailable && [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        sharing_twitter.enabled = YES;
        sharing_twitter.alpha = 1.0f;
    }else{
        sharing_twitter.enabled = NO;
        sharing_twitter.alpha = 0.5f;
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
    
    [sharing_sinaweibo release];
    [self setSharing_sinaweibo:nil];
    [sharing_facebook release];
    [self setSharing_facebook:nil];
    [sharing_twitter release];
    [self setSharing_twitter:nil];
    [sharing_desc release];
    sharing_desc=nil;
    
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    
    [sharing_sinaweibo release];
    [sharing_facebook release];
    [sharing_twitter release];
    [sharing_desc release];
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
