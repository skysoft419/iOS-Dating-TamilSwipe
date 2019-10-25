//
//  UUMessage.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-26.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MessageType) {
    UUMessageTypeText     = 0 ,
    UUMessageTypePicture  = 1 ,
    UUMessageTypeVoice    = 2
};


typedef NS_ENUM(NSInteger, MessageFrom) {
    UUMessageFromMe    = 0,   // 自己发的
    UUMessageFromOther = 1    // 别人发得
};



@interface UUMessage : NSObject
  @property (nonatomic, copy) NSString *strTime;

@property (nonatomic, copy) NSString *strContent;
@property (nonatomic, copy) UIImage  *picture;
@property (nonatomic, copy) NSData   *voice;
@property (nonatomic, copy) NSString *strVoiceTime;



@property (nonatomic, copy) NSString *conv_id;
@property (nonatomic, copy) NSString *doc_id;
@property (nonatomic, copy) NSString *filesize;
@property (nonatomic, copy) NSString * user_from;//from
@property (nonatomic, copy) NSString * messageid;//id
@property (nonatomic, copy) NSString * isStar;
@property (nonatomic, copy) NSString *message_status;
@property (nonatomic, copy) NSString * msgId;

@property (nonatomic, copy) NSString * name;//id
@property (nonatomic, copy) NSString * payload;
@property (nonatomic, copy) NSString *recordId;
@property (nonatomic, copy) NSString * server_load;


@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * timestamp;

@property (nonatomic, copy) NSString * height;




@property (nonatomic, copy) NSString * to;//to
@property (nonatomic, copy) NSString * message_type; //type
@property (nonatomic, copy) NSString *width; //



@property (nonatomic, assign) MessageType type;
@property (nonatomic, assign) MessageFrom from;
@property (nonatomic, copy) NSString * firstDate;

@property (nonatomic, assign) BOOL showDateLabel;

- (void)setWithDict:(NSDictionary *)dict;

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end;

@end
