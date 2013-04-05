//
//  BGAboutViewController.h
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/04.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPageSwitcherDelegate.h"

@interface BGAboutViewController : UIViewController{
    id<BGPageSwitcherDelegate> delegate;
}

@property (nonatomic,retain) id<BGPageSwitcherDelegate> delegate;

@end
