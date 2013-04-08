//
//  BGDiaryViewController.h
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/08.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPageSwitcherDelegate.h"

@interface BGDiaryViewController : UIViewController{
    id<BGPageSwitcherDelegate> delegate;
    UIImageView *tplImageView;
    IBOutlet UIView *tplMainView;
}

@property (nonatomic,retain) id<BGPageSwitcherDelegate> delegate;

- (void) reloadImageView;

- (IBAction)clickCancelButton:(id)sender;
- (IBAction)clickOkButton:(id)sender;

@end
