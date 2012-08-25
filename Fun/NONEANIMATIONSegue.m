//
//  NONEANIMATIONSegue.m
//  OrangeParc
//
//  Created by Tongda Zhang on 8/25/12.
//
//

#import "NONEANIMATIONSegue.h"

@implementation NONEANIMATIONSegue
- (void) perform {
    
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    
    [UIView transitionWithView:src.navigationController.view duration:0.0
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [src.navigationController pushViewController:dst animated:NO];
                    }
                    completion:NULL];
}
@end
