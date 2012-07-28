//
//  ConfirmationViewController.m
//  Fun
//
//  Created by He Yang on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfirmationViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ConfirmationViewController()
@property (weak, nonatomic) IBOutlet UIImageView *facebookImageView;
@property (weak, nonatomic) IBOutlet UIImageView *twitterImageView;
@property (weak, nonatomic) IBOutlet UIImageView *wechatImageView;
@property (weak, nonatomic) IBOutlet UIImageView *emailImageView;

@end

@implementation ConfirmationViewController
@synthesize facebookImageView;
@synthesize twitterImageView;
@synthesize wechatImageView;
@synthesize emailImageView;

- (void)viewDidLoad {
    [self setButtonStyle:self.facebookImageView.layer];
    [self setButtonStyle:self.twitterImageView.layer];
    [self setButtonStyle:self.wechatImageView.layer];
    [self setButtonStyle:self.emailImageView.layer];
    [super viewDidLoad];
    
}

- (void)viewDidUnload {
    [self setFacebookImageView:nil];
    [self setTwitterImageView:nil];
    [self setWechatImageView:nil];
    [self setEmailImageView:nil];
    [super viewDidUnload];
}


- (void)setButtonStyle: (CALayer *)layer{
    layer.cornerRadius = 22;
    layer.shadowColor = [[UIColor grayColor] CGColor];
    layer.shadowOffset = CGSizeMake(0, 1); 
    layer.masksToBounds = YES;
    
}
@end
