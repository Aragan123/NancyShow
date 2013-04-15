//
//  BGTextView.m
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/15.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGTextView.h"

@implementation BGTextView
@synthesize fontIndex=_fontIndex, fontColorIndex=_fontColorIndex, fontSize=_fontSize;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit{
    self.fontIndex = 1;
    self.fontSize = 18;
    self.fontColorIndex = 1;
}

- (void) dealloc{
    
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
