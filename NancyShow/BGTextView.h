//
//  BGTextView.h
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/15.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGTextView : UITextView{
    int _fontIndex;
    int _fontColorIndex;
    int _fontSize;
}

@property (nonatomic) int fontIndex;
@property (nonatomic) int fontColorIndex;
@property (nonatomic) int fontSize;

@end
