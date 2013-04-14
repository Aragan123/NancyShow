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
#import "AHAlertView.h"
#import "BGDiarySaveViewController.h"
#import "AKSegmentedControl.h"
#import "BGTextEditorViewController.h"

@interface BGDiaryViewController ()

@end

@implementation BGDiaryViewController
@synthesize delegate, isEdited, savedImage, textEditor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        tplDetail = [[BGGlobalData sharedData] diaryTplDetail];
        textViews = [[NSMutableArray alloc] initWithCapacity:tplDetail.count];
        isEdited = NO;
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
//    for (NSDictionary *tvData in tplDetail){
        NSString *tvFrameStr = [[tplDetail objectAtIndex:i] objectForKey:@"tvFrame"];
//        NSString *tvBackgroundColorStr = [tvData objectForKey:@"tvBackgroundColor"];
        
        UITextView *tv = [[[UITextView alloc] initWithFrame:CGRectFromString(tvFrameStr)] autorelease];
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
    // when ok clicked, show share to Weibo
    if (nil == delegate) {
        return;
    }
    
    self.savedImage = [self screenshot:tplMainView]; // screen shot
    
    if (isEdited) {
        UIImageWriteToSavedPhotosAlbum(self.savedImage, nil, nil, nil); // save to photo album
        isEdited=NO;
    }
    
    [self displayModalView];

}

- (void) segTextViewController: (id) sender{
    AKSegmentedControl *textSeg = (AKSegmentedControl *)sender;
    
    // show text editor view
    if (self.textEditor == nil) {
        self.textEditor = [[BGTextEditorViewController alloc] initWithNibName:@"BGTextEditorViewController" bundle:nil];
        [tplMainView addSubview:self.textEditor.view];
//        self.textEditor.delegate = self;
        self.textEditor.view.frame = CGRectMake(0, tplMainView.frame.size.height, tplMainView.frame.size.width, 52);
//        self.textEditor.view.center = CGPointMake(tplMainView.frame.size.width*0.5, tplMainView.frame.size.height-55*0.5);
        
    }
    
    
    if ([[textSeg selectedIndexes] count] == 0) {
        NSLog(@"Text Seg is de-selected");
        // remove border of text view
        UITextView *tv = [textViews objectAtIndex:lastSelectedTVIndex];
        tv.layer.borderWidth = 0.0f;
        // dismiss text editor view
        [UIView animateWithDuration:0.3f animations:^{
            self.textEditor.view.center = CGPointMake(tplMainView.frame.size.width*0.5, tplMainView.frame.size.height+55*0.5);
        }];
        
    }else{    
        int selectedTextSegIndex = [[textSeg selectedIndexes] firstIndex];
        NSLog(@"TextSegmentedControl: selected index %i", selectedTextSegIndex);
        // show border on text view
        UITextView *tv = [textViews objectAtIndex:selectedTextSegIndex];
        tv.layer.borderWidth = 3.0f;
        if (selectedTextSegIndex != lastSelectedTVIndex) {
            UITextView *tv = [textViews objectAtIndex:lastSelectedTVIndex];
            tv.layer.borderWidth = 0.0f;
        }
        lastSelectedTVIndex = selectedTextSegIndex;
        
        // pop up text editor
        [UIView animateWithDuration:0.8f animations:^{
            self.textEditor.view.center = CGPointMake(tplMainView.frame.size.width*0.5, tplMainView.frame.size.height+55*0.5);
            self.textEditor.view.center = CGPointMake(tplMainView.frame.size.width*0.5, tplMainView.frame.size.height-55*0.5);
        }];


    }
}

#pragma mark -
#pragma mark Private Methods
- (void) setupTextViewByDefaultValue: (UITextView **) tv atIndex: (int) index{
    (*tv).tag = index;
    (*tv).delegate = self;
    (*tv).backgroundColor= [UIColor lightGrayColor];
    (*tv).textColor = [UIColor blackColor];
    (*tv).font = [UIFont fontWithName:@"Arial" size:18.0];
    (*tv).scrollEnabled = NO;
    [(*tv).layer setCornerRadius: 6];
    [(*tv).layer setBorderColor:[[UIColor blueColor] CGColor]];
    [(*tv).layer setBorderWidth:0.0f]; // initially no border
    
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
        
        if (result != SLComposeViewControllerResultCancelled)
        {            
            AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"Weibo Message" message:output];
            [alert setDismissalStyle:AHAlertViewDismissalStyleZoomDown];
            [alert setCancelButtonTitle:@"OK" block:^(void){
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
#pragma mark Segmented Control Methods
- (void) setupSegmentedControl{
    [segmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    
    //    [segmentedControl setSeparatorImage:[UIImage imageNamed:@"sep_border_material.png.png"]];
    
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
    
    int totalTpl = [tplDetail count];
    NSMutableArray *buttonArray = [NSMutableArray arrayWithCapacity:totalTpl];
    for (int i=0; i<totalTpl; i++) {
        UIButton *button = [[UIButton alloc] init];
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
            [button setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
            [button setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
            [button setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
        }else if (i == totalTpl-1){
            // last one, must use right image
            [button setBackgroundImage:buttonBackgroundImageRight forState:UIControlStateNormal];
            [button setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
            [button setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
            [button setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateHighlighted|UIControlStateSelected)];
        }else{
            // rest use middle image
            [button setBackgroundImage:buttonBackgroundImageCenter forState:UIControlStateNormal];
            [button setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateHighlighted];
            [button setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateSelected];
            [button setBackgroundImage:buttonBackgroundImagePressedCenter forState:(UIControlStateHighlighted|UIControlStateSelected)];
        }
        
        
        
        [buttonArray addObject:button];
    }
    
    [segmentedControl setButtonsArray:buttonArray];
}

@end
