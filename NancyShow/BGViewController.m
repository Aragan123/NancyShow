//
//  BGViewController.m
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/03.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGViewController.h"

@interface BGViewController ()

@end

@implementation BGViewController
@synthesize delegate;
//@synthesize btnAbout;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload{
//    self.btnAbout=nil;
}

- (void) dealloc{
    delegate=nil;
//    [btnAbout release];
    
    [super dealloc];
}

- (IBAction)clickMenuButton:(id)sender {
    UIButton *button = (UIButton*)sender;
    int tag = button.tag;
    
    NSLog(@"click button tag = %i", tag);
    
    if (delegate != nil) {
        [delegate switchViewTo:tag fromView:kPageMain];
    }
    
}
@end
