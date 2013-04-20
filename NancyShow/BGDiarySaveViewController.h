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
    UIButton *sharing_sinaweibo;
    UIButton *sharing_facebook;
    UIButton *sharing_twitter;
    UILabel *sharing_desc;
}

@property (nonatomic, assign) id<BGDiarySaveViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIButton *sharing_sinaweibo;
@property (retain, nonatomic) IBOutlet UIButton *sharing_facebook;
@property (retain, nonatomic) IBOutlet UIButton *sharing_twitter;
@property (retain, nonatomic) IBOutlet UILabel *sharing_desc;

- (IBAction)clickCloseButton:(id)sender;
- (IBAction)clickShareButton:(id)sender;

@end
