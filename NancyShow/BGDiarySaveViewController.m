//
//  BGDiarySaveViewController.m
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/13.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGDiarySaveViewController.h"

@interface BGDiarySaveViewController ()

@end

@implementation BGDiarySaveViewController
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
    
    self.view.frame = CGRectMake(0, 0, 400, 260);
    // add background image
    UIImage *backgroundPattern = [UIImage imageNamed:@"beauty_background.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];
    
    // add saved text, icon and button
    
    
    // add share buttons
    
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
@end
