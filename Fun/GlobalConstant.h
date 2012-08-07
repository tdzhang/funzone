//
//  GlobalConstant.h
//  Fun
//
//  Created by Tongda Zhang on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//Server Connection related constant
#pragma mark - Server Connection
#define CONNECT_DOMIAN_NAME @"http://orangeparc.herokuapp.com"   //the server domain name
#define SECURE_DOMAIN_NAME @"https://orangeparc.herokuapp.com"   //the server domain name
#define FACEBOOK_APP_ID @"433716793339720"   //The app id of the facebook

//Explore Function Part
#pragma mark - Explore Part
//ExploreViewController
#define EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH 310 //The width of the scroll view content
#define EXPLORE_PART_SCROLLVIEW_REFRESH_HEIGHT 20 //The height of the refresh view on the scroll view content
#define EXPLORE_PART_SCROLLVIEW_CONTENT_OFFSET_X 5 //The content x offset of the scroll view
#define EXPLORE_PART_SCROLLVIEW_CONTENT_OFFSET_Y 10 //The content y offset of the scroll view
#define EVENT_ELEMENT_CONTENT_WIDTH 310 //The width of the event element view
#define EVENT_ELEMENT_CONTENT_HEIGHT 175 //The height of the event element view

//ExploreBlockElement
#define EXPLORE_BLOCK_ELEMENT_VIEW_X 0
#define EXPLORE_BLOCK_ELEMENT_VIEW_WIDTH 320 //The width of the explore block element (block view)
#define EXPLORE_BLOCK_ELEMENT_VIEW_HEIGHT 175 //The height of the explore block element (block view)
#define EXPLORE_BLOCK_ELEMENT_HOLDER_VIEW_HEIGHT 175 //The height of the event element holder view
#define EXPLORE_BLOCK_ELEMENT_SUB_VIEW_X 5 //subview part(contain some view) x
#define EXPLORE_BLOCK_ELEMENT_SUB_VIEW_Y 5//subview part(contain some view) y
#define EXPLORE_BLOCK_ELEMENT_SUB_VIEW_WIDTH 300//subview part(contain some view) width
#define EXPLORE_BLOCK_ELEMENT_SUB_VIEW_HEIGHT 120//subview part(contain some view) height
#define EXPLORE_BLOCK_ELEMENT_MASK_X 5   //block element mask
#define EXPLORE_BLOCK_ELEMENT_MASK_Y 35
#define EXPLORE_BLOCK_ELEMENT_MASK_WIDTH 300
#define EXPLORE_BLOCK_ELEMENT_MASK_HEIGHT 90
#define EXPLORE_BLOCK_ELEMENT_MASK_ALPHA 0.7
#define EXPLORE_BLOCK_ELEMENT_MASK_IMAGENAME @"mask.png" 
#define EXPLORE_BLOCK_ELEMENT_TITLE_TEXT_X 8    //title label
#define EXPLORE_BLOCK_ELEMENT_TITLE_TEXT_Y 90
#define EXPLORE_BLOCK_ELEMENT_TITLE_TEXT_WIDTH 251
#define EXPLORE_BLOCK_ELEMENT_TITLE_TEXT_HEIGHT 24
#define EXPLORE_BLOCK_ELEMENT_MARKER_X 7 //marker
#define EXPLORE_BLOCK_ELEMENT_MARKER_Y 90
#define EXPLORE_BLOCK_ELEMENT_MARKER_WIDTH 12
#define EXPLORE_BLOCK_ELEMENT_MARKER_HEIGHT 12
#define EXPLORE_BLOCK_ELEMENT_MARKER_ALPHA 0.7
#define EXPLORE_BLOCK_ELEMENT_MARKER_IMAGENAME @"Marker.png"
#define EXPLORE_BLOCK_ELEMENT_LOCATION_LABEL_X 21  //location label
#define EXPLORE_BLOCK_ELEMENT_LOCATION_LABEL_Y 110
#define EXPLORE_BLOCK_ELEMENT_LOCATION_LABEL_WIDTH 227
#define EXPLORE_BLOCK_ELEMENT_LOCATION_LABEL_HEIGHT 21
#define EXPLORE_BLOCK_ELEMENT_EVENTVIEW_X 10    //event view(contain other subviews)
#define EXPLORE_BLOCK_ELEMENT_EVENTVIEW_Y 130
#define EXPLORE_BLOCK_ELEMENT_EVENTVIEW_WIDTH 310
#define EXPLORE_BLOCK_ELEMENT_EVENTVIEW_HEIGHT 31
#define EXPLORE_BLOCK_ELEMENT_THUMBNAIL_X 0 //user thumbnail image
#define EXPLORE_BLOCK_ELEMENT_THUMBNAIL_Y 5
#define EXPLORE_BLOCK_ELEMENT_THUMBNAIL_SIZE 30
#define EXPLORE_BLOCK_ELEMENT_NAME_LABEL_X 35 //Name label
#define EXPLORE_BLOCK_ELEMENT_NAME_LABEL_Y 6
#define EXPLORE_BLOCK_ELEMENT_NAME_LABEL_WIDTH 100
#define EXPLORE_BLOCK_ELEMENT_NAME_LABEL_HEIGHT 30
#define EXPLORE_BLOCK_ELEMENT_INTEREST_X 270 //Interest image view
#define EXPLORE_BLOCK_ELEMENT_INTEREST_Y 15
#define EXPLORE_BLOCK_ELEMENT_INTEREST_SIZE 15
#define EXPLORE_BLOCK_ELEMENT_INTEREST_IMAGE @"detail-interested-gray.png"
#define EXPLORE_BLOCK_ELEMENT_INTEREST_LABEL_X 288 //Interest LABEL
#define EXPLORE_BLOCK_ELEMENT_INTEREST_LABEL_Y 7
#define EXPLORE_BLOCK_ELEMENT_INTEREST_LABEL_WIDTH 21
#define EXPLORE_BLOCK_ELEMENT_INTEREST_LABEL_HEIGHT 31
#define EXPLORE_BLOCK_ELEMENT_REPIN_X 232 //repine image view
#define EXPLORE_BLOCK_ELEMENT_REPIN_Y 15
#define EXPLORE_BLOCK_ELEMENT_REPIN_SIZE 15
#define EXPLORE_BLOCK_ELEMENT_REPIN_IMAGE @"detail-pick-gray.png"
#define EXPLORE_BLOCK_ELEMENT_REPIN_LABEL_X 250 //repine LABEL
#define EXPLORE_BLOCK_ELEMENT_REPIN_LABEL_Y 7
#define EXPLORE_BLOCK_ELEMENT_REPIN_LABEL_WIDTH 21
#define EXPLORE_BLOCK_ELEMENT_REPIN_LABEL_HEIGHT 31
#define EXPLORE_BLOCK_ELEMENT_SEPERATOR_X 0   //seperator
#define EXPLORE_BLOCK_ELEMENT_SEPERATOR_Y 159
#define EXPLORE_BLOCK_ELEMENT_SEPERATOR_WIDTH 320
#define EXPLORE_BLOCK_ELEMENT_SEPERATOR_HEIGHT 1
#define EXPLORE_BLOCK_ELEMENT_SEPERATOR_IMAGE @"seperator.png"
#define TEXTURE_IMAGE @"texture.png"

#pragma mark - Event Detail part
//DetailViewController (abbreviation:DVC)
#define DETAIL_VIEW_CONTROLLER_SCROLLVIEW_INITIAL_CONTENTSIZE_WIDTH 320 //initial scrollview content size
#define DETAIL_VIEW_CONTROLLER_SCROLLVIEW_INITIAL_CONTENTSIZE_HEIGHT 400
#define DETAIL_VIEW_CONTROLLER_COMMENT_HEIGHT 25
#define DVC_EVENT_IMG_WIDTH 320
#define DVC_EVENT_IMG_HEIGHT 180



//Feed View Controller


#pragma mark - category part(new event)
//CategoryCHooseViewController
#define CATEGORY_CHOOSE_VC_FLASH_TRANSITION_DURATION 0.3
#define CATEGORY_CHOOSE_VC_GOTO_FOOD_VIEWCONTROLLER_SNAPSHOT @"AddEventControllerSnapShot.png"
#define GOTO_EVENT_VIEWCONTROLLER_SNAPSHOT @"AddEventControllerSnapShot.png"
#define CATEGORY_CHOOSE_VC_GOTO_ENTERTAIN_VIEWCONTROLLER_SNAPSHOT @"AddEventControllerSnapShot.png"
#define CATEGORY_CHOOSE_VC_GOTO_OUTDOOR_VIEWCONTROLLER_SNAPSHOT @"AddEventControllerSnapShot.png"
#define CATEGORY_CHOOSE_VC_GOTO_SPORTS_VIEWCONTROLLER_SNAPSHOT @"AddEventControllerSnapShot.png"
#define CATEGORY_CHOOSE_VC_GOTO_MOVIE_VIEWCONTROLLER_SNAPSHOT @"AddEventControllerSnapShot.png"
#define CATEGORY_CHOOSE_VC_GOTO_SHOPPING_VIEWCONTROLLER_SNAPSHOT @"AddEventControllerSnapShot.png"
#define CATEGORY_CHOOSE_VC_GOTO_PARTY_VIEWCONTROLLER_SNAPSHOT @"AddEventControllerSnapShot.png"
#define CATEGORY_CHOOSE_VC_GOTO_SELFDEFINE_VIEWCONTROLLER_SNAPSHOT @"AddEventControllerSnapShot.png"
#define CATEGORY_CHOOSE_VC_CATEGORY_FOOD @"Category-Food.png"
#define CATEGORY_CHOOSE_VC_CATEGORY_EVENTS @"Category-Events.png"
#define CATEGORY_CHOOSE_VC_CATEGORY_ENTERTAIN @"Category-Entertainment.png"
#define CATEGORY_CHOOSE_VC_CATEGORY_MOVIE @"Category-Movie.jpeg"
#define CATEGORY_CHOOSE_VC_CATEGORY_OUTDOOR @"Category-Outdoor.png"
#define CATEGORY_CHOOSE_VC_CATEGORY_PARTY @"Category-Party.png"
#define CATEGORY_CHOOSE_VC_CATEGORY_SHOPPTING @"Category-Shopping.png"
#define CATEGORY_CHOOSE_VC_CATEGORY_SPORTS @"Category-Sports.png"
#define CATEGORY_CHOOSE_VC_CATEGORY_IMAGESIZE_WIDTH 80
#define CATEGORY_CHOOSE_VC_CATEGORY_IMAGESIZE_HEIGHT 184


//profile related stuff
#pragma mark - Profile Profile Event Element
//Profile Event Element
#define PROFILE_ELEMENT_VIEW_WIDTH 155
#define PROFILE_ELEMENT_VIEW_HEIGHT 165
#define PROFILE_ELEMENT_EVENT_IMAGE_X 0
#define PROFILE_ELEMENT_EVENT_IMAGE_Y 0
#define PROFILE_ELEMENT_EVENT_IMAGE_WIDTH 145
#define PROFILE_ELEMENT_EVENT_IMAGE_HEIGHT 95
//Profile page view controller
#define PROFILE_PAGEVC_
#define PROFILE_PAGEVC_VIEW_WIDTH 320
#define PROFILE_PAGEVC_VIEW_HEIGHT 55
#define PROFILE_PAGEVC_BlOCK_VIEW_HEIGHT 165

//TABLE VIEW
#define DEFAULT_TABLE_CELL_FONT_SIZE 15
#define DEFAULT_TABLE_CELL_SUBTITLE_SIZE 14


//Sever Log Configuration Constant
#pragma mark - Server Log Config Constants
#define VIA_EXPLORE 1             // event, profile
#define VIA_FEEDS 2               // event, profile
#define VIA_OTHERS_PROFILE 3      // event
#define VIA_MY_PROFILE 4          // event
#define VIA_FACEBOOK_SEARCH 5     // profile, find friend
#define VIA_TOP_USERS 6           // profile, find friend
#define VIA_ACTIVITY 7            // event, profile
#define VIA_MY_INTERESTS 8        // event
#define VIA_EXPLORE_DETAIL 9      // profile(external)
#define VIA_FEEDS_DETAIL 10       // profile(external)
#define VIA_INSPIRED_BY 11        // profile(external)
#define VIA_FACEBOOK_FRIENDS 12     

// Share Channel
#define VIA_FACEBOOK 1
#define VIA_TWITTER 2
#define VIA_WECHAT 3
#define VIA_EMAIL 4
#define VIA_SMS 5
#define VIA_APP 6


//used to map between the activity type and its int value
#pragma mark - activity page constant mapping
#define VIEW_EVENT 1         // via
#define INTEREST_EVENT 2     // some one show interest on your event/////
#define SHARE_EVENT 3        // separate API, via, channel
#define COMMENT_EVENT 4      // some comment on your event////////
#define PIN_EVENT 5          // via
#define VIEW_MAP 6           // separate API, via
#define VIEW_COMMENTS 7      // separate API, via
#define LIKE_EVENT 8           //like

#define CREATE_EVENT 11
#define INVITE_FRIENDS 12    // separate API, channel
#define EDIT_EVENT 13
#define DELETE_EVENT 14
#define INVITED_TO_EVENT 15 //some one has invited you to an event

#define SHOW_EXPLORE 21
#define SHOW_FEEDS 22
#define SHOW_ACTIVITIES 23
#define FIND_FRIENDS 24

#define VIEW_PROFILE 101     
#define FOLLOW_SOMEONE 102   // sb follow you/////////////////
#define SHOW_FOLLOWINGS 103  // via
#define SHOW_FOLLOWERS 104   // via
#define VIEW_BOOKMARKS 105   // via
#define UNFOLLOW_SOMEONE 106 // via
#define SHOW_INTERESTS 107
#define NEW_FRIEND_JOIN 108

//category id mapping information
#define FOOD  @"1"
#define MOVIE  @"2"
#define SPORTS  @"3"
#define NIGHTLIFE  @"4"
#define OUTDOOR  @"5"
#define ENTERTAIN  @"6"
#define EVENTS  @"7"
#define SHOPPING @"8"
#define OTHERS @"0"

//default image part
#define DEFAULT_PROFILE_IMAGE_REPLACEMENT @"iphone-icon-orangeblack-114.png" //to replace the image which cannot get the data from the internet
#define FOOD_REPLACEMENT  @"1"
#define MOVIE_REPLACEMENT  @"2"
#define SPORTS_REPLACEMENT  @"3"
#define NIGHTLIFE_REPLACEMENT  @"4"
#define OUTDOOR_REPLACEMENT  @"5"
#define ENTERTAIN_REPLACEMENT  @"6"
#define EVENTS_REPLACEMENT  @"7"
#define SHOPPING_REPLACEMENT @"8"
#define OTHERS_REPLACEMENT @"iphone-logo-114.png"
#define NILL_REPLACEMENT @""  //used for myparc default event image



//icon files
#define LOCATION_ICON @"07-map-marker.png"
#define TIME_ICON @"11-clock.png"
#define RIGHT_ARROW @"detailButton.png"
