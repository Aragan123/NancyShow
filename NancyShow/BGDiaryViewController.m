//
//  BGDiaryViewController.m
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/08.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGDiaryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

#import "BGGlobalData.h"
#import "BGTextView.h"
#import "AHAlertView.h"
#import "AKSegmentedControl.h"

@interface BGDiaryViewController ()

@end

@implementation BGDiaryViewController
@synthesize delegate, isEdited, savedImage, textEditor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        tplDetail = [[[BGGlobalData sharedData] diaryTplDetail] retain];
        textViews = [[[NSMutableArray alloc] initWithCapacity:tplDetail.count] retain];
        isEdited = NO;
        lastSelectedTVIndex=kTextNotSelected;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *backgroundPattern = [UIImage imageNamed:@"beauty_background.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];
    
    // set alert view style
    [AHAlertView applyCustomAlertAppearance];
    // load back ground images
    [self reloadImageView];
    
    // add Text View(s) and icons
    for (int i=0; i<tplDetail.count; i++){
        NSString *tvFrameStr = [[tplDetail objectAtIndex:i] objectForKey:@"tvFrame"];
        
        BGTextView *tv = [[[BGTextView alloc] initWithFrame:CGRectFromString(tvFrameStr)] autorelease];
        [self setupTextViewByDefaultValue:&tv atIndex:i]; // pass by reference
        [tplMainView addSubview:tv];
        
        // add to mutable array
        [textViews addObject:tv];
    }
    
    // add and set Segmented Control in bottomBar View
    segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(0,0, tplDetail.count*100+6, 44)];
    segmentedControl.center = CGPointMake(bottomBarImgView.center.x, bottomBarImgView.center.y+3);
    
    [segmentedControl addTarget:self action:@selector(segTextViewController:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setSegmentedControlMode:AKSegmentedControlModeSingleSelectionable];
    [self setupSegmentedControl];
    
    [bottomBarView insertSubview:segmentedControl aboveSubview:bottomBarImgView];

    
}

- (void) reloadImageView{
    UIImage *tplImg = [[BGGlobalData sharedData] diaryTplImage];
    tplImageView = [[UIImageView alloc] initWithFrame:CGRectMake((tplMainView.frame.size.width-tplImg.size.width)*0.5,
                                                                 (tplMainView.frame.size.height-tplImg.size.height)*0.5,
                                                                 tplImg.size.width, tplImg.size.height)];
    [tplImageView setImage:tplImg];
    [tplMainView addSubview:tplImageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload{
    tplImageView=nil;
    
    [tplMainView release];
    tplMainView = nil;
    tplDetail = nil;
    textViews=nil;
    
    slComposerSheet=nil;
    savedImage=nil;
    segmentedControl=nil;
    [bottomBarView release];
    bottomBarView = nil;
    [bottomBarImgView release];
    bottomBarImgView = nil;
    textEditor =nil;
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    [tplImageView release];
    
    [tplMainView release];
    [tplDetail release];
    [textViews release];
    
    [slComposerSheet release];
    [savedImage release];
    [segmentedControl release];
    [bottomBarView release];
    [bottomBarImgView release];
    [textEditor release];
    [super dealloc];
}

#pragma mark -
#pragma mark Action Methods
- (IBAction)clickCancelButton:(id)sender {
    // de-select all text segControl buttons and dismiss text editor
    [segmentedControl setSelectedIndexes:[NSIndexSet indexSet]];
    [segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
    
    // when cancel click, show a alert before return back to template home page
    if (nil == delegate) {
        return;
    }
    if (!isEdited) {
        [delegate switchViewTo:kPageDiaryHome fromView:kPageDiary]; // go back directly
        return;
    }
    
    AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"Discard Changes" message:@"Are you sure to discard your changes?"];
    [alert setDismissalStyle:AHAlertViewDismissalStyleZoomDown];
    [alert setCancelButtonTitle:@"Disard" block:^{
        [delegate switchViewTo:kPageDiaryHome fromView:kPageDiary]; // go back
	}];
	[alert addButtonWithTitle:@"No" block:nil];     //do nothing, just dismiss alert view
	[alert show];
    [alert release];
}

- (IBAction)clickOkButton:(id)sender {
    // de-select all text segControl buttons and dismiss text editor
    [segmentedControl setSelectedIndexes:[NSIndexSet indexSet]];
    [segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
    
    // when ok clicked, show share to Weibo 

    
    if (isEdited) {
        self.savedImage = [self screenshot:tplMainView]; // screen shot only has some change
        UIImageWriteToSavedPhotosAlbum(self.savedImage, nil, nil, nil); // save to photo album
        isEdited=NO;
        [self displayModalView]; // display sharing option view
    }else{
        //no change, then display a warning
        AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"You have not done any change" message:nil];
        [alert setDismissalStyle:AHAlertViewDismissalStyleZoomDown];
        [alert setCancelButtonTitle:@"OK" block:nil];
        [alert show];
        [alert release];
    }

}

- (void) segTextViewController: (id) sender{
    AKSegmentedControl *textSeg = (AKSegmentedControl *)sender;
    
    // lazy load text editor view
    if (self.textEditor == nil) {
        self.textEditor = [[BGTextEditorViewController alloc] initWithNibName:@"BGTextEditorViewController" bundle:nil];
        self.textEditor.delegate = self;
        self.textEditor.view.frame = CGRectMake(0, self.view.frame.size.height, tplMainView.frame.size.width, 52);
        [self.view insertSubview:self.textEditor.view belowSubview:bottomBarView];
    }

    if ([[textSeg selectedIndexes] count] == 0) {
        NSLog(@"Text Seg is de-selected");
        [self dismissTextEditorView];
        
    }else{        
        int selectedTextSegIndex = [[textSeg selectedIndexes] firstIndex];
        NSLog(@"TextSegmentedControl: selected index %i", selectedTextSegIndex);
        // show border on selected text view
        BGTextView *tv = [textViews objectAtIndex:selectedTextSegIndex];
        tv.layer.borderWidth = 2.5f;
        //set text editor's segmented control values
        [self.textEditor updateAlignmentSegContol:tv.textAlignment];
        [self.textEditor updateFontColorSegControl:tv.fontColorIndex];
        [self.textEditor updateFontSegControl:tv.fontIndex];

        
        // pop up text editor
        if (lastSelectedTVIndex == kTextNotSelected) {
            // first time to display text editor view
            [UIView animateWithDuration:0.2f animations:^{
                self.textEditor.view.center = CGPointMake(self.view.frame.size.width*0.5, tplMainView.frame.size.height-52*0.5);
            }];
            
        }else{
            // has previous text editor displayed
            BGTextView *lastTextView = [textViews objectAtIndex:lastSelectedTVIndex];
            lastTextView.layer.borderWidth = 0.0f;
            
            [UIView animateWithDuration:0.3f animations:^{
                self.textEditor.view.center = CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2f animations:^{
                     self.textEditor.view.center = CGPointMake(self.view.frame.size.width*0.5, tplMainView.frame.size.height-52*0.5);
                }];
            }];
        }
        
        lastSelectedTVIndex = selectedTextSegIndex;

    }
}

#pragma mark -
#pragma mark Private Methods
- (void) setupTextViewByDefaultValue: (BGTextView **) tv atIndex: (int) index{
    (*tv).tag = index;
    (*tv).delegate = self;
//    (*tv).backgroundColor= [UIColor lightGrayColor];
    (*tv).backgroundColor= [UIColor clearColor];
    (*tv).textColor = [UIColor blackColor];
    (*tv).font = [UIFont fontWithName:@"Arial" size:18.0];
    (*tv).scrollEnabled = NO;
    [(*tv).layer setCornerRadius: 6];
    [(*tv).layer setBorderColor:[[UIColor blueColor] CGColor]];
    [(*tv).layer setBorderWidth:0.0f]; // initially no border
    
    (*tv).fontIndex = 1;
    (*tv).fontSize = 18;
    (*tv).fontColorIndex = 1;
}

// used to dismiss text editor view if has any
- (void) dismissTextEditorView{
    if (lastSelectedTVIndex != kTextNotSelected) {
        // means text editor is show
        BGTextView *tv = [textViews objectAtIndex:lastSelectedTVIndex];
        tv.layer.borderWidth = 0.0f; // remove border
        lastSelectedTVIndex = kTextNotSelected;
        // dismiss text editor view
        [UIView animateWithDuration:0.1f animations:^{
            self.textEditor.view.center = CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height+52*0.5);
        }];
    }
}

// used to get screenshot
- (UIImage*)screenshot: (UIView*) view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // hack, helps w/ our colors when blurring
//    NSData *imageData = UIImageJPEGRepresentation(image, 1); // convert to jpeg
    NSData *imageData = UIImagePNGRepresentation(image); // convert to png
    image = [UIImage imageWithData:imageData];
    
    return image;
}

// when ok button is selected
-(void) displayModalView {
    NSLog(@"Diary Save Model View display");
    
    BGDiarySaveViewController *modelViewController = [[BGDiarySaveViewController alloc] initWithNibName:@"BGDiarySaveViewController" bundle:nil];
    modelViewController.delegate = self;
    modelViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    modelViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self presentViewController:modelViewController animated:YES completion:nil];
    modelViewController.view.superview.bounds = CGRectMake(0,0, 400,  220);

    [modelViewController release];

}

- (void)shareToFacebook {
    [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSLog(@"start completion block");
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successfull";
                break;
            default:
                break;
        }
        if (result != SLComposeViewControllerResultCancelled)
        {
            AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"Facebook Message" message:output];
            [alert setDismissalStyle:AHAlertViewDismissalStyleZoomDown];
            [alert setCancelButtonTitle:@"OK" block:^(void){
                [self.view endEditing:YES];
            }];
            [alert show];
            [alert release];
        }
    }];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [slComposerSheet setInitialText:@""];
        [slComposerSheet addImage:self.savedImage];
        [slComposerSheet addURL:[NSURL URLWithString:@"http://www.brutegame.com"]];
        [self presentViewController:slComposerSheet animated:YES completion:nil];
    }
}

- (void)shareToTwitter {    
    [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSLog(@"start completion block");
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successfull";
                break;
            default:
                break;
        }
        if (result != SLComposeViewControllerResultCancelled)
        {
            AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"Twitter Message" message:output];
            [alert setDismissalStyle:AHAlertViewDismissalStyleZoomDown];
            [alert setCancelButtonTitle:@"OK" block:^(void){
                [self.view endEditing:YES];
            }];
            [alert show];
            [alert release];
        }
    }];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [slComposerSheet setInitialText:@""];
        [slComposerSheet addImage:self.savedImage];
        [slComposerSheet addURL:[NSURL URLWithString:@"http://www.brutegame.com"]];
        [self presentViewController:slComposerSheet animated:YES completion:nil];
    }
}

- (void)shareToWeibo{
    [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSLog(@"start weibo completion block");
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successfully";
                break;
            default:
                break;
        }
        
        if (result != SLComposeViewControllerResultCancelled){
            AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"Weibo Message" message:output];
            [alert setDismissalStyle:AHAlertViewDismissalStyleZoomDown];
            [alert setCancelButtonTitle:@"OK" block:^{
                [self.view endEditing:YES];
            }];
            [alert show];
            [alert release];
        }
    }];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo])
    {
        slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        [slComposerSheet setInitialText:@""];
        [slComposerSheet addImage:self.savedImage];
        [slComposerSheet addURL:[NSURL URLWithString:@"http://www.brutegame.com/"]];
        [self presentViewController:slComposerSheet animated:YES completion:nil];
    }
}

- (void)shareByActivity:(UIImage*) sharingImage andText: (NSString*)sharingText {
    NSArray *activityItems;
    
    if (sharingImage != nil) {
        activityItems = @[sharingText, sharingImage];
    } else {
        activityItems = @[sharingText];
    }
    
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                      applicationActivities:nil];
    
    [self presentViewController:activityController
                       animated:YES completion:nil];
}

#pragma mark -
#pragma mark UITextView Delegae Methods
- (void)textViewDidChange:(UITextView *)textView{
    isEdited=YES;
}

#pragma mark -
#pragma mark BGDiarySaveViewController delegate methods
-(void) clickSaveViewShareButton: (int)shareType{
    [self dismissViewControllerAnimated:YES completion:^(void){
        if ( NSClassFromString(@"SLComposeViewController") == nil ) {
            NSString *title = @"Not able to post";
            NSString *output = @"To post your image, please upgrade your iOS version above 6.0. Your image has been saved to Photo Album.";
            AHAlertView *alert = [[AHAlertView alloc] initWithTitle:title message:output];
            [alert setDismissalStyle:AHAlertViewDismissalStyleZoomDown];
            [alert setCancelButtonTitle:@"OK" block:nil];
            [alert show];
            [alert release];
        }else{
            switch (shareType) {
                case 0:
                    [self shareToWeibo];
                    break;
                case 1:
                    [self shareToTwitter];
                    break;
                case 2:
                    [self shareToFacebook];
                    break;
                    
                default:
                    break;
            }
        }
    }]; // dissmis previous modal view first
}

-(void) clickSaveViewCloseButton{
    //    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark BGTextEditorViewController delegate methods
- (void) updateFontName: (UIFont*) newFont withFontIndex: (int) index{
    BGTextView *tv = [textViews objectAtIndex:lastSelectedTVIndex];
    [tv setFont:[newFont fontWithSize:tv.fontSize]];
    tv.fontIndex = index;
}

- (void) updateTextAlignment: (int) index{
    BGTextView *tv = [textViews objectAtIndex:lastSelectedTVIndex];
    tv.textAlignment = index;
}

- (void) updateFontSize: (int) index{
    BGTextView *tv = [textViews objectAtIndex:lastSelectedTVIndex];
    int fSize = tv.fontSize;
    
    if (0==index && (fSize-1)>=kMinTextFontSize) {
        fSize--; //smaller
     }else if (1==index && (fSize+1)<=kMaxTextFontSize){
         fSize++; // larger
     }else return;
    
    [tv setFont:[tv.font fontWithSize:fSize]];
    tv.fontSize = fSize;

}

- (void) updateFontColor: (UIColor*) newColor withColorIndex: (int) index{
    NSLog(@"updateFontColor:newColor is selected");
    BGTextView *tv = [textViews objectAtIndex:lastSelectedTVIndex];
    tv.textColor = newColor;
    tv.fontColorIndex = index;
}


#pragma mark -
#pragma mark Segmented Control Methods
- (void) setupSegmentedControl{
    [segmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];

    int totalTpl = [tplDetail count];
    NSMutableArray *buttonArray = [NSMutableArray arrayWithCapacity:totalTpl];
    
    if (totalTpl == 1){
        // when only a single text pad in template
        UIButton *button = [[[UIButton alloc] init] autorelease];
        NSString *buttonTitle = [NSString stringWithFormat:@"Text 1"];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:124.0 green:202.0 blue:0.0 alpha:1.0] forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont fontWithName:@"Noteworthy-Bold" size:12.0]];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_single_a.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_single_b.png"] forState:UIControlStateSelected];
        // add button to mutable array
        [buttonArray addObject:button];
        
    }else{
        // when there are more than one text pad
        // normal images
        UIImage *buttonBackgroundImageLeft = [[UIImage imageNamed:@"btn_left_a.png"]
                                              resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
        UIImage *buttonBackgroundImageCenter = [[UIImage imageNamed:@"btn_middle_a.png"]
                                                resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
        UIImage *buttonBackgroundImageRight = [[UIImage imageNamed:@"btn_right_a.png"]
                                               resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 1.0, 0.0, 4.0)];
        // pressed images
        UIImage *buttonBackgroundImagePressedLeft = [[UIImage imageNamed:@"btn_left_b.png"]
                                                     resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
        UIImage *buttonBackgroundImagePressedCenter = [[UIImage imageNamed:@"btn_middle_b.png"]
                                                       resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
        UIImage *buttonBackgroundImagePressedRight = [[UIImage imageNamed:@"btn_right_b.png"]
                                                      resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 1.0, 0.0, 4.0)];

        for (int i=0; i<totalTpl; i++) {
            UIButton *button = [[[UIButton alloc] init] autorelease];
            //        [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 5.0)];

            NSString *buttonTitle = [NSString stringWithFormat:@"Text %i", i+1];
            [button setTitle:buttonTitle forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:124.0 green:202.0 blue:0.0 alpha:1.0] forState:UIControlStateSelected];
            [button.titleLabel setFont:[UIFont fontWithName:@"Noteworthy-Bold" size:12.0]];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
            
            if (i==0) {
                // first one, must use left image
                [button setBackgroundImage:buttonBackgroundImageLeft forState:UIControlStateNormal];
                [button setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
            }else if (i == totalTpl-1){
                // last one, must use right image
                [button setBackgroundImage:buttonBackgroundImageRight forState:UIControlStateNormal];
                [button setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
            }else{
                // rest use middle image
                [button setBackgroundImage:buttonBackgroundImageCenter forState:UIControlStateNormal];
                [button setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateSelected];
            }
            // add button to mutable array
            [buttonArray addObject:button];
        }
    }
    
    // finally add button array
    [segmentedControl setButtonsArray:buttonArray];
}

@end
