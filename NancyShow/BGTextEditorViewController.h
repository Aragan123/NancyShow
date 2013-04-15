//
//  BGTextEditorViewController.h
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/11.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AKSegmentedControl;

@protocol BGTextEditorViewControllerDelegate;

@interface BGTextEditorViewController : UIViewController{
    id<BGTextEditorViewControllerDelegate> delegate;
    
    AKSegmentedControl *fontSegControl;
    AKSegmentedControl *alignmentSegControl;
    AKSegmentedControl *fontSizeSegControl;
    AKSegmentedControl *fontColorSegControl;
    
    NSArray *fontNames;
    NSArray *fontArray;
    NSArray *fontColor;
}

@property (nonatomic, assign) id<BGTextEditorViewControllerDelegate> delegate;
@property (nonatomic, retain) AKSegmentedControl *fontSegControl;
@property (nonatomic, retain) AKSegmentedControl *alignmentSegControl;
@property (nonatomic, retain) AKSegmentedControl *fontSizeSegControl;
@property (nonatomic, retain) AKSegmentedControl *fontColorSegControl;

- (void) updateFontSegControl: (int) index;
- (void) updateAlignmentSegContol: (int) index;
- (void) updateFontColorSegControl: (int) index;

@end



@protocol BGTextEditorViewControllerDelegate <NSObject>

@optional
- (void) updateFontName: (UIFont*) newFont withFontIndex: (int) index;
- (void) updateTextAlignment: (int) index;
- (void) updateFontSize: (int) index;
- (void) updateFontColor: (UIColor*) newColor withColorIndex: (int) index;

@end