//
//  BGViewController.m
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/03.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGViewController.h"
#import "BGGlobalData.h"
#import "SVProgressHUD.h"
#import "AFPropertyListRequestOperation.h"

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

- (IBAction)clickOnlineGallery:(id)sender{
    NSLog(@"click online gallery button");
    [SVProgressHUD showWithStatus:@"Connecting" maskType:SVProgressHUDMaskTypeGradient];
    
    // download online plist file
    NSURL *url = [NSURL URLWithString:kOnlineGalleryURI];
    NSURLRequest *requst = [NSURLRequest requestWithURL:url];
    NSLog(@"Network URL: %@", kOnlineGalleryURI);
    
    AFPropertyListRequestOperation *operation = [AFPropertyListRequestOperation
                                                 propertyListRequestOperationWithRequest:requst
                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id propertyList){
                                                     // stop HUD
                                                     [SVProgressHUD dismiss];
                                                     
                                                     // get plist and assign to global data, then redirect to gallery show page
                                                     NSDictionary *pList = (NSDictionary*)propertyList;
                                                     [[BGGlobalData sharedData] setOnlineGalleryBooks:[pList objectForKey:@"OLGalleryBooks"]];
                                                     if (nil != delegate) {
//                                                         [delegate switchViewTo:kPageOnlineGallery fromView:kPageMain]; // go to gallery show page
                                                     }
                                                 }
                                                 failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id propertyList){
                                                     NSLog(@"Network Error: %@", error);
                                                     // stop HUD with error
                                                     [SVProgressHUD showErrorWithStatus:@"Network Not Connected"];
                                                 }];
    // start http call
    [operation start];
}

@end
