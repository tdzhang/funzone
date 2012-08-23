//
//  ChooseImageTableViewController.h
//  GoogleImageAPIpractice
//
//  Created by Tongda Zhang on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageTableViewCell.h"
#import "GlobalConstant.h"

//define the constant variable
#define GOOGLE_IMAGE_NUM 8 //between 1~8
@class ChooseImageTableViewController;

@protocol ChooseImageFeedBackDelegate 

-(void)ChooseUIImage:(UIImage*)image  WithUrlName:(NSString*)URLName From:(ChooseImageTableViewController*) sender;

-(void)ChooseOtherSource;

@end


@interface ChooseImageTableViewController : UITableViewController<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (nonatomic,strong) NSString *predefinedKeyWord; //used for predefined search keywords
@property (nonatomic,strong) id<ChooseImageFeedBackDelegate>delegate;
@end
