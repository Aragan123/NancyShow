//
//  BGDiaryViewController.m
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/08.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGDiaryViewController.h"
#import "BGGlobalData.h"
#import "AHAlertView.h"

@interface BGDiaryViewController ()

@end

@implementation BGDiaryViewController
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
    UIImage *backgroundPattern = [UIImage imageNamed:@"beauty_background.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];
    
    // set alert view style
    [AHAlertView applyCustomAlertAppearance];
    
    [self reloadImageView];
    
}

- (void) reloadImageView{
    UIImage *tplImg = [[BGGlobalData sharedData] diaryTplImage];
    tplImageView = [[UIImageView alloc] initWithFrame:CGRectMake((tplMainView.frame.size.width-tplImg.size.width)*0.5,
                                                                 (tplMainView.frame.size.height-tplImg.size.height)*0.5,
                                                                 tplImg.size.width, tplImg.size.height)];
    [tplImageView setImage:tplImg];
    [tplMainView addSubview:tplImageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload{
    tplImageView=nil;
    
    [tplMainView release];
    tplMainView = nil;
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    [tplImageView release];
    
    [tplMainView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Action Methods
- (IBAction)clickCancelButton:(id)sender {
    // when cancel click, show a alert before return back to template home page
    
    if (nil == delegate) {
        return;
    }
    
    AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"Discard Changes" message:@"Are you sure to discard your changes?"];
//    [alert setDismissalStyle:AHAlertViewDismissalStyleZoomDown];
    [alert setCancelButtonTitle:@"Disard" block:^{
        [delegate switchViewTo:kPageDiaryHome fromView:kPageDiary]; // go back
	}];
	[alert addButtonWithTitle:@"No" block:nil];     //do nothing, just dismiss alert view
	[alert show];
    [alert release];
    
    }

- (IBAction)clickOkButton:(id)sender {
    // when ok clicked, show share to Weibo
    if (nil == delegate) {
        return;
    }
    
    
    // finally return
    [delegate switchViewTo:kPageDiaryHome fromView:kPageDiary];
}
@end
