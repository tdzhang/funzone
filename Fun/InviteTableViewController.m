//
//  InviteTableViewController.m
//  OrangeParc
//
//  Created by Tongda Zhang on 8/5/12.
//
//



//need delegate method and variable 

#import "InviteTableViewController.h"
#import "GlobalConstant.h"

@interface InviteTableViewController ()
@property(nonatomic,strong)NSArray *contacts;
@property(nonatomic,strong)NSArray *addressbook_contacts;
@property(nonatomic,strong)NSArray *dividedContacts;//divided it into select and not select 2 parts
@property(nonatomic,strong)NSArray *addressbook_dividedContacts;
@property(nonatomic,strong)NSMutableArray *searchResultContacts; //used to contain Search Bar search result
@property(nonatomic,strong)NSMutableArray *addressbook_searchResultContacts;
-(void)getTheDividedContacts;//using contacts and alreadySelectedContacts to generate this contact
@end

@implementation InviteTableViewController
@synthesize dividedContacts = _dividedContacts;
@synthesize addressbook_dividedContacts=_addressbook_dividedContacts;
@synthesize contacts = _contacts;
@synthesize addressbook_contacts=_addressbook_contacts;
@synthesize alreadySelectedContacts=_alreadySelectedContacts;
@synthesize addressbook_alreadySelectedContacts=_addressbook_alreadySelectedContacts;
@synthesize searchResultContacts=_searchResultContacts;
@synthesize addressbook_searchResultContacts=_addressbook_searchResultContacts;
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

-(NSMutableArray*)addressbook_searchResultContacts{
    if (!_addressbook_searchResultContacts) {
        _addressbook_searchResultContacts=[NSMutableArray array];
    }
    return _addressbook_searchResultContacts;
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
    
    if (!self.addressbook_contacts) {
        //get the address book information (only the user with email infomation)
        //Get in the data from the address book
        NSMutableArray * constactsMutable = [NSMutableArray array];
        ABAddressBookRef addressBook = ABAddressBookCreate( );
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
        CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
        for (int i=0; i<numberOfPeople; i++) {
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            //get phone number list
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
            NSMutableArray *phoneNumbersList = [ [ NSMutableArray alloc ] init ];
            CFIndex nPhoneNumbers = ABMultiValueGetCount(phoneNumbers);
            for(int i=0;i<nPhoneNumbers;i++) {
                NSString *phoneNumber = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneNumbers, i);
                [ phoneNumbersList addObject: phoneNumber ];
            }
            //get email list
            ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
            NSMutableArray *emailList = [ [ NSMutableArray alloc ] init ];
            CFIndex nemail = ABMultiValueGetCount(emails);
            for(int i=0;i<nemail;i++) {
                NSString *email = (__bridge NSString *)ABMultiValueCopyValueAtIndex(emails, i);
                [ emailList addObject: email ];
            }
            //get name
            NSString *firstName = (__bridge NSString *) ABRecordCopyValue(person, kABPersonFirstNameProperty) ;
            NSString *lastName = (__bridge NSString *) ABRecordCopyValue(person, kABPersonLastNameProperty) ;
            //NSLog(@"%@",firstName);
            //NSLog(@"%@",lastName);
            //NSLog(@"%@",[phoneNumbersList objectAtIndex:0]);
            //NSLog(@"%@",[emailList objectAtIndex:0]);
            
            UserContactObject *contact = [UserContactObject new];
            contact.firstName=firstName;
            contact.lastName=lastName;
            contact.phone=[phoneNumbersList copy];
            contact.email=[emailList copy];
            if ([contact.email count]>0) {
                [constactsMutable addObject:contact];
            }
            
            
        }
        //set the contacts property
        self.addressbook_contacts = [constactsMutable copy];
    }
    [self getTheDividedAddressBookContacts];
    
    
    //------------>get already registered users friend
    //use the last result first;
    self.contacts=[[InviteFriendObject generateProfileInfoElementArrayFromJson:self.lastReceivedJson] mutableCopy];
    [self getTheDividedContacts];
    [self.tableView reloadData];
    NSLog(@"%d",[self.contacts count]);
    //query the user profile information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/friends?auth_token=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"]]];
    
    NSLog(@"request following:%@",url);

    //set the contacts and divided contacts
    
    ///////////////////////////////////////////////////////////////////////////
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"GET"];
        [request startSynchronous];
        
        int code=[request responseStatusCode];
        NSLog(@"code:%d",code);
        
        dispatch_async( dispatch_get_main_queue(),^{
            if (code==200) {
                //success
                NSString *responseString = [request responseString];
                NSLog(@"%@",responseString);
                NSError *error;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
                if (![[NSString stringWithFormat:@"%@",json] isEqualToString:[NSString stringWithFormat:@"%@",self.lastReceivedJson]]) {
                    //if there is a difference, start to fetch data
                    self.lastReceivedJson=[json copy];
                    [self.delegate UpdateLastReceivedInviteFriendJson:[json copy]];
                    self.contacts=[[InviteFriendObject generateProfileInfoElementArrayFromJson:json] mutableCopy];
                    NSLog(@"%d",[self.contacts count]);
                    [self getTheDividedContacts];
                    [self.tableView reloadData];
                }
            }
            
        });
        
    });
    
    
}



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.delegate startInviteFriendWithEventID];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
//                                   initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
//                                   target:nil action:nil];
//    backButton.tintColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dismissThisPage)];

    //self.navigationItem.rightBarButtonItem.tintColor=[UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor blueColor];
    
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
-(void)dismissThisPage{
    [self.navigationController popViewControllerAnimated:YES];
}


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

-(void)getTheDividedAddressBookContacts{
    NSMutableArray *tempContacts=[NSMutableArray array];
    for (UserContactObject* contact in self.addressbook_contacts) {
        NSString *nameText=@"";
        if (contact.firstName) {
            nameText=[nameText stringByAppendingFormat:@"%@",contact.firstName];
            if (contact.lastName) {
                nameText=[nameText stringByAppendingFormat:@" %@",contact.lastName];
            }
        }
        else if(contact.lastName){
            nameText=[nameText stringByAppendingFormat:@"%@",contact.lastName];
        }
        if (![self.addressbook_alreadySelectedContacts objectForKey:nameText]) {
            [tempContacts addObject:contact];
        }
    }
    for (NSString* key in [self.addressbook_alreadySelectedContacts allKeys]) {
        UserContactObject* contact=[self.addressbook_alreadySelectedContacts objectForKey:key];
        [tempContacts insertObject:contact atIndex:0];
    }
    self.addressbook_dividedContacts=tempContacts;
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"Friends";
    }
    else if(section == 1)
    {
        return @"Contacts";
    }
    return @"Other";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
            return [self.searchResultContacts count];
        }
        //else: the tabel view is used to show the ordinary address book information
        else{
            return [self.dividedContacts count];
        }
    }
    else if (section==1){
        if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
            return [self.addressbook_searchResultContacts count];
        }
        //else: the tabel view is used to show the ordinary address book information
        else{
            return [self.addressbook_dividedContacts count];
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
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
                        UIImage *image=[UIImage imageNamed:DEFAULT_PROFILE_IMAGE_REPLACEMENT];
                        imageData=UIImagePNGRepresentation(image);
                        if(imageData){
                            dispatch_async( dispatch_get_main_queue(),^{
                                [Cache addDataToCache:url withData:imageData];
                                [cell.user_profile_imageview setImage:image];
                                
                                cell.user_profile_imageview .layer.cornerRadius = 4;
                                cell.user_profile_imageview .clipsToBounds = YES;
                                [cell.user_profile_imageview setContentMode:UIViewContentModeScaleAspectFill];
                                cell.user_profile_imageview .layer.borderColor = [[UIColor darkGrayColor] CGColor];
                                cell.user_profile_imageview .layer.borderWidth = 1;
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
                                
                                cell.user_profile_imageview .layer.cornerRadius = 4;
                                cell.user_profile_imageview .clipsToBounds = YES;
                                [cell.user_profile_imageview setContentMode:UIViewContentModeScaleAspectFill];
                                cell.user_profile_imageview .layer.borderColor = [[UIColor darkGrayColor] CGColor];
                                cell.user_profile_imageview .layer.borderWidth = 1;
                            });
                        }
                    }
                });
            }
            else {
                dispatch_async( dispatch_get_main_queue(),^{
                    [cell.user_profile_imageview setImage:[UIImage imageWithData:[Cache getCachedData:url]]];
                    
                    cell.user_profile_imageview .layer.cornerRadius = 4;
                    cell.user_profile_imageview .clipsToBounds = YES;
                    [cell.user_profile_imageview setContentMode:UIViewContentModeScaleAspectFill];
                    cell.user_profile_imageview .layer.borderColor = [[UIColor darkGrayColor] CGColor];
                    cell.user_profile_imageview .layer.borderWidth = 1;
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
                        UIImage *image=[UIImage imageNamed:DEFAULT_PROFILE_IMAGE_REPLACEMENT];
                        imageData=UIImagePNGRepresentation(image);
                        if(imageData){
                            dispatch_async( dispatch_get_main_queue(),^{
                                [Cache addDataToCache:url withData:imageData];
                                [cell.user_profile_imageview setImage:image];
                                cell.user_profile_imageview .layer.cornerRadius = 4;
                                cell.user_profile_imageview .clipsToBounds = YES;
                                [cell.user_profile_imageview setContentMode:UIViewContentModeScaleAspectFill];
                                cell.user_profile_imageview .layer.borderColor = [[UIColor darkGrayColor] CGColor];
                                cell.user_profile_imageview .layer.borderWidth = 1;
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
                                cell.user_profile_imageview .layer.cornerRadius = 4;
                                cell.user_profile_imageview .clipsToBounds = YES;
                                [cell.user_profile_imageview setContentMode:UIViewContentModeScaleAspectFill];
                                cell.user_profile_imageview .layer.borderColor = [[UIColor darkGrayColor] CGColor];
                                cell.user_profile_imageview .layer.borderWidth = 1;
                            });
                        }
                    }
                });
            }
            else {
                dispatch_async( dispatch_get_main_queue(),^{
                    [cell.user_profile_imageview setImage:[UIImage imageWithData:[Cache getCachedData:url]]];
                    cell.user_profile_imageview .layer.cornerRadius = 4;
                    cell.user_profile_imageview .clipsToBounds = YES;
                    [cell.user_profile_imageview setContentMode:UIViewContentModeScaleAspectFill];
                    cell.user_profile_imageview .layer.borderColor = [[UIColor darkGrayColor] CGColor];
                    cell.user_profile_imageview .layer.borderWidth = 1;
                });
            }
            ///////////////////////
            if ([self.alreadySelectedContacts objectForKey:contact.user_name]) {
                //[cell setSelected:YES animated:YES];
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                if(contact.alreadyInvited){
                    //this person is already invited last time, you can not edit it
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                }
            }
            else{
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
            return cell;
        }
    }
    else{//else if it is address book contact
        if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
            static NSString *CellIdentifier = @"MysearchResultDisplay";
            
            UITableViewCell *cell = [tableView
                                     dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]
                        initWithStyle:UITableViewCellStyleSubtitle //the style of the cell
                        reuseIdentifier:CellIdentifier] ;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.font=  [UIFont fontWithName: @"Arial" size: 14.0 ];
            cell.detailTextLabel.font=  [UIFont fontWithName: @"Arial" size: 14.0 ];
            
            UserContactObject* contact=[self.addressbook_searchResultContacts objectAtIndex:indexPath.row];
            NSString *nameText=@"";
            if (contact.firstName) {
                nameText=[nameText stringByAppendingFormat:@"%@",contact.firstName];
                if (contact.lastName) {
                    nameText=[nameText stringByAppendingFormat:@" %@",contact.lastName];
                }
            }
            else if(contact.lastName){
                nameText=[nameText stringByAppendingFormat:@"%@",contact.lastName];
            }
            [cell.textLabel setText:nameText];
            
                if ([contact.email count]>0) {
                    [cell.detailTextLabel setText:[contact.email objectAtIndex:0]];
                }
                else {
                    [cell.detailTextLabel setText:@"No Email Information Found."];
                }
            
            //[cell setSelected:YES];
            return cell;
        }
        //else: the tabel view is used to show the ordinary address book information
        else{
            static NSString *CellIdentifier = @"CustomContactInfo";
            
            
            MyContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"CustonContactInfoView" owner:nil options:nil];
                
                for (UIView *view in views) {
                    if([view isKindOfClass:[UITableViewCell class]])
                    {
                        cell = (MyContactsTableViewCell*)view;
                    }
                }
            }
            
            cell.textLabel.font=  [UIFont fontWithName: @"Arial" size: 10.0 ];
            cell.detailTextLabel.font=  [UIFont fontWithName: @"Arial" size: 10.0 ];
            
            // Configure the cell...here already deal with the situation that user lacking information (like phone number or email)
            UserContactObject* contact=[self.addressbook_dividedContacts objectAtIndex:indexPath.row];
            NSString *nameText=@"";
            if (contact.firstName) {
                nameText=[nameText stringByAppendingFormat:@"%@",contact.firstName];
                if (contact.lastName) {
                    nameText=[nameText stringByAppendingFormat:@" %@",contact.lastName];
                }
            }
            else if(contact.lastName){
                nameText=[nameText stringByAppendingFormat:@"%@",contact.lastName];
            }
            
            cell.userName.text= nameText;
            
                if ([contact.email count]>0) {
                    [cell.userInfo setText:[contact.email objectAtIndex:0]];
                }
                else {
                    [cell.userInfo setText:@"No Email Information Found."];
                }

            
            if ([self.addressbook_alreadySelectedContacts objectForKey:nameText]) {
                //[cell setSelected:YES animated:YES];
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 55;
    } else {
        return 55;
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
    NSString *keyword=[searchString stringByReplacingOccurrencesOfString:@"," withString:@" "];
    NSArray* keywords=[keyword componentsSeparatedByString:@" "];
    for (InviteFriendObject* contact in self.dividedContacts) {
        NSString *nameText=contact.user_name;
        nameText=[nameText uppercaseString];
        
        BOOL flag = YES;
        for (NSString* word in keywords) {
            if (([nameText rangeOfString:word].length <= 0)&&word.length>0) {
                flag=NO;
                break;
            }
        }
        if(flag)[self.searchResultContacts addObject:contact];
    }
    
    
    [self.addressbook_searchResultContacts removeAllObjects];
    for (UserContactObject* contact in self.addressbook_dividedContacts) {
        NSString *nameText=@"";
        if (contact.firstName) {
            nameText=[nameText stringByAppendingFormat:@"%@",contact.firstName];
            if (contact.lastName) {
                nameText=[nameText stringByAppendingFormat:@" %@",contact.lastName];
            }
        }
        else if(contact.lastName){
            nameText=[nameText stringByAppendingFormat:@"%@",contact.lastName];
        }
        nameText=[nameText uppercaseString];
        NSLog(@"%@",nameText);
        BOOL flag = YES;
        for (NSString* word in keywords) {
            if (([nameText rangeOfString:word].length <= 0)&&word.length>0) {
                flag=NO;
                break;
            }
        }
        if(flag)[self.addressbook_searchResultContacts addObject:contact];
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
    if (indexPath.section==0) {
        if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
            if ([self.delegate conformsToProtocol:@protocol(FeedBackInviteFriendChange)]) {
                InviteFriendObject *person = [self.searchResultContacts objectAtIndex:indexPath.row];
                if(person.alreadyInvited){
                    //this person is already invited last time, you can not edit it
                    return;
                }
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
    else {
        if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
            if ([self.delegate conformsToProtocol:@protocol(FeedBackInviteFriendChange)]) {
                UserContactObject *person = [self.addressbook_searchResultContacts objectAtIndex:indexPath.row];
                
                NSMutableDictionary *alreadySelected=[self.addressbook_alreadySelectedContacts mutableCopy];
                //get the key value from the name of the person
                NSString *nameText=@"";
                if (person.firstName) {
                    nameText=[nameText stringByAppendingFormat:@"%@",person.firstName];
                    if (person.lastName) {
                        nameText=[nameText stringByAppendingFormat:@" %@",person.lastName];
                    }
                }
                else if(person.lastName){
                    nameText=[nameText stringByAppendingFormat:@"%@",person.lastName];
                }
                //add the object in the alreadySelected Dictionary
                [alreadySelected setObject:person forKey:nameText];
                self.addressbook_alreadySelectedContacts = alreadySelected;
                //activate the delegate method
                

                [self.delegate AddAddressBookContactInformtionToPeopleList:person];
                
                [self.searchDisplayController setActive:NO];
                //after change, update the table view
                [self getTheDividedAddressBookContacts];
                [self.tableView reloadData];
            }
            
        }
        else {
            if ([self.delegate conformsToProtocol:@protocol(FeedBackInviteFriendChange)]) {
                UserContactObject *person = [self.addressbook_dividedContacts objectAtIndex:indexPath.row];
                
                
                NSLog(@"%@",person.firstName);
                NSLog(@"%@",person.lastName);
                NSLog(@"%@",[person.email objectAtIndex:0]);

                NSMutableDictionary *alreadySelected=[self.addressbook_alreadySelectedContacts mutableCopy];
                //get the key value from the name of the person
                NSString *nameText=@"";
                if (person.firstName) {
                    nameText=[nameText stringByAppendingFormat:@"%@",person.firstName];
                    if (person.lastName) {
                        nameText=[nameText stringByAppendingFormat:@" %@",person.lastName];
                    }
                }
                else if(person.lastName){
                    nameText=[nameText stringByAppendingFormat:@"%@",person.lastName];
                }
                //add the object in the alreadySelected Dictionary
                [alreadySelected setObject:person forKey:nameText];
                self.addressbook_alreadySelectedContacts = alreadySelected;
                
                //activate the delegate method
                [self.delegate AddAddressBookContactInformtionToPeopleList:person];

            }
        }
    }
    
     
}
-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        if ([self.delegate conformsToProtocol:@protocol(FeedBackInviteFriendChange)]) {
            InviteFriendObject *person = [self.dividedContacts objectAtIndex:indexPath.row];
            
            if(person.alreadyInvited){
                //this person is already invited last time, you can not edit it
                UIAlertView *alreadyInvited = [[UIAlertView alloc] initWithTitle:nil message: [NSString stringWithFormat:@"You have already invited him/her before."] delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alreadyInvited show];
                
                [[tableView cellForRowAtIndexPath:indexPath] setSelected:YES];
                return;
            }
            
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
    else{
        if ([self.delegate conformsToProtocol:@protocol(FeedBackInviteFriendChange)]) {
            UserContactObject *person = [self.addressbook_dividedContacts objectAtIndex:indexPath.row];
            
            NSMutableDictionary *alreadySelected=[self.addressbook_alreadySelectedContacts mutableCopy];
            //get the key value from the name of the person
            NSString *nameText=@"";
            if (person.firstName) {
                nameText=[nameText stringByAppendingFormat:@"%@",person.firstName];
                if (person.lastName) {
                    nameText=[nameText stringByAppendingFormat:@" %@",person.lastName];
                }
            }
            else if(person.lastName){
                nameText=[nameText stringByAppendingFormat:@"%@",person.lastName];
            }
            //add the object in the alreadySelected Dictionary
            [alreadySelected removeObjectForKey:nameText];
            self.addressbook_alreadySelectedContacts = alreadySelected;
            //activate the delegate method
            [self.delegate DeleteAddressBookContactInformtionToPeopleList:person];
        }
    }
}
@end
