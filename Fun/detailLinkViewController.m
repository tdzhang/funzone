//
//  detailLinkViewController.m
//  OrangeParc
//
//  Created by Yizhou Zhu on 8/26/12.
//
//

#import "detailLinkViewController.h"

@interface detailLinkViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong) NSURL *link_url;
@end

@implementation detailLinkViewController
@synthesize webView = _webView;
@synthesize link_url=_link_url;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.link_url]];
    [self.webView setScalesPageToFit:YES];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)preSetLinkUrl:(NSURL *)LinkUrl {
    self.link_url = LinkUrl;
    return;
}

@end
