//
//  InviteTableViewController.m
//  OrangeParc
//
//  Created by Tongda Zhang on 8/5/12.
//
//



//need delegate method and variable 

#import "InviteTableViewController.h"

@interface InviteTableViewController ()
@property(nonatomic,strong)NSArray *contacts;
@property(nonatomic,strong)NSArray *dividedContacts;//divided it into select and not select 2 parts
@property(nonatomic,strong)NSMutableArray *searchResultContacts; //used to contain Search Bar search result
-(void)getTheDividedContacts;//using contacts and alreadySelectedContacts to generate this contact
@end

@implementation InviteTableViewController
@synthesize dividedContacts = _dividedContacts;
@synthesize contacts = _contacts;
@synthesize alreadySelectedContacts=_alreadySelectedContacts;
@synthesize searchResultContacts=_searchResultContacts;
@synthesize lastReceivedJson=_lastReceivedJson;
@synthesize delegate=_delegate;


#pragma mark - self defined setter and getter
-(NSArray *)lastReceivedJson{
    if (!_lastReceivedJson) {
        _lastReceivedJson=[NSArray array];
    }
    return _lastReceivedJson;
}

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


#pragma mark - View Life circle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //use the last result first;
    self.contacts=[[InviteFriendObject generateProfileInfoElementArrayFromJson:self.lastReceivedJson] mutableCopy];
    [self getTheDividedContacts];
    [self.tableView reloadData];
    NSLog(@"%d",[self.contacts count]);
    //query the user profile information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/followings?auth_token=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"]]];
    
    NSLog(@"request following:%@",url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    __block ASIFormDataRequest *block_request=request;
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [block_request responseString];
        NSLog(@"%@",responseString);
        NSError *error;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:[block_request responseData] options:kNilOptions error:&error];
        if (![[NSString stringWithFormat:@"%@",json] isEqualToString:[NSString stringWithFormat:@"%@",self.lastReceivedJson]]) {
            //if there is a difference, start to fetch data
            self.lastReceivedJson=[json copy];
            [self.delegate UpdateLastReceivedInviteFriendJson:[json copy]];
            self.contacts=[[InviteFriendObject generateProfileInfoElementArrayFromJson:json] mutableCopy];
            NSLog(@"%d",[self.contacts count]);
            [self getTheDividedContacts];
            [self.tableView reloadData];
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [block_request error];
        NSLog(@"%@",error.description);
        UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:@"Error getting user profile" message: [NSString stringWithFormat:@"Error: %@",error.description ] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        notsuccess.delegate=self;
        [notsuccess show];
    }];
    //add login auth_token
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];

    //set the contacts and divided contacts
    
    
    
}



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


#pragma mark - self defined button clilcked
/////---------------------------------------------->
/*
- (IBAction)InviteButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.preDefinedMode isEqualToString:@"email"]) {
        [self.delegate StartComposeEmail];
    } else if([self.preDefinedMode isEqualToString:@"message"]) {
        [self.delegate StartComposeMessage];
    }
}
*/


#pragma mark - implement self defined internal class method
-(void)getTheDividedContacts{
    NSMutableArray *tempContacts=[NSMutableArray array];
    for (InviteFriendObject* contact in self.contacts) {
        if (![self.alreadySelectedContacts objectForKey:contact.user_name]) {
            [tempContacts addObject:contact];
        }
    }
    for (NSString* key in [self.alreadySelectedContacts allKeys]) {
        InviteFriendObject* contact=[self.alreadySelectedContacts objectForKey:key];
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
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return [self.searchResultContacts count];
    }
    //else: the tabel view is used to show the ordinary address book information
    else{
        return [self.dividedContacts count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        
        static NSString *CellIdentifier = @"InviteTableViewCell";
        
        InviteFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"InviteTableViewCell" owner:nil options:nil];

            for (UIView *view in views) {
                if([view isKindOfClass:[UITableViewCell class]])
                {
                    cell = (InviteFriendTableViewCell*)view;
                }
            }
        }
        InviteFriendObject* friend=[self.searchResultContacts objectAtIndex:indexPath.row];
        [cell.user_name_label setText:friend.user_name];
        ////////////////////////
        NSURL *url=[NSURL URLWithString:friend.user_pic];
        if (![Cache isURLCached:url]) {
            //using high priority queue to fetch the image
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
                //get the image data
                NSData * imageData = nil;
                imageData = [[NSData alloc] initWithContentsOfURL: url];
                
                if ( imageData == nil ){
                    //if the image data is nil, the image url is not reachable. using a default image to replace that
                    //NSLog(@"downloaded %@ error, using a default image",url);
                    UIImage *image=[UIImage imageNamed:@"smile_64.png"];
                    imageData=UIImagePNGRepresentation(image);
                    if(imageData){
                        dispatch_async( dispatch_get_main_queue(),^{
                            [Cache addDataToCache:url withData:imageData];
                            [cell.user_profile_imageview setImage:image];
                        });
                    }
                }
                else {
                    //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                    //NSLog(@"downloaded %@",url);
                    if(imageData){
                        dispatch_async( dispatch_get_main_queue(),^{
                            [Cache addDataToCache:url withData:imageData];
                            [cell.user_profile_imageview setImage:[UIImage imageWithData:imageData]];
                        });
                    }
                }
            });
        }
        else {
            dispatch_async( dispatch_get_main_queue(),^{
                [cell.user_profile_imageview setImage:[UIImage imageWithData:[Cache getCachedData:url]]];
            });
        }
        ///////////////////////
        
        //[cell setSelected:YES];
        return cell;
    }
    //else: the tabel view is used to show the ordinary address book information
    else{
        static NSString *CellIdentifier = @"InviteTableViewCell";
        
        InviteFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"InviteTableViewCell" owner:nil options:nil];
            
            for (UIView *view in views) {
                if([view isKindOfClass:[UITableViewCell class]])
                {
                    cell = (InviteFriendTableViewCell*)view;
                }
            }
        }
        // Configure the cell...here already deal with the situation that user lacking information (like phone number or email)
        InviteFriendObject* contact=[self.dividedContacts objectAtIndex:indexPath.row];

        [cell.user_name_label setText:contact.user_name];
        
        ////////////////////////
        NSURL *url=[NSURL URLWithString:contact.user_pic];
        if (![Cache isURLCached:url]) {
            //using high priority queue to fetch the image
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
                //get the image data
                NSData * imageData = nil;
                imageData = [[NSData alloc] initWithContentsOfURL: url];
                
                if ( imageData == nil ){
                    //if the image data is nil, the image url is not reachable. using a default image to replace that
                    //NSLog(@"downloaded %@ error, using a default image",url);
                    UIImage *image=[UIImage imageNamed:@"smile_64.png"];
                    imageData=UIImagePNGRepresentation(image);
                    if(imageData){
                        dispatch_async( dispatch_get_main_queue(),^{
                            [Cache addDataToCache:url withData:imageData];
                            [cell.user_profile_imageview setImage:image];
                        });
                    }
                }
                else {
                    //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                    //NSLog(@"downloaded %@",url);
                    if(imageData){
                        dispatch_async( dispatch_get_main_queue(),^{
                            [Cache addDataToCache:url withData:imageData];
                            [cell.user_profile_imageview setImage:[UIImage imageWithData:imageData]];
                        });
                    }
                }
            });
        }
        else {
            dispatch_async( dispatch_get_main_queue(),^{
                [cell.user_profile_imageview setImage:[UIImage imageWithData:[Cache getCachedData:url]]];
            });
        }
        ///////////////////////
        if ([self.alreadySelectedContacts objectForKey:contact.user_name]) {
            //[cell setSelected:YES animated:YES];
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    [self.searchResultContacts removeAllObjects];
    searchString=[searchString uppercaseString];
    for (InviteFriendObject* contact in self.dividedContacts) {
        NSString *nameText=contact.user_name;
        nameText=[nameText uppercaseString];
        NSString *keyword=[searchString stringByReplacingOccurrencesOfString:@"," withString:@" "];
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
        if ([self.delegate conformsToProtocol:@protocol(FeedBackInviteFriendChange)]) {
            InviteFriendObject *person = [self.searchResultContacts objectAtIndex:indexPath.row];
            
            NSMutableDictionary *alreadySelected=[self.alreadySelectedContacts mutableCopy];
            //get the key value from the name of the person
            NSString *nameText=person.user_name;
            //add the object in the alreadySelected Dictionary
            [alreadySelected setObject:person forKey:nameText];
            self.alreadySelectedContacts = alreadySelected;
            //activate the delegate method
            [self.delegate AddContactInformtionToPeopleList:person];
           
            [self.searchDisplayController setActive:NO];
            //after change, update the table view
            [self getTheDividedContacts];
            [self.tableView reloadData];
        }
        
    }
    else {
        if ([self.delegate conformsToProtocol:@protocol(FeedBackInviteFriendChange)]) {
            InviteFriendObject *person = [self.dividedContacts objectAtIndex:indexPath.row];
            
            NSMutableDictionary *alreadySelected=[self.alreadySelectedContacts mutableCopy];
            //get the key value from the name of the person
            NSString *nameText=person.user_name;
            //add the object in the alreadySelected Dictionary
            [alreadySelected setObject:person forKey:nameText];
            self.alreadySelectedContacts = alreadySelected;
            
            //activate the delegate method
            [self.delegate AddContactInformtionToPeopleList:person];
            
            [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];

        }
    }
     
}
-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate conformsToProtocol:@protocol(FeedBackInviteFriendChange)]) {
        InviteFriendObject *person = [self.dividedContacts objectAtIndex:indexPath.row];
        
        NSMutableDictionary *alreadySelected=[self.alreadySelectedContacts mutableCopy];
        //get the key value from the name of the person
        NSString *nameText=person.user_name;
        //add the object in the alreadySelected Dictionary
        [alreadySelected removeObjectForKey:nameText];
        self.alreadySelectedContacts = alreadySelected;
        
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
        //activate the delegate method
        [self.delegate DeleteContactInformtionToPeopleList:person];

    }
     
}
@end
