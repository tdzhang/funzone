//
//  ChoosePeopleToGoTableViewController.m
//  SimpleChoosePage
//
//  Created by Tongda Zhang on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChoosePeopleToGoTableViewController.h"


@interface ChoosePeopleToGoTableViewController()
@property(nonatomic,strong)NSArray *contacts;
@property(nonatomic,strong)NSArray *dividedContacts;//divided it into select and not select 2 parts
@property(nonatomic,strong)NSMutableArray *searchResultContacts; //used to contain Search Bar search result
-(void)getTheDividedContacts;//using contacts and alreadySelectedContacts to generate this contact
@end

@implementation ChoosePeopleToGoTableViewController
@synthesize dividedContacts = _dividedContacts;
@synthesize contacts = _contacts;
@synthesize delegate = _delegate;
@synthesize alreadySelectedContacts=_alreadySelectedContacts;
@synthesize searchResultContacts=_searchResultContacts;
@synthesize preDefinedMode=_preDefinedMode;


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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                   target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];

}

- (void)viewDidUnload
{
    [self setTitle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
        if ([self.preDefinedMode isEqualToString:@"email"]) {
            if ([contact.email count]>0) {
                [constactsMutable addObject:contact];
            }
        } else if([self.preDefinedMode isEqualToString:@"message"]) {
            if ([contact.phone count]>0) {
                [constactsMutable addObject:contact];
            }
        }
        
    }
    //set the contacts property
    self.contacts = [constactsMutable copy];
    [self getTheDividedContacts];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - self defined button clilcked
- (IBAction)InviteButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.preDefinedMode isEqualToString:@"email"]) {
        [self.delegate StartComposeEmail];
    } else if([self.preDefinedMode isEqualToString:@"message"]) {
        [self.delegate StartComposeMessage];
    }
}


#pragma mark - implement self defined internal class method
-(void)getTheDividedContacts{
    NSMutableArray *tempContacts=[NSMutableArray array];
    for (UserContactObject* contact in self.contacts) {
        NSString *nameText=@"";
        if (contact.firstName) {
            nameText=[nameText stringByAppendingFormat:@"%@",contact.firstName];
            if (contact.lastName) {
                nameText=[nameText stringByAppendingFormat:@", %@",contact.lastName];
            }
        }
        else if(contact.lastName){
            nameText=[nameText stringByAppendingFormat:@"%@",contact.lastName];
        }
        if (![self.alreadySelectedContacts objectForKey:nameText]) {
            [tempContacts addObject:contact];
        }
    }
    for (NSString* key in [self.alreadySelectedContacts allKeys]) {
        UserContactObject* contact=[self.alreadySelectedContacts objectForKey:key];
        [tempContacts insertObject:contact atIndex:0];
    }
    self.dividedContacts=tempContacts;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //if the tableview is used to show the search results
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return 1;
    }
    //else: the tabel view is used to show the ordinary address book information
    else{
        return 1; //temp set to 1
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return [self.searchResultContacts count];
    }
    //else: the tabel view is used to show the ordinary address book information
    else{
        return [self.dividedContacts count];
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
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self.searchResultContacts removeAllObjects];
    for (UserContactObject* contact in self.dividedContacts) {
        NSString *nameText=@"";
        if (contact.firstName) {
            nameText=[nameText stringByAppendingFormat:@"%@",contact.firstName];
            if (contact.lastName) {
                nameText=[nameText stringByAppendingFormat:@", %@",contact.lastName];
            }
        }
        else if(contact.lastName){
            nameText=[nameText stringByAppendingFormat:@"%@",contact.lastName];
        }
        
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
        if ([self.delegate conformsToProtocol:@protocol(FeedBackToCreateActivityChange)]) {
            UserContactObject *person = [self.searchResultContacts objectAtIndex:indexPath.row];
            
            NSMutableDictionary *alreadySelected=[self.alreadySelectedContacts mutableCopy];
            //get the key value from the name of the person
            NSString *nameText=@"";
            if (person.firstName) {
                nameText=[nameText stringByAppendingFormat:@"%@",person.firstName];
                if (person.lastName) {
                    nameText=[nameText stringByAppendingFormat:@", %@",person.lastName];
                }
            }
            else if(person.lastName){
                nameText=[nameText stringByAppendingFormat:@"%@",person.lastName];
            }
            //add the object in the alreadySelected Dictionary
            [alreadySelected setObject:person forKey:nameText];
            self.alreadySelectedContacts = alreadySelected;
            //activate the delegate method
            
            if ([self.preDefinedMode isEqualToString:@"email"]) {
                [self.delegate AddContactInformtionToPeopleList:person];
            } else if([self.preDefinedMode isEqualToString:@"message"]) {
                [self.delegate AddMessageContactInformtionToPeopleList:person];
            }
            
            [self.searchDisplayController setActive:NO]; 
            //after change, update the table view
            [self getTheDividedContacts];
            [self.tableView reloadData];
        }

    }
    else {
        if ([self.delegate conformsToProtocol:@protocol(FeedBackToCreateActivityChange)]) {
            UserContactObject *person = [self.dividedContacts objectAtIndex:indexPath.row];
            
            NSMutableDictionary *alreadySelected=[self.alreadySelectedContacts mutableCopy];
            //get the key value from the name of the person
            NSString *nameText=@"";
            if (person.firstName) {
                nameText=[nameText stringByAppendingFormat:@"%@",person.firstName];
                if (person.lastName) {
                    nameText=[nameText stringByAppendingFormat:@", %@",person.lastName];
                }
            }
            else if(person.lastName){
                nameText=[nameText stringByAppendingFormat:@"%@",person.lastName];
            }
            //add the object in the alreadySelected Dictionary
            [alreadySelected setObject:person forKey:nameText];
            self.alreadySelectedContacts = alreadySelected;
            
            //activate the delegate method
            if ([self.preDefinedMode isEqualToString:@"email"]) {
                [self.delegate AddContactInformtionToPeopleList:person];
            } else if([self.preDefinedMode isEqualToString:@"message"]) {
                [self.delegate AddMessageContactInformtionToPeopleList:person];
            }
        }
    }
}
-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
        if ([self.delegate conformsToProtocol:@protocol(FeedBackToCreateActivityChange)]) {
        UserContactObject *person = [self.dividedContacts objectAtIndex:indexPath.row];
            
            NSMutableDictionary *alreadySelected=[self.alreadySelectedContacts mutableCopy];
            //get the key value from the name of the person
            NSString *nameText=@"";
            if (person.firstName) {
                nameText=[nameText stringByAppendingFormat:@"%@",person.firstName];
                if (person.lastName) {
                    nameText=[nameText stringByAppendingFormat:@", %@",person.lastName];
                }
            }
            else if(person.lastName){
                nameText=[nameText stringByAppendingFormat:@"%@",person.lastName];
            }
            //add the object in the alreadySelected Dictionary
            [alreadySelected removeObjectForKey:nameText];
            self.alreadySelectedContacts = alreadySelected;
            //activate the delegate method
            if ([self.preDefinedMode isEqualToString:@"email"]) {
                [self.delegate DeleteContactInformtionToPeopleList:person];
            } else if([self.preDefinedMode isEqualToString:@"message"]) {
                [self.delegate DeleteMessageContactInformtionToPeopleList:person];
            }
    }
}

@end
