//
//  ProfilePicViewController.m
//  OrangeParc
//
//  Created by Yizhou Zhu on 8/24/12.
//
//

#import "ProfilePicViewController.h"
#import "Cache.h"

@interface ProfilePicViewController ()
@property (nonatomic,strong) NSURL *imgUrl;
@property (weak, nonatomic) IBOutlet UIImageView *largeProfilePic;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@end

@implementation ProfilePicViewController
@synthesize imgUrl=_imgUrl;
@synthesize largeProfilePic = _largeProfilePic;
@synthesize backButton = _backButton;

- (IBAction)backButton:(UIButton *)sender {
    [self dismissModalViewControllerAnimated:YES];
}

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
    if (![Cache isURLCached:self.self.imgUrl]) {
        //using high priority queue to fetch the image
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            //get the image data
            NSData * imageData = nil;
            imageData = [[NSData alloc] initWithContentsOfURL: self.imgUrl];
            if ( imageData == nil ){
                //if the image data is nil, the image url is not reachable. using a default image to replace that
                //NSLog(@"downloaded %@ error, using a default image",url);                
            }
            else {
                //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:self.imgUrl withData:imageData];
                        [self.largeProfilePic setImage:[UIImage imageWithData:imageData]];
                    });
                }
            }
        });
    }
    else {
        dispatch_async( dispatch_get_main_queue(),^{
            [self.largeProfilePic setImage:[UIImage imageWithData:[Cache getCachedData:self.imgUrl]]];
        });
    }
}

- (void)viewDidUnload
{
    [self setLargeProfilePic:nil];
    [self setBackButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)preSetImgUrl:(NSURL *)imgUrl {
    self.imgUrl = imgUrl;
    return;
}
@end
