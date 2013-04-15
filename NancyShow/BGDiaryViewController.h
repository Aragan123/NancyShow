//
//  BGDiaryViewController.h
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/08.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPageSwitcherDelegate.h"
#import "BGDiarySaveViewController.h"
#import "BGTextEditorViewController.h"

@class SLComposeViewController;
@class AKSegmentedControl;
@class BGTextView;

#define kTextNotSelected 100
#define kMaxTextFontSize 42
#define kMinTextFontSize 8

@interface BGDiaryViewController : UIViewController<UITextViewDelegate, BGDiarySaveViewControllerDelegate, BGTextEditorViewControllerDelegate>{
    id<BGPageSwitcherDelegate> delegate;
    BOOL isEdited;
    UIImageView *tplImageView;
    IBOutlet UIView *tplMainView;
    IBOutlet UIView *bottomBarView;
    IBOutlet UIImageView *bottomBarImgView;
    
    NSArray *tplDetail;
    NSMutableArray *textViews;
    int lastSelectedTVIndex;
    
    SLComposeViewController *slComposerSheet;
    UIImage *savedImage;
    AKSegmentedControl *segmentedControl;
    
    BGTextEditorViewController *textEditor;
}

@property (nonatomic, assign) id<BGPageSwitcherDelegate> delegate;
@property (nonatomic) BOOL isEdited;
@property (nonatomic, retain) UIImage *savedImage;
@property (nonatomic, retain) BGTextEditorViewController *textEditor;

- (void) reloadImageView;

- (IBAction)clickCancelButton:(id)sender;
- (IBAction)clickOkButton:(id)sender;

@end
