//
//  BGTplHomeViewController.m
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/07.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGTplHomeViewController.h"
#import "BGGlobalData.h"

@interface BGTplHomeViewController ()

@end

@implementation BGTplHomeViewController
@synthesize delegate, isOnlineTpl, templateData, tableViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithNibName:nibNameOrNil
                          bundle:nibBundleOrNil
                    templateData:[BGGlobalData sharedData].diaryTemplates
                     isOnlineTpl:NO
            ];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil templateData:(NSDictionary*)tplData isOnlineTpl:(BOOL)online{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.templateData = tplData;
        self.isOnlineTpl = online;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
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
    
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    
    [templateData release];
    [tableViewController release];
    [templateObjects release];
    [templateThumbnails release];
    
    [super dealloc];
}

#pragma mark - 
#pragma mark Public Methods
-(void) clickReturnHome:(id)sender{
    if (nil != delegate) {
        [delegate switchViewTo:kPageMain fromView:kPageDiaryHome];
    }
}

#pragma mark -
#pragma mark BGTableViewControllerDelegate method
- (void) itemCellSelected: (int) atIndex{
    // redirect to template edit page
}

@end
