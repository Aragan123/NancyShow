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

#ifndef kTextNotSelected
#define kTextNotSelected 100
#define kMaxTextFontSize 56
#define kMinTextFontSize 10
#endif

@interface BGDiaryViewController : UIViewController<UITextViewDelegate, BGDiarySaveViewControllerDelegate, BGTextEditorViewControllerDelegate>{
    id<BGPageSwitcherDelegate> delegate;
    // views
    UIView *tplMainView;
    UIView *bottomBarView;
    UIImageView *bottomBarImgView;
    UIImageView *tplImageView;
    SLComposeViewController *slComposerSheet;
    AKSegmentedControl *segmentedControl;
    BGTextEditorViewController *textEditor;
    // data
    BOOL isEdited;
    NSArray *tplDetail;
    NSMutableArray *textViews;
    int lastSelectedTVIndex;
    UIImage *savedImage;
}

@property (nonatomic, assign) id<BGPageSwitcherDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIView *tplMainView;
@property (nonatomic, retain) IBOutlet UIView *bottomBarView;
@property (nonatomic, retain) IBOutlet UIImageView *bottomBarImgView;
@property (nonatomic, retain) UIImageView *tplImageView;
@property (nonatomic, retain) SLComposeViewController *slComposerSheet;
@property (nonatomic, retain) AKSegmentedControl *segmentedControl;
@property (nonatomic, retain) BGTextEditorViewController *textEditor;

@property (nonatomic, assign) BOOL isEdited;
@property (nonatomic, retain) NSArray *tplDetail;
@property (nonatomic, retain) NSMutableArray *textViews;
@property (nonatomic, assign) int lastSelectedTVIndex;
@property (nonatomic, retain) UIImage *savedImage;


- (void) reloadImageView;

- (IBAction)clickCancelButton:(id)sender;
- (IBAction)clickOkButton:(id)sender;

@end
