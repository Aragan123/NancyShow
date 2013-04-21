//
//  BGDiaryModalViewController
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/21.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BGDiaryModalViewControllerDelegate <NSObject>

@required
-(void) clickSaveViewShareButton: (int)shareType;
-(void) clickSaveViewCloseButton;

@end

@interface BGDiaryModalViewController : UIViewController{
    id<BGDiaryModalViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id<BGDiaryModalViewControllerDelegate> delegate;

- (IBAction)clickCloseButton:(id)sender;
- (IBAction)clickShareButton:(id)sender;

@end
