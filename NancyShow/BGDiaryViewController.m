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

#import "BGGlobalData.h"
#import "BGTextView.h"
#import "AHAlertView.h"
#import "AKSegmentedControl.h"

@interface BGDiaryViewController ()

@end

@implementation BGDiaryViewController
@synthesize delegate;
@synthesize tplMainView, bottomBarView, bottomBarImgView, tplImageView, segmentedControl, textEditor;
@synthesize isEdited, tplDetail, textViews, lastSelectedTVIndex, savedImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tplDetail = [[BGGlobalData sharedData] diaryTplDetail];
        self.textViews = [[NSMutableArray alloc] initWithCapacity:self.tplDetail.count];
        self.isEdited = NO;
        self.lastSelectedTVIndex=kTextNotSelected;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIImage *backgroundPattern = [UIImage imageNamed:@"beauty_background.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];
    
    // set alert view style
    [AHAlertView applyCustomAlertAppearance];
    // load back ground images
    [self reloadImageView];
    
    // add Text View(s) and icons
    for (int i=0; i<tplDetail.count; i++){
        NSString *tvFrameStr = [[self.tplDetail objectAtIndex:i] objectForKey:@"tvFrame"];
        
        BGTextView *tv = [[BGTextView alloc] initWithFrame:CGRectFromString(tvFrameStr)];
        [self setupTextViewByDefaultValue:&tv atIndex:i]; // pass by reference
        [self.tplMainView addSubview:tv]; // add view to main view
        [self.tplMainView bringSubviewToFront:tv];
        [self.textViews addObject:tv]; // add to mutable array to store it
        [tv release];
    }
    
    // add and set Segmented Control in bottomBar View
    self.segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(0,0, self.tplDetail.count*100+6, 44)];
    self.segmentedControl.center = CGPointMake(self.bottomBarImgView.center.x, self.bottomBarImgView.center.y+3);
    
    [self.segmentedControl addTarget:self action:@selector(segTextViewController:) forControlEvents:UIControlEventValueChanged];
    [self.segmentedControl setSegmentedControlMode:AKSegmentedControlModeSingleSelectionable];
    [self setupSegmentedControl];
    
    [self.bottomBarView insertSubview:self.segmentedControl aboveSubview:self.bottomBarImgView];    
}

- (void) reloadImageView{
    UIImage *tplImg = [[BGGlobalData sharedData] diaryTplImage];
    self.tplImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.tplMainView.frame.size.width-tplImg.size.width)*0.5,
                                                                 (self.tplMainView.frame.size.height-tplImg.size.height)*0.5,
                                                                 tplImg.size.width, tplImg.size.height)];
    [self.tplImageView setContentMode:UIViewContentModeCenter]; // content mode: centre
    [self.tplImageView setImage:tplImg];
    [self.tplMainView addSubview:self.tplImageView];
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
    [bottomBarView release];
    bottomBarView = nil;
    [bottomBarImgView release];
    bottomBarImgView = nil;
    [tplImageView release];
    tplImageView=nil;
    [segmentedControl release];
    segmentedControl=nil;
    [textEditor release];
    textEditor=nil;
    
    [tplDetail release];
    tplDetail = nil;
    [textViews release];
    textViews=nil;
    [savedImage release];
    savedImage=nil;
    
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    
    [tplMainView release];
    [bottomBarView release];
    [bottomBarImgView release];
    [tplImageView release];
    [segmentedControl release];
    [textEditor release];
    
    [tplDetail release];
    [textViews release];
    [savedImage release];

    [super dealloc];
}

#pragma mark -
#pragma mark Action Methods
- (IBAction)clickCancelButton:(id)sender {
    // de-select all text segControl buttons and dismiss text editor
    [self.segmentedControl setSelectedIndexes:[NSIndexSet indexSet]];
    [self.segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
    
    // when cancel click, show a alert before return back to template home page
    if (nil == self.delegate) {
        return;
    }
    if (!self.isEdited) {
        [self.delegate switchViewTo:kPageDiaryHome fromView:kPageDiary]; // go back directly
        return;
    }
    
    AHAlertView *alert = [[AHAlertView alloc] initWithTitle:NSLocalizedString(@"Discard Changes Title", nil) message:NSLocalizedString(@"Discard Changes Message", nil)];
    [alert setDismissalStyle:AHAlertViewDismissalStyleZoomDown];
    [alert setCancelButtonTitle:NSLocalizedString(@"Discard Yes Button", nil) block:^{
        [delegate switchViewTo:kPageDiaryHome fromView:kPageDiary]; // go back
	}];
	[alert addButtonWithTitle:NSLocalizedString(@"No Button", nil) block:nil];     //do nothing, just dismiss alert view
	[alert show];
    [alert release];
}

- (IBAction)clickOkButton:(id)sender {
    // de-select all text segControl buttons and dismiss text editor
    [self.segmentedControl setSelectedIndexes:[NSIndexSet indexSet]];
    [self.segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
    
    // when ok clicked, show share to Weibo
    if (self.isEdited) {
        self.savedImage = [self screenshot:self.tplMainView]; // screen shot only has some change
        UIImageWriteToSavedPhotosAlbum(self.savedImage, nil, nil, nil); // save to photo album
        self.isEdited=NO;
        [self displayModalView]; // display sharing option view
    }else{
        //no change, then display a warning
        AHAlertView *alert = [[AHAlertView alloc] initWithTitle:NSLocalizedString(@"No Change Message", nil) message:nil];
        [alert setDismissalStyle:AHAlertViewDismissalStyleZoomDown];
        [alert setCancelButtonTitle:NSLocalizedString(@"OK Button", nil) block:nil];
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
        self.textEditor.view.frame = CGRectMake(0, self.view.frame.size.height, self.tplMainView.frame.size.width, 52);
        [self.view insertSubview:self.textEditor.view belowSubview:self.bottomBarView];
    }

    if ([[textSeg selectedIndexes] count] == 0) {
        NSLog(@"Text Seg is de-selected");
        [self dismissTextEditorView];
        
    }else{        
        int selectedTextSegIndex = [[textSeg selectedIndexes] firstIndex];
        NSLog(@"TextSegmentedControl: selected index %i", selectedTextSegIndex);
        // show border on selected text view
        BGTextView *tv = [self.textViews objectAtIndex:selectedTextSegIndex];
        tv.layer.borderWidth = 1.5f;
        //set text editor's segmented control values
        [self.textEditor updateAlignmentSegContol:tv.textAlignment];
        [self.textEditor updateFontColorSegControl:tv.fontColorIndex];
        [self.textEditor updateFontSegControl:tv.fontIndex];

        
        // pop up text editor
        if (self.lastSelectedTVIndex == kTextNotSelected) {
            // first time to display text editor view
            [UIView animateWithDuration:0.2f animations:^{
                self.textEditor.view.center = CGPointMake(self.view.frame.size.width*0.5, self.tplMainView.frame.size.height-52*0.5);
            }];
            
        }else{
            // has previous text editor displayed
            BGTextView *lastTextView = [self.textViews objectAtIndex:self.lastSelectedTVIndex];
            lastTextView.layer.borderWidth = 0.0f;
            
            [UIView animateWithDuration:0.3f animations:^{
                self.textEditor.view.center = CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2f animations:^{
                     self.textEditor.view.center = CGPointMake(self.view.frame.size.width*0.5, self.tplMainView.frame.size.height-52*0.5);
                }];
            }];
        }
        
        self.lastSelectedTVIndex = selectedTextSegIndex;

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
    [(*tv).layer setCornerRadius: 4];
    [(*tv).layer setBorderColor:[[UIColor grayColor] CGColor]];
    [(*tv).layer setBorderWidth:0.0f]; // initially no border
    
    (*tv).fontIndex = 1;
    (*tv).fontSize = 18;
    (*tv).fontColorIndex = 1;
}

// used to dismiss text editor view if has any
- (void) dismissTextEditorView{
    if (self.lastSelectedTVIndex != kTextNotSelected) {
        // means text editor is show
        BGTextView *tv = [self.textViews objectAtIndex:self.lastSelectedTVIndex];
        tv.layer.borderWidth = 0.0f; // remove border
        self.lastSelectedTVIndex = kTextNotSelected;
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
    
    if ( ![self socialShareAvailable] ) {
        NSString *title = NSLocalizedString(@"Cannot Post Title", nil);
        NSString *output = NSLocalizedString(@"Cannot Post Message", nil);
        AHAlertView *alert = [[AHAlertView alloc] initWithTitle:title message:output];
        [alert setDismissalStyle:AHAlertViewDismissalStyleZoomDown];
        [alert setCancelButtonTitle:NSLocalizedString(@"OK Button", nil) block:nil];
        [alert show];
        [alert release];
    }else{
        BGDiarySaveViewController *modelViewController = [[BGDiarySaveViewController alloc] initWithNibName:@"BGDiarySaveViewController" bundle:nil];
        modelViewController.delegate = self;
        modelViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        modelViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self presentViewController:modelViewController animated:YES completion:nil];
        modelViewController.view.superview.bounds = CGRectMake(0,0, 400,  220);

        [modelViewController release];
    }
}

-(BOOL)socialShareAvailable {
    if ( NSClassFromString(@"SLComposeViewController") != nil ) {
        BOOL facebookAvailable = [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook];
        BOOL twitterAvailable = [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
        BOOL weiboAvailable = [SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo];
        
        return ( facebookAvailable || twitterAvailable || weiboAvailable );
    }
    else {
        return NO;
    }
}

- (void)shareToFacebook {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *socialVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        // add handler
        SLComposeViewControllerCompletionHandler socialHandler = ^(SLComposeViewControllerResult result) {
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = NSLocalizedString(@"Sharing Cancelled", nil);
                    break;
                case SLComposeViewControllerResultDone:
                    output = NSLocalizedString(@"Sharing Sucessful", nil);
                    break;
                default:
                    break;
            }
            
            [socialVC dismissViewControllerAnimated:YES completion:^(void){
                AHAlertView *alert = [[AHAlertView alloc] initWithTitle:output message:nil];
                [alert setDismissalStyle:AHAlertViewDismissalStyleZoomDown];
                [alert setCancelButtonTitle:NSLocalizedString(@"OK Button", nil) block:^{
                    [self.view endEditing:YES];
                }];
                [alert show];
                [alert release];
            }];
        };
        
        socialVC.completionHandler = socialHandler;
        [socialVC setInitialText:@"#Nancy Zhang#"];
        [socialVC addImage:self.savedImage];
        //        [socialVC addURL:[NSURL URLWithString:@"http://www.brutegame.com/"]];
        
        // finally display social view controller
        [self presentViewController:socialVC animated:YES completion:nil];
    }
}

- (void)shareToTwitter {    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *socialVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        // add handler
        SLComposeViewControllerCompletionHandler socialHandler = ^(SLComposeViewControllerResult result) {
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = NSLocalizedString(@"Sharing Cancelled", nil);
                    break;
                case SLComposeViewControllerResultDone:
                    output = NSLocalizedString(@"Sharing Sucessful", nil);
                    break;
                default:
                    break;
            }
            
            [socialVC dismissViewControllerAnimated:YES completion:^(void){
                AHAlertView *alert = [[AHAlertView alloc] initWithTitle:output message:nil];
                [alert setDismissalStyle:AHAlertViewDismissalStyleZoomDown];
                [alert setCancelButtonTitle:NSLocalizedString(@"OK Button", nil) block:^{
                    [self.view endEditing:YES];
                }];
                [alert show];
                [alert release];
            }];
        };
        
        socialVC.completionHandler = socialHandler;
        [socialVC setInitialText:@"#Nancy Zhang#"];
        [socialVC addImage:self.savedImage];
        //        [socialVC addURL:[NSURL URLWithString:@"http://www.brutegame.com/"]];
        
        // finally display social view controller
        [self presentViewController:socialVC animated:YES completion:nil];
    }
}

- (void)shareToWeibo{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo])
    {
        SLComposeViewController *socialVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        // add handler
        SLComposeViewControllerCompletionHandler socialHandler = ^(SLComposeViewControllerResult result) {
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = NSLocalizedString(@"Sharing Cancelled", nil);
                    break;
                case SLComposeViewControllerResultDone:
                    output = NSLocalizedString(@"Sharing Sucessful", nil);
                    break;
                default:
                    break;
            }
            
            [socialVC dismissViewControllerAnimated:YES completion:^(void){
                AHAlertView *alert = [[AHAlertView alloc] initWithTitle:output message:nil];
                [alert setDismissalStyle:AHAlertViewDismissalStyleZoomDown];
                [alert setCancelButtonTitle:NSLocalizedString(@"OK Button", nil) block:^{
                    [self.view endEditing:YES];
                }];
                [alert show];
                [alert release];
            }];
        };
        
        socialVC.completionHandler = socialHandler;
        [socialVC setInitialText:@"#Nancy的App#"];
        [socialVC addImage:self.savedImage];
        //        [socialVC addURL:[NSURL URLWithString:@"http://www.brutegame.com/"]];
        
        // finally display social view controller
        [self presentViewController:socialVC animated:YES completion:nil];
    }

}

#pragma mark -
#pragma mark UITextView Delegae Methods
- (void)textViewDidChange:(UITextView *)textView{
    self.isEdited=YES;
}

#pragma mark -
#pragma mark BGDiarySaveViewController delegate methods
-(void) clickSaveViewShareButton: (int)shareType{
    [self dismissViewControllerAnimated:YES completion:^(void){
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
    }]; // dissmis previous modal view first
}

-(void) clickSaveViewCloseButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark BGTextEditorViewController delegate methods
- (void) updateFontName: (UIFont*) newFont withFontIndex: (int) index{
    BGTextView *tv = [self.textViews objectAtIndex:self.lastSelectedTVIndex];
    [tv setFont:[newFont fontWithSize:tv.fontSize]];
    tv.fontIndex = index;
}

- (void) updateTextAlignment: (int) index{
    BGTextView *tv = [self.textViews objectAtIndex:self.lastSelectedTVIndex];
    tv.textAlignment = index;
}

- (void) updateFontSize: (int) index{
    BGTextView *tv = [self.textViews objectAtIndex:self.lastSelectedTVIndex];
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
    BGTextView *tv = [self.textViews objectAtIndex:self.lastSelectedTVIndex];
    tv.textColor = newColor;
    tv.fontColorIndex = index;
}


#pragma mark -
#pragma mark Segmented Control Methods
- (void) setupSegmentedControl{
    [self.segmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];

    int totalTpl = [self.tplDetail count];
    NSMutableArray *buttonArray = [NSMutableArray arrayWithCapacity:totalTpl];
    
    if (totalTpl == 1){
        // when only a single text pad in template
        UIButton *button = [[[UIButton alloc] init] autorelease];
        NSString *buttonTitle = [NSString stringWithFormat:@"%@ %i", NSLocalizedString(@"Text Area Button", nil), 1];
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

            NSString *buttonTitle = [NSString stringWithFormat:@"%@ %i", NSLocalizedString(@"Text Area Button", nil), i+1];
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
    [self.segmentedControl setButtonsArray:buttonArray];
}

@end
