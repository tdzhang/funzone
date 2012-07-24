//
//  addAndViewCommentTVC.m
//  Fun
//
//  Created by Tongda Zhang on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "addAndViewCommentTVC.h"

@interface addAndViewCommentTVC ()

@end

@implementation addAndViewCommentTVC
@synthesize event_id=_event_id;
@synthesize shared_event_id=_shared_event_id;
@synthesize comments=_comments;

#pragma mark - self defined setter and getter
-(NSArray *)comments{
    if (!_comments) {
        _comments=[[NSArray alloc] init];
    }
    return _comments;
}

-(void)setComments:(NSArray *)comments{
    _comments=comments;
    [self.tableView reloadData];
}

#pragma mark - view life circle
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"count:%d",[self.imageUrls count]);
    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"commentTableViewCell";
    
    commentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"commentTableViewCell" owner:nil options:nil];
        
        for (UIView *view in views) {
            if([view isKindOfClass:[UITableViewCell class]])
            {
                cell = (commentTableViewCell*)view;
            }
        }
    }    
    //pending operation with the imageview of a cell cell.userPhotoImageView setImage:xxx
    eventComment *comment=[self.comments objectAtIndex:indexPath.row];
    cell.userNameLabel.text=[NSString stringWithFormat:@"%@",comment.user_name];
    cell.commentContentLabel.text=comment.content;
    cell.commentTimeLabel.text=comment.timestamp;
    [cell.userNameLabel setBackgroundColor:[UIColor greenColor]];
    [cell.commentTimeLabel setBackgroundColor:[UIColor yellowColor]];
    [cell.commentContentLabel setBackgroundColor:[UIColor redColor]];
    
    return cell;  				
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
