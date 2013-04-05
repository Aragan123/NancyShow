//
//  BGViewController.h
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/03.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPageSwitcherDelegate.h"

@interface BGViewController : UIViewController{
    id<BGPageSwitcherDelegate> delegate;
    
}

@property (nonatomic, retain) id<BGPageSwitcherDelegate> delegate;
//@property (nonatomic, retain) IBOutlet UIButton *btnAbout;

- (IBAction)clickMenuButton:(id)sender;
@end
