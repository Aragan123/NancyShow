//
//  BGTplHomeViewController.h
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/07.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPageSwitcherDelegate.h"
#import "BGTableViewController.h"

@interface BGTplHomeViewController : UIViewController <BGTableViewControllerDelegate>{
    id<BGPageSwitcherDelegate> delegate;
    BOOL isOnlineTpl;
    NSDictionary *templateData;
    NSArray *templateObjects;
    NSArray *templateThumbnails;
    
    BGTableViewController *tableViewController;
}

@property (nonatomic, retain) id<BGPageSwitcherDelegate> delegate;
@property (nonatomic, assign) BOOL isOnlineTpl;
@property (nonatomic, retain) NSDictionary *templateData;
@property (nonatomic, retain) BGTableViewController *tableViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil templateData:(NSDictionary*)tplData isOnlineTpl:(BOOL)online;

- (IBAction)clickReturnHome:(id)sender;

@end
