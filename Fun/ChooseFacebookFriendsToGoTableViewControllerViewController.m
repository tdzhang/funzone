//
//  ChooseFacebookFriendsToGoTableViewControllerViewController.m
//  Fun
//
//  Created by Tongda Zhang on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChooseFacebookFriendsToGoTableViewControllerViewController.h"

@interface ChooseFacebookFriendsToGoTableViewControllerViewController ()
@property(nonatomic,strong)NSArray *contacts;
@property(nonatomic,strong)NSArray *dividedContacts;//divided it into select and not select 2 parts
@property(nonatomic,strong)NSMutableArray *searchResultContacts; //used to contain Search Bar search result
-(void)getTheDividedContacts;//using contacts and alreadySelectedContacts to generate this contact
@end

@implementation ChooseFacebookFriendsToGoTableViewControllerViewController
@synthesize dividedContacts = _dividedContacts;
@synthesize contacts = _contacts;
@synthesize delegate = _delegate;
@synthesize alreadySelectedContacts=_alreadySelectedContacts;
@synthesize searchResultContacts=_searchResultContacts;

#pragma mark - self defined setter and getter
-(NSMutableArray*)searchResultContacts{
    if (!_searchResultContacts) {
        _searchResultContacts=[NSMutableArray array];
    }
    return _searchResultContacts;
}

-(void)setSearchResultContacts:(NSMutableArray *)searchResultContacts{
    if (![_searchResultContacts isEqualToArray:searchResultContacts]) {
        _searchResultContacts=searchResultContacts;
    }
}

-(NSArray*)dividedContacts{
    if (!_dividedContacts) {
        _dividedContacts=[[NSArray alloc] initWithArray:nil];
    }
    return _dividedContacts;
}

-(void)setDividedContacts:(NSArray *)dividedContacts{
    if (![_dividedContacts isEqualToArray:dividedContacts]) {
        _dividedContacts=dividedContacts;
    }
}

-(NSDictionary*)alreadySelectedContacts{
    if(_alreadySelectedContacts==nil){
        _alreadySelectedContacts=[[NSDictionary alloc] init];
    }
    return _alreadySelectedContacts;
}
-(void)setAlreadySelectedContacts:(NSDictionary *)alreadySelectedContacts{
    _alreadySelectedContacts=alreadySelectedContacts;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //do the preload stuff
    //[self getTheDividedContacts];
    FunAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithGraphPath:@"me/friends" andDelegate:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - facebook related protocal implement
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
    NSLog(@"Err details: %@", [error description]);
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    NSMutableArray * constactsMutable = [NSMutableArray array];
    
    
    NSMutableArray *friends = [[NSMutableArray alloc] initWithCapacity:1];
    NSArray *resultData = [result objectForKey:@"data"];
    if ([resultData count] > 0) {
        for (NSUInteger i=0; i<[resultData count]; i++) {
            [friends addObject:[resultData objectAtIndex:i]];
        }
        NSLog(@"you have %d friends",[friends count]);
        for (NSUInteger i=0; i<[resultData count] ; i++) {
            FacebookContactObject *contact=[[FacebookContactObject alloc] init];
            contact.facebook_name=[[friends objectAtIndex:i]objectForKey:@"name"];
            contact.facebook_id=[[friends objectAtIndex:i]objectForKey:@"id"];
            [constactsMutable addObject:contact];
        }
        self.contacts = [constactsMutable copy];
    } 
    [self getTheDividedContacts];
    [self.tableView reloadData];
}

#pragma mark - implement self defined internal class method
-(void)getTheDividedContacts{
    NSMutableArray *tempContacts=[NSMutableArray array];
    for (FacebookContactObject* contact in self.contacts) {
        NSString *nameText=contact.facebook_name;
        if (![self.alreadySelectedContacts objectForKey:nameText]) {
            [tempContacts addObject:contact];
        }
    }
    for (NSString* key in [self.alreadySelectedContacts allKeys]) {
        FacebookContactObject* contact=[self.alreadySelectedContacts objectForKey:key];
        [tempContacts insertObject:contact atIndex:0];
    }
    self.dividedContacts=tempContacts;
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
    // Return the number of rows in the section.
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return [self.searchResultContacts count];
    }
    //else: the tabel view is used to show the ordinary address book information
    else{
        return [self.dividedContacts count];
    }
    return 0;
}

//config each cell of the table view(both the search result and the ordinary address book showing)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //search result
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        static NSString *CellIdentifier = @"facebookContacts";
        
        UITableViewCell *cell = [tableView 
                                 dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] 
                    initWithStyle:UITableViewCellStyleDefault //the style of the cell
                    reuseIdentifier:CellIdentifier] ;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        FacebookContactObject* contact=[self.searchResultContacts objectAtIndex:indexPath.row];
        NSString *nameText=contact.facebook_name;

        [cell.textLabel setText:nameText];
        
        //[cell setSelected:YES];
        return cell;
    }
    //else: the tabel view is used to show the ordinary address book information
    else{
        static NSString *CellIdentifier = @"facebookContacts";
        
        UITableViewCell *cell = [tableView 
                                 dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] 
                    initWithStyle:UITableViewCellStyleDefault //the style of the cell
                    reuseIdentifier:CellIdentifier] ;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        // Configure the cell...here already deal with the situation that user lacking information (like phone number or email)
        FacebookContactObject* contact=[self.dividedContacts objectAtIndex:indexPath.row];
        NSString *nameText=contact.facebook_name;
        
        [cell.textLabel setText:nameText];
        
        if ([self.alreadySelectedContacts objectForKey:nameText]) {
            //[cell setSelected:YES animated:YES];
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            
        }
        return cell;
    }
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Implement the SearchBar and SearchBarDisplay
//search the result
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{  
    //no response
    [self.searchResultContacts removeAllObjects];
    for (FacebookContactObject* contact in self.dividedContacts) {
        NSString *nameText=contact.facebook_name;
        nameText=[nameText uppercaseString];
    
        NSString *keyword=[searchString stringByReplacingOccurrencesOfString:@"," withString:@" "];
        keyword = [keyword uppercaseString];
        NSArray* keywords=[keyword componentsSeparatedByString:@" "];
        BOOL flag = YES;
        for (NSString* word in keywords) {
            if (([nameText rangeOfString:word].length <= 0)&&word.length>0) {
                flag=NO;
                break;
            }
        }
        if(flag)[self.searchResultContacts addObject:contact];
    }
    return YES;
}

//Showing the location that User Searched, using Apple API
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setText:@""];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        
            FacebookContactObject *person = [self.searchResultContacts objectAtIndex:indexPath.row];
            
            NSMutableDictionary *alreadySelected=[self.alreadySelectedContacts mutableCopy];
 
            //get the key value from the name of the person
            NSString *nameText=person.facebook_name;
            //add the object in the alreadySelected Dictionary
            [alreadySelected setObject:person forKey:nameText];
            self.alreadySelectedContacts = alreadySelected;
            //activate the delegate method
            [self.delegate AddFacebookContactTogoInformtionToPeopleList:person];
            
            [self.searchDisplayController setActive:NO]; 
            //after change, update the table view
            [self getTheDividedContacts];
            [self.tableView reloadData];
    }
    else {
            FacebookContactObject *person = [self.dividedContacts objectAtIndex:indexPath.row];
            
            NSMutableDictionary *alreadySelected=[self.alreadySelectedContacts mutableCopy];
            //get the key value from the name of the person
            NSString *nameText=person.facebook_name;
            //add the object in the alreadySelected Dictionary
            [alreadySelected setObject:person forKey:nameText];
            self.alreadySelectedContacts = alreadySelected;
            //activate the delegate method
            [self.delegate AddFacebookContactTogoInformtionToPeopleList:person];
        }
     
}
-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

        FacebookContactObject *person = [self.dividedContacts objectAtIndex:indexPath.row];
        
        NSMutableDictionary *alreadySelected=[self.alreadySelectedContacts mutableCopy];
        //get the key value from the name of the person
        NSString *nameText=person.facebook_name;
        //add the object in the alreadySelected Dictionary
        [alreadySelected removeObjectForKey:nameText];
        self.alreadySelectedContacts = alreadySelected;
        //activate the delegate method
        [self.delegate DeleteFacebookContactTogoInformtionToPeopleList:person];
}

@end
