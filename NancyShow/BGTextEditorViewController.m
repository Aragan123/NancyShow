//
//  BGTextEditorViewController.m
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/11.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGTextEditorViewController.h"
#import "AKSegmentedControl.h"

@interface BGTextEditorViewController ()

@end

@implementation BGTextEditorViewController
@synthesize delegate, fontSegControl, fontColorSegControl, fontSizeSegControl, alignmentSegControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        fontNames = [[NSArray arrayWithObjects:@"Noteworthy", @"Arial", @"Marion", @"Zapfino",nil] retain];
        fontArray = [[NSArray arrayWithObjects:[UIFont fontWithName:@"Noteworthy" size:12.0],
                      [UIFont fontWithName:@"Arial" size:16.0],
                      [UIFont fontWithName:@"Marion-Bold" size:16.0],
                      [UIFont fontWithName:@"Zapfino" size:9.0],nil] retain];
        fontColor = [[NSArray arrayWithObjects:[UIColor redColor], [UIColor blackColor],
                      [UIColor blueColor], [UIColor orangeColor], [UIColor greenColor], nil] retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    // set up fontSegControl
    self.fontSegControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(20, 4, 326, 44)];
    [self.fontSegControl addTarget:self action:@selector(selectFontSegControl:) forControlEvents:UIControlEventValueChanged];
    [self.fontSegControl setSegmentedControlMode:AKSegmentedControlModeSticky];
    [self.fontSegControl setSelectedIndex:0];
    [self setupFontSegControl];
    [self.view addSubview:self.fontSegControl];

    // set up alignmentSegControl
    self.alignmentSegControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(366, 4, 186, 44)];
    [self.alignmentSegControl addTarget:self action:@selector(selectAlignmentSegControl:) forControlEvents:UIControlEventValueChanged];
    [self.alignmentSegControl setSegmentedControlMode:AKSegmentedControlModeSticky];
    [self.alignmentSegControl setSelectedIndex:0];
    [self setupAlignmentSegControl];
    [self.view addSubview:self.alignmentSegControl];
    
    // set up fontSizeSegControl
    self.fontSizeSegControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(562, 4, 126, 44)];
    [self.fontSizeSegControl addTarget:self action:@selector(selectFontSizeSegControl:) forControlEvents:UIControlEventValueChanged];
    [self.fontSizeSegControl setSegmentedControlMode:AKSegmentedControlModeButton];
    [self setupFontSizeSegControl];
    [self.view addSubview:self.fontSizeSegControl];
    
    // set up fontColorSegControl
    self.fontColorSegControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(718, 4, 250, 44)];
    [self.fontColorSegControl addTarget:self action:@selector(selectFontColorSegControl:) forControlEvents:UIControlEventValueChanged];
    [self.fontColorSegControl setSegmentedControlMode:AKSegmentedControlModeSticky];
    [self.fontColorSegControl setSelectedIndex:0];
    [self setupFontColorSegControl];
    [self.view addSubview:self.fontColorSegControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload{
    fontNames=nil;
    fontArray=nil;
    fontColor=nil;
    
    fontSegControl=nil;
    fontSizeSegControl=nil;
    fontColorSegControl=nil;
    alignmentSegControl=nil;
    
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    [fontNames release];
    [fontArray release];
    [fontColor release];
    
    [fontSizeSegControl release];
    [fontColorSegControl release];
    [fontSegControl release];
    [alignmentSegControl release];
    [super dealloc];
}

#pragma mark - 
#pragma mark Public Methods & Action Methods
- (void) updateFontSegControl: (int) index{
    [self.fontSegControl setSelectedIndex:index];
}

- (void) updateAlignmentSegContol: (int) index{
    [self.alignmentSegControl setSelectedIndex:index];
}

- (void) updateFontColorSegControl: (int) index{
    [self.fontColorSegControl setSelectedIndex:index];
}

#pragma Action Methods
- (void) selectFontSegControl: (id) sender{
    int selectedSegIndex = [[(AKSegmentedControl *)sender selectedIndexes] firstIndex];
    NSLog(@"selectFontSegControl: selected index %i", selectedSegIndex);
    
    if (nil != delegate && [delegate respondsToSelector:@selector(updateFontName:withFontIndex:)]) {
        [delegate updateFontName:[fontArray objectAtIndex:selectedSegIndex] withFontIndex:selectedSegIndex];
    }
}

- (void) selectAlignmentSegControl: (id) sender{
    int selectedSegIndex = [[(AKSegmentedControl *)sender selectedIndexes] firstIndex];
    NSLog(@"selectAlignmentSegControl: selected index %i", selectedSegIndex);
    
    if (nil != delegate && [delegate respondsToSelector:@selector(updateTextAlignment:)]) {
        [delegate updateTextAlignment:selectedSegIndex];
    }
}

- (void) selectFontSizeSegControl: (id) sender{
    int selectedSegIndex = [[(AKSegmentedControl *)sender selectedIndexes] firstIndex];
    NSLog(@"selectFontSizeSegControl: selected index %i", selectedSegIndex);
    
    if (nil != delegate && [delegate respondsToSelector:@selector(updateFontSize:)]) {
        [delegate updateFontSize:selectedSegIndex];
    }
}

- (void) selectFontColorSegControl: (id) sender{
    int selectedSegIndex = [[(AKSegmentedControl *)sender selectedIndexes] firstIndex];
    NSLog(@"selectFontColorSegControl: selected index %i", selectedSegIndex);
    
    if (nil != delegate && [delegate respondsToSelector:@selector(updateFontColor:withColorIndex:)]) {
        UIColor *fc =  [fontColor objectAtIndex:selectedSegIndex];
        [delegate updateFontColor:fc withColorIndex:selectedSegIndex];
    }
}


#pragma mark - 
#pragma mark Segmented Control Setup Methods
-(void) setupFontSegControl{
    // set up fontSegControl
    [self.fontSegControl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    
    // normal images
    UIImage *buttonBackgroundImageLeft = [[UIImage imageNamed:@"btn_left_sa.png"]
                                          resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
    UIImage *buttonBackgroundImageCenter = [[UIImage imageNamed:@"btn_middle_sa.png"]
                                            resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
    UIImage *buttonBackgroundImageRight = [[UIImage imageNamed:@"btn_right_sa.png"]
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 1.0, 0.0, 4.0)];
    // pressed images
    UIImage *buttonBackgroundImagePressedLeft = [[UIImage imageNamed:@"btn_left_sb.png"]
                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
    UIImage *buttonBackgroundImagePressedCenter = [[UIImage imageNamed:@"btn_middle_sb.png"]
                                                   resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
    UIImage *buttonBackgroundImagePressedRight = [[UIImage imageNamed:@"btn_right_sb.png"]
                                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 1.0, 0.0, 4.0)];
    
    // construct segmented control buttons
    int totalButtons = [fontArray count];
    NSMutableArray *buttonArray = [NSMutableArray arrayWithCapacity:totalButtons];
    
    for (int i=0; i<totalButtons; i++) {
        UIButton *button = [[[UIButton alloc] init] autorelease];
        
        NSString *buttonTitle = [fontNames objectAtIndex:i];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:124.0 green:202.0 blue:0.0 alpha:1.0] forState:UIControlStateSelected];
        [button.titleLabel setFont:[fontArray objectAtIndex:i]];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
        
        if (i==0) {
            // first one, must use left image
            [button setBackgroundImage:buttonBackgroundImageLeft forState:UIControlStateNormal];
            [button setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateSelected)];
        }else if (i == totalButtons-1){
            // last one, must use right image
            [button setBackgroundImage:buttonBackgroundImageRight forState:UIControlStateNormal];
            [button setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateSelected)];
        }else{
            // Middle ones
            [button setBackgroundImage:buttonBackgroundImageCenter forState:UIControlStateNormal];
            [button setBackgroundImage:buttonBackgroundImagePressedCenter forState:(UIControlStateSelected)];
        }
        
        [buttonArray addObject:button];
    }
    
    [self.fontSegControl setButtonsArray:buttonArray];
}

-(void) setupAlignmentSegControl{
    // set up alignmentSegControl
    // normal images
    UIImage *buttonBackgroundImageLeft = [UIImage imageNamed:@"btn_alignLeft_sa.png"];
    UIImage *buttonBackgroundImageCenter = [UIImage imageNamed:@"btn_alignCentre_sa.png"];
    UIImage *buttonBackgroundImageRight = [UIImage imageNamed:@"btn_alignRight_sa.png"];
    // pressed images
    UIImage *buttonBackgroundImagePressedLeft = [UIImage imageNamed:@"btn_alignLeft_sb.png"];
    UIImage *buttonBackgroundImagePressedCenter = [UIImage imageNamed:@"btn_alignCentre_sb.png"];
    UIImage *buttonBackgroundImagePressedRight = [UIImage imageNamed:@"btn_alignRight_sb.png"];
    // define button array
    NSMutableArray *buttonArray = [NSMutableArray arrayWithCapacity:3];
    // left alignment button
    UIButton *buttonL = [[[UIButton alloc] init] autorelease];
    [buttonL setBackgroundImage:buttonBackgroundImageLeft forState:UIControlStateNormal];
    [buttonL setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateSelected)];
    [buttonArray addObject:buttonL];
    // Centre alignment button
    UIButton *buttonC = [[[UIButton alloc] init] autorelease];
    [buttonC setBackgroundImage:buttonBackgroundImageCenter forState:UIControlStateNormal];
    [buttonC setBackgroundImage:buttonBackgroundImagePressedCenter forState:(UIControlStateSelected)];
    [buttonArray addObject:buttonC];
    // Right alignment button
    UIButton *buttonR = [[[UIButton alloc] init] autorelease];
    [buttonR setBackgroundImage:buttonBackgroundImageRight forState:UIControlStateNormal];
    [buttonR setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateSelected)];
    [buttonArray addObject:buttonR];
    
    [self.alignmentSegControl setButtonsArray:buttonArray];
}

-(void) setupFontSizeSegControl{
    // set up fontSizeSegControl
    // normal images
    UIImage *buttonBackgroundImageLeft = [[UIImage imageNamed:@"btn_left_sa.png"]
                                          resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
    UIImage *buttonBackgroundImageRight = [[UIImage imageNamed:@"btn_right_sa.png"]
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 1.0, 0.0, 4.0)];
    // pressed images
    UIImage *buttonBackgroundImagePressedLeft = [[UIImage imageNamed:@"btn_left_sb.png"]
                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
    UIImage *buttonBackgroundImagePressedRight = [[UIImage imageNamed:@"btn_right_sb.png"]
                                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 1.0, 0.0, 4.0)];
    // define button array
    NSMutableArray *buttonArray = [NSMutableArray arrayWithCapacity:2];
    // Font Size - button
    UIButton *buttonL = [[[UIButton alloc] init] autorelease];
    [buttonL setTitle:@"A-" forState:UIControlStateNormal];
    [buttonL setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonL setTitleColor:[UIColor colorWithRed:124.0 green:202.0 blue:0.0 alpha:1.0] forState:UIControlStateSelected];
    [buttonL setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
//    [buttonL.titleLabel setFont:[UIFont fontWithName:@"CourierNewPS-BoldMT" size:14.0]];
    [buttonL setBackgroundImage:buttonBackgroundImageLeft forState:UIControlStateNormal];
    [buttonL setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateSelected)];
    [buttonArray addObject:buttonL];
    // Font Size + button
    UIButton *buttonR = [[[UIButton alloc] init] autorelease];
    [buttonR setTitle:@"A+" forState:UIControlStateNormal];
    [buttonR setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonR setTitleColor:[UIColor colorWithRed:124.0 green:202.0 blue:0.0 alpha:1.0] forState:UIControlStateSelected];
    [buttonR setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
//    [buttonR.titleLabel setFont:[UIFont fontWithName:@"CourierNewPS-BoldMT" size:14.0]];
    [buttonR setBackgroundImage:buttonBackgroundImageRight forState:UIControlStateNormal];
    [buttonR setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateSelected)];
    [buttonArray addObject:buttonR];
    
    [self.fontSizeSegControl setButtonsArray:buttonArray];
}

-(void) setupFontColorSegControl{
    // set up fontColorSegControl
    // define button array
    NSMutableArray *buttonArray = [NSMutableArray arrayWithCapacity:[fontColor count]];
    // Red button
    UIButton *buttonRed = [[[UIButton alloc] init] autorelease];
    [buttonRed setImage:[UIImage imageNamed:@"btn_fc_red_sa.png"] forState:UIControlStateNormal];
    [buttonRed setImage:[UIImage imageNamed:@"btn_fc_red_sb.png"] forState:(UIControlStateSelected)];
    [buttonArray addObject:buttonRed];
    // Black button
    UIButton *buttonBalck = [[[UIButton alloc] init] autorelease];
    [buttonBalck setImage:[UIImage imageNamed:@"btn_fc_purple_sa.png"] forState:UIControlStateNormal];
    [buttonBalck setImage:[UIImage imageNamed:@"btn_fc_purple_sb.png"] forState:(UIControlStateSelected)];
    [buttonArray addObject:buttonBalck];
    // Blue button
    UIButton *buttonBlue = [[[UIButton alloc] init] autorelease];
    [buttonBlue setImage:[UIImage imageNamed:@"btn_fc_blue_sa.png"] forState:UIControlStateNormal];
    [buttonBlue setImage:[UIImage imageNamed:@"btn_fc_blue_sb.png"] forState:(UIControlStateSelected)];
    [buttonArray addObject:buttonBlue];
    // Orange button
    UIButton *buttonOrange = [[[UIButton alloc] init] autorelease];
    [buttonOrange setImage:[UIImage imageNamed:@"btn_fc_orange_sa.png"] forState:UIControlStateNormal];
    [buttonOrange setImage:[UIImage imageNamed:@"btn_fc_orange_sb.png"] forState:(UIControlStateSelected)];
    [buttonArray addObject:buttonOrange];
    // Green button
    UIButton *buttonGreen = [[[UIButton alloc] init] autorelease];
    [buttonGreen setImage:[UIImage imageNamed:@"btn_fc_green_sa.png"] forState:UIControlStateNormal];
    [buttonGreen setImage:[UIImage imageNamed:@"btn_fc_green_sb.png"] forState:(UIControlStateSelected)];
    [buttonArray addObject:buttonGreen];
    
    [self.fontColorSegControl setButtonsArray:buttonArray];
}

@end
