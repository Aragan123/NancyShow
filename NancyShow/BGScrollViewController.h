//
//  BGScrollViewController.h
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/06.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "ATPagingView.h"

#ifndef kRemoveViewTag
#define kRemoveViewTag 118
#endif

@protocol BGScrollViewControllerDelegate;

@interface BGScrollViewController : ATPagingViewController{
    id<BGScrollViewControllerDelegate> delegate;
    NSArray *dataSource;
    BOOL isOnlineData;
}

@property (nonatomic, assign) id<BGScrollViewControllerDelegate> delegate;
@property (nonatomic, retain) NSArray *dataSource;
@property (nonatomic, assign) BOOL isOnlineData;

- (void) updateScrollerPagetoIndex: (int) index;
- (void) reloadDataSource: (NSArray*) ds;

@end


@protocol BGScrollViewControllerDelegate <NSObject>
@required
- (void) scrollerPageViewChanged: (int) newPageIndex;

@end
