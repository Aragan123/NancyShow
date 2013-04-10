//
//  BGTableViewController.m
//  NancyShow
//
//  Created by Jeff Zhong on 2013/04/07.
//  Copyright (c) 2013 Brute Games Studio. All rights reserved.
//

#import "BGTableViewController.h"
#import "UIImageView+AFNetworking.h"
#import "JMWhenTapped.h"

@interface BGTableViewController ()

@end

@implementation BGTableViewController
@synthesize delegate, dataSource, isOnlineData;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.arrayView.itemSize = CGSizeMake(200, 200);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidUnload{
    dataSource=nil;
    
    [super viewDidUnload];
}

- (void) dealloc{
    delegate=nil;
    [dataSource release];
    
    [super dealloc];
}

#pragma mark - 
#pragma mark Public Methods
- (void) reloadDataSource:(NSArray *)ds isOnlineData:(BOOL)online{
    NSLog(@"reload Data Source in BGTableViewController");
    self.dataSource=ds;
    self.isOnlineData=online;
    [self.arrayView reloadData];
}

#pragma mark -
#pragma mark ATArrayViewDelegate methods
- (NSInteger)numberOfItemsInArrayView:(ATArrayView *)arrayView {
    return [self.dataSource count];
}

- (UIView *)viewForItemInArrayView:(ATArrayView *)arrayView atIndex:(NSInteger)index {
    UIView *itemView = (UIView *) [arrayView dequeueReusableItem];
    if (itemView == nil) {
        itemView = [[[UIView alloc] init] autorelease];
        itemView.backgroundColor = [UIColor clearColor];
    }
    
    // add tap guesture to call delegate method
    [itemView whenTapped:^{
        if (nil != delegate) {
            [delegate itemCellSelected:index];
        }
    }];
    
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.arrayView.itemSize.width, self.arrayView.itemSize.height)] autorelease];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading.jpg"]];
//    imageView.frame = CGRectMake(0, 0, self.arrayView.itemSize.width, self.arrayView.itemSize.height);
    NSString *imageURI = [self.dataSource objectAtIndex:index];
    NSLog(@"loadng imagURI: %@", imageURI);
    
    if (!isOnlineData){
        // local gallery
        imageView.image = [UIImage imageWithContentsOfFile:imageURI];
    }else{
        // online gallery
        [imageView setImageWithURL:[NSURL URLWithString:imageURI] placeholderImage:[UIImage imageNamed:@"loading.jpg"]];
    }
    
    [itemView addSubview:imageView];
    
    return itemView;
}

@end
