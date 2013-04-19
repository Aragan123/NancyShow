//
//  BGTableViewController.h
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/07.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "ATArrayView.h"

#ifndef kRemoveViewTag
#define kRemoveViewTag 118
#endif

@protocol BGTableViewControllerDelegate;

@interface BGTableViewController : ATArrayViewController{
    id<BGTableViewControllerDelegate> delegate;
    
    NSArray *dataSrouce;
    BOOL isOnlineData;
}

@property (nonatomic, assign) id<BGTableViewControllerDelegate> delegate;
@property (nonatomic, retain) NSArray *dataSource;
@property (nonatomic, assign) BOOL isOnlineData;

- (void) reloadDataSource: (NSArray*) ds isOnlineData: (BOOL)online;

@end

@protocol BGTableViewControllerDelegate <NSObject>
@required
- (void) itemCellSelected: (int) atIndex;

@end