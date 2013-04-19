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

@class AKSegmentedControl;

@interface BGTplHomeViewController : UIViewController <BGTableViewControllerDelegate>{
    id<BGPageSwitcherDelegate> delegate;
    // view
    UIView *bottomBarView;
    UIImageView *bottomImageView;
    AKSegmentedControl *segControl;
    BGTableViewController *tableViewController;
    // data
    BOOL isOnlineTpl;
    NSDictionary *templateData;
    NSMutableArray *templateObjects;
    NSMutableArray *templateThumbnails;
}

@property (nonatomic, assign) id<BGPageSwitcherDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIView *bottomBarView;
@property (nonatomic, retain) IBOutlet UIImageView *bottomImageView;
@property (nonatomic, retain) AKSegmentedControl *segControl;
@property (nonatomic, retain) BGTableViewController *tableViewController;

@property (nonatomic, assign) BOOL isOnlineTpl;
@property (nonatomic, retain) NSDictionary *templateData;
@property (nonatomic, retain) NSMutableArray *templateObjects;
@property (nonatomic, retain) NSMutableArray *templateThumbnails;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil templateData:(NSDictionary*)tplData isOnlineTpl:(BOOL)online;
- (IBAction)clickReturnHome:(id)sender;

@end
