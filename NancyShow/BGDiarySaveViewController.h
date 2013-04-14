//
//  BGDiarySaveViewController.h
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/13.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BGDiarySaveViewControllerDelegate <NSObject>

@required
-(void) clickSaveViewShareButton: (int)shareType;
-(void) clickSaveViewCloseButton;

@end

@interface BGDiarySaveViewController : UIViewController{
    id<BGDiarySaveViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id<BGDiarySaveViewControllerDelegate> delegate;

- (IBAction)clickCloseButton:(id)sender;
- (IBAction)clickShareButton:(id)sender;

@end
