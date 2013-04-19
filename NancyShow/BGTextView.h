//
//  BGTextView.h
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/15.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGTextView : UITextView{
    int fontIndex;
    int fontColorIndex;
    int fontSize;
}

@property (nonatomic, assign) int fontIndex;
@property (nonatomic, assign) int fontColorIndex;
@property (nonatomic, assign) int fontSize;

@end
