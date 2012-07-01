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
@end

@implementation ChoosePeopleToGoTableViewController
@synthesize contacts=_contacts;
@synthesize delegate=_delegate;
@synthesize alreadySelectedContacts=_alreadySelectedContacts;
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        [constactsMutable addObject:contact];
    }
    //set the contacts property
    self.contacts = [constactsMutable copy];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1; //temp set to 1
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    // Configure the cell...here already deal with the situation that user lacking information (like phone number or email)
    UserContactObject* contact=[self.contacts objectAtIndex:indexPath.row];
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
    
    cell.userName.text= nameText;
    if ([contact.email count]>0) {
        cell.userEmail.text=[contact.email objectAtIndex:0];
    }
    
    if ([self.alreadySelectedContacts objectForKey:nameText]) {
        //[cell setSelected:YES animated:YES];
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    	
    
    return cell;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */

    if ([self.delegate conformsToProtocol:@protocol(FeedBackToCreateActivityChange)]) {
        UserContactObject *person = [self.contacts objectAtIndex:indexPath.row];
            [self.delegate AddContactInformtionToPeopleList:person];
    }
    
}
-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
        if ([self.delegate conformsToProtocol:@protocol(FeedBackToCreateActivityChange)]) {
        UserContactObject *person = [self.contacts objectAtIndex:indexPath.row];
            [self.delegate DeleteContactInformtionToPeopleList:person];
        
    }
}

@end
