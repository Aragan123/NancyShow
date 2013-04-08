//
//  BGTplHomeViewController.m
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/07.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGTplHomeViewController.h"
#import "BGGlobalData.h"
#import "AKSegmentedControl.h"
#import "BGTableViewController.h"
#import "SVProgressHUD.h"
#import "AFImageRequestOperation.h"
#import "AFJSONRequestOperation.h"


@interface BGTplHomeViewController ()

@end

const int ONLINE_TPL_INDEX = 1;

@implementation BGTplHomeViewController
@synthesize delegate, isOnlineTpl, templateData, tableViewController, segControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithNibName:nibNameOrNil
                          bundle:nibBundleOrNil
                    templateData:[[BGGlobalData sharedData] diaryTemplates]
                     isOnlineTpl:NO
            ];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil templateData:(NSDictionary*)tplData isOnlineTpl:(BOOL)online{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.templateData = tplData;
        self.isOnlineTpl = online;
        [self constructTemplateArrays];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *backgroundPattern = [UIImage imageNamed:@"beauty_background.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];
    
    // add segmented control to bottom
    self.segControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(0,0, 2*103, 44)];
    self.segControl.center = CGPointMake(bottomImageView.center.x, bottomImageView.center.y+3);
    
    [segControl addTarget:self action:@selector(segmentedViewController:) forControlEvents:UIControlEventValueChanged];
    [segControl setSegmentedControlMode:AKSegmentedControlModeSticky];
    [segControl setSelectedIndex:0];
    [self setupSegmentedControl];
    
    [bottomBarView insertSubview:segControl aboveSubview:bottomImageView];
    
    // add table view
    self.tableViewController = [[BGTableViewController alloc] init];
    self.tableViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - bottomBarView.frame.size.height);
    self.tableViewController.delegate=self;
    self.tableViewController.isOnlineData = self.isOnlineTpl;
    self.tableViewController.dataSource = templateThumbnails;
    
    [self.view addSubview: self.tableViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload{
    templateData=nil;
    tableViewController=nil;
    templateThumbnails=nil;
    templateObjects=nil;
    segControl=nil;
    
    [bottomBarView release];
    bottomBarView = nil;
    [bottomImageView release];
    bottomImageView = nil;
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    
    [templateData release];
    [tableViewController release];
    [templateObjects release];
    [templateThumbnails release];
    
    [bottomBarView release];
    [segControl release];
    
    [bottomImageView release];
    [super dealloc];
}

#pragma mark - 
#pragma mark Control Methods and Private Methods
-(void) clickReturnHome:(id)sender{
    if (nil != delegate) {
        [delegate switchViewTo:kPageMain fromView:kPageDiaryHome];
    }
}

- (void) reloadDataWith: (NSDictionary*) tplData isOnlineTpl: (BOOL)online{
    NSLog(@"reload Data in BGTplHomeViewController");
    self.templateData = tplData;
    self.isOnlineTpl = online;
    [self constructTemplateArrays];
    // reload table view
    [self.tableViewController reloadDataSource:templateThumbnails isOnlineData:self.isOnlineTpl];
    
}

- (void) constructTemplateArrays{
    NSString *tplURI = [self.templateData objectForKey:@"TemplateURI"];
    NSArray *tplFiles = [self.templateData objectForKey:@"TemplateNames"];
    NSArray *tplThumbnails = [self.templateData objectForKey:@"TemplateThumbnails"];
    
    templateObjects = [[NSMutableArray alloc] initWithCapacity:[tplFiles count]];
    templateThumbnails = [[NSMutableArray alloc] initWithCapacity:[tplFiles count]];
    
    for (int i=0; i<tplFiles.count; i++){
        NSString *tplFile;
        NSString *tplThumbnail;
        
        if (!isOnlineTpl) {
            // local gallery
            tplFile = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@/%@", tplURI, [tplFiles objectAtIndex:i]];
            tplThumbnail = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@/%@", tplURI, [tplThumbnails objectAtIndex:i]];

        }else{
            // online gallery
            tplFile = [NSString stringWithFormat:@"%@/%@", tplURI, [tplFiles objectAtIndex:i]];
            tplThumbnail = [NSString stringWithFormat:@"%@/%@", tplURI, [tplThumbnails objectAtIndex:i]];
        }
        
        [templateObjects addObject:tplFile];
        [templateThumbnails addObject:tplThumbnail];
    }
    
}

#pragma mark -
#pragma mark Segmented Control set up
- (void) setupSegmentedControl{
    [segControl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    
    // normal images
    UIImage *buttonBackgroundImageLeft = [[UIImage imageNamed:@"btn_left_a.png"]
                                          resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
//    UIImage *buttonBackgroundImageCenter = [[UIImage imageNamed:@"btn_middle_a.png"]
//                                            resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
    UIImage *buttonBackgroundImageRight = [[UIImage imageNamed:@"btn_right_a.png"]
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 1.0, 0.0, 4.0)];
    // pressed images
    UIImage *buttonBackgroundImagePressedLeft = [[UIImage imageNamed:@"btn_left_b.png"]
                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
//    UIImage *buttonBackgroundImagePressedCenter = [[UIImage imageNamed:@"btn_middle_b.png"]
//                                                   resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
    UIImage *buttonBackgroundImagePressedRight = [[UIImage imageNamed:@"btn_right_b.png"]
                                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 1.0, 0.0, 4.0)];
    
    // construct segmented control buttons
    int totalGategories = 2;
    NSMutableArray *buttonArray = [NSMutableArray arrayWithCapacity:totalGategories];
    for (int i=0; i<totalGategories; i++) {
        UIButton *button = [[UIButton alloc] init];
        //        [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 5.0)];
        
        NSString *buttonTitle = @"Templates";
        if (i==1) {
            buttonTitle = @"More Online";
        }
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
        }else if (i == totalGategories-1){
            // last one, must use right image
            [button setBackgroundImage:buttonBackgroundImageRight forState:UIControlStateNormal];
            [button setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
            [button setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
            [button setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateHighlighted|UIControlStateSelected)];
        }
        
        [buttonArray addObject:button];
    }
    
    [segControl setButtonsArray:buttonArray];
}

- (void)segmentedViewController:(id)sender
{
    AKSegmentedControl *segment = (AKSegmentedControl *)sender;
    int selectedSegIndex = [[segment selectedIndexes] firstIndex];
    
    //    NSLog(@"SegmentedControl: Selected Index %@", [segControl selectedIndexes]);
    NSLog(@"SegmentedControl: selected index %i", selectedSegIndex);
    
    if (selectedSegIndex == ONLINE_TPL_INDEX) {
        // choose online template data
        // Need to retrieve online template data p-list/json file file with a HTTP call
        [SVProgressHUD showWithStatus:@"Connecting" maskType:SVProgressHUDMaskTypeGradient]; // show HUD
        // make http call
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kOnlineTemplateURI]];
        AFJSONRequestOperation *operation =
        [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                            // when success, dissimiss HUD and reload data with online template p-list/json
                                                            NSLog(@"Get JSON template list successfully, %@", JSON);
//                                                            NSLog(@"New URI: %@", [(NSDictionary*)JSON objectForKey:@"TemplateURI"]);
                                                            [SVProgressHUD dismiss];
                                                            [[BGGlobalData sharedData] setOnlineDiaryTemplates: [(NSDictionary*)JSON objectForKey:@"DiaryTemplates"]];
                                                            
                                                            [self reloadDataWith:[(NSDictionary*)JSON objectForKey:@"DiaryTemplates"] isOnlineTpl:YES];
                                                        }
                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                            NSLog(@"Network Error in online template home: %@", error);
                                                            // when fail, show an alert and stay where it is
                                                            [SVProgressHUD showErrorWithStatus:@"Network Error"];
                                                        }];
        [operation start];
        
    }else{
        // choose offiline/local template data
        [self reloadDataWith:[[BGGlobalData sharedData] diaryTemplates]
                 isOnlineTpl:NO];
    }
    
    
}


#pragma mark -
#pragma mark BGTableViewControllerDelegate method
- (void) itemCellSelected: (int) atIndex{
    // redirect to template edit page
    NSLog(@"Item Cell Selected: %i", atIndex);
    
    if (nil == delegate) {
        NSLog(@"BGTableViewControllerDelegate is not assigned");
        return;
    }
    
    NSString *tplImageURI = [templateObjects objectAtIndex:atIndex];
    NSLog(@"diary template image URI: %@", tplImageURI);
    
    if (!self.isOnlineTpl){
        // local template
        UIImage *tplImage = [UIImage imageWithContentsOfFile:tplImageURI];
        [[BGGlobalData sharedData] setDiaryTplImage:tplImage];
        
        [delegate switchViewTo:kPageDiary fromView:kPageDiaryHome];
    }else{
        // online template
        [SVProgressHUD showWithStatus:@"Downloading" maskType:SVProgressHUDMaskTypeGradient]; // show running HUD
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:tplImageURI]];
        AFImageRequestOperation *operation =
            [AFImageRequestOperation  imageRequestOperationWithRequest:request
                                                  imageProcessingBlock:^UIImage *(UIImage *image) {
                                                                    // do some process on image before return success block
                                                                    return image;
                                                                }
                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                    // dismiss HUD first
                                                                    [SVProgressHUD dismiss];
                                                                    [[BGGlobalData sharedData] setDiaryTplImage:image];
                                                                    
                                                                    [delegate switchViewTo:kPageDiary fromView:kPageDiaryHome]; // redirect to diary edit page
                                                                }
                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                    [SVProgressHUD showErrorWithStatus:@"Fail to Download"];
                                                                }
              ];
        
        [operation start];
    }
}

@end
