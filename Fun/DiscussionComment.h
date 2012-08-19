//
//  DiscussionComment.h
//  OrangeParc
//
//  Created by Tongda Zhang on 8/18/12.
//
//

#import <Foundation/Foundation.h>

@interface DiscussionComment : NSObject
@property (nonatomic,strong) NSNumber *user_id;
@property (nonatomic,strong) NSString* content;
@property (nonatomic,strong) NSString* timestamp;
@property (nonatomic,strong) NSString* user_name;
@property (nonatomic,strong) NSURL* user_picture_url;
@property (nonatomic)BOOL isRegistered;


//generate the array of the eventComment from the json got from the sever
+(NSArray *)getDiscussionCommentArrayFromArray:(NSArray *)comments;
@end
