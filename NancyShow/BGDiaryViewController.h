//
//  BGDiaryViewController.h
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/08.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPageSwitcherDelegate.h"
#import "BGDiaryModalViewController.h"
#import "BGTextEditorViewController.h"

#ifndef kTextNotSelected
#define kTextNotSelected 100
#define kMaxTextFontSize 56
#define kMinTextFontSize 10
#endif

typedef enum : NSInteger{
    BGDiaryTextAreaTypeNormal=0,
    BGDiaryTextAreaTypeDate,
} BGDiaryTextAreaType;


@class SLComposeViewController;
@class AKSegmentedControl;
@class BGTextView;

@interface BGDiaryViewController : UIViewController<UITextViewDelegate, BGDiaryModalViewControllerDelegate, BGTextEditorViewControllerDelegate>{
    id<BGPageSwitcherDelegate> delegate;
    // views
    UIScrollView *tplMainView;
    UIView *bottomBarView;
    UIImageView *bottomBarImgView;
    UIView *tplHolderView;
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
@property (nonatomic, retain) IBOutlet UIScrollView *tplMainView;
@property (nonatomic, retain) IBOutlet UIView *bottomBarView;
@property (nonatomic, retain) IBOutlet UIImageView *bottomBarImgView;
@property (nonatomic, retain) UIView *tplHolderView;
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
