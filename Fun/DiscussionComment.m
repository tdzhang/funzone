//
//  DiscussionComment.m
//  OrangeParc
//
//  Created by Tongda Zhang on 8/18/12.
//
//

#import "DiscussionComment.h"

@implementation DiscussionComment
@synthesize user_id=_user_id;
@synthesize content=_content;
@synthesize timestamp=_timestamp;
@synthesize user_name=_user_name;
@synthesize user_picture_url = _user_picture_url;
@synthesize isRegistered=_isRegistered;


+(NSArray *)getDiscussionCommentArrayFromArray:(NSArray *)comments{
    //using the comment json data to build up a comment array
    NSMutableArray *temp_array=[NSMutableArray array];
    for (NSDictionary *comment in comments) {
        if ([comment objectForKey:@"user_id"]) {
            //this comment is from a registered user
            NSNumber *user_id=[comment objectForKey:@"user_id"];
            NSString *user_picture = [comment objectForKey:@"user_pic"];
            NSString *content=[comment objectForKey:@"content"];
            NSString *timestamp=[comment objectForKey:@"timestamp"];
            NSString *username=[comment objectForKey:@"user_name"];
            NSURL *url=[NSURL URLWithString:user_picture];
            DiscussionComment *commentOne=[[DiscussionComment alloc] init];
            commentOne.user_id=user_id;
            commentOne.content=content;
            commentOne.timestamp=timestamp;
            commentOne.user_name=username;
            commentOne.user_picture_url=url;
            commentOne.isRegistered=YES;
            [temp_array addObject:commentOne];
        } else {
            //this comment is from a outside user
            NSString *content=[comment objectForKey:@"content"];
            NSString *timestamp=[comment objectForKey:@"timestamp"];
            NSString *username=[comment objectForKey:@"user_name"];
            DiscussionComment *commentOne=[[DiscussionComment alloc] init];
            commentOne.content=content;
            commentOne.timestamp=timestamp;
            commentOne.user_name=username;
            commentOne.isRegistered=NO;
            [temp_array addObject:commentOne];
        }
    }
    return temp_array;
}
@end
