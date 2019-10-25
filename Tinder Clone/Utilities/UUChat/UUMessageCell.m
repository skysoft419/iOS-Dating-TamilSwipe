////
////  UUMessageCell.m
////  UUChatDemoForTextVoicePicture
////
////  Created by shake on 14-8-27.
////  Copyright (c) 2014年 uyiuyao. All rights reserved.
////
//
//#import "UUMessageCell.h"
//#import "UUMessage.h"
//#import "UUMessageFrame.h"
//#import "UUAVAudioPlayer.h"
//#import "UIButton+AFNetworking.h"
//#import "UUImageAvatarBrowser.h"
//
//@interface UUMessageCell ()<UUAVAudioPlayerDelegate>
//{
//    AVAudioPlayer *player;
//    NSString *voiceURL;
//    NSData *songData;
//    
//    UUAVAudioPlayer *audio;
//    
//    UIView *headImageBackView;
//    BOOL contentVoiceIsPlaying;
//}
//@end
//
//@implementation UUMessageCell
//
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        
//        self.backgroundColor = [UIColor clearColor];
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        // 1、创建时间 Created
//        self.labelTime = [[UILabel alloc] init];
//        self.labelTime.textAlignment = NSTextAlignmentCenter;
//        self.labelTime.textColor = [UIColor grayColor];
//        self.labelTime.font = ChatTimeFont;
//        [self.contentView addSubview:self.labelTime];
//        
//        // 2、创建头像 Create Profile
//        headImageBackView = [[UIView alloc]init];
//        headImageBackView.layer.cornerRadius = 22;
//        headImageBackView.layer.masksToBounds = YES;
//        headImageBackView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
//       // [self.contentView addSubview:headImageBackView];
//      
//        
//        self.btnHeadImage = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.btnHeadImage.layer.cornerRadius = 20;
//        self.btnHeadImage.layer.masksToBounds = YES;
//        [self.btnHeadImage addTarget:self action:@selector(btnHeadImageClick:)  forControlEvents:UIControlEventTouchUpInside];
//      //  [headImageBackView addSubview:self.btnHeadImage];
//        
//        self.blueDot=[[UIImageView alloc]init]; //syed
//        self.blueDot.image=[UIImage imageNamed:@"mic"];
//       // [self.contentView addSubview:self.blueDot];
//        
//        // 3、创建头像下标 Create Avatar subscript
//        self.labelNum = [[UILabel alloc] init];
//        self.labelNum.textColor = [UIColor lightGrayColor];
//        self.labelNum.backgroundColor = [UIColor clearColor];
//        self.labelNum.textAlignment = NSTextAlignmentLeft;
//        self.labelNum.font = ChatTimeFont;
//        
//        // 4、创建内容 Create content
//        self.btnContent = [UUMessageContentButton buttonWithType:UIButtonTypeCustom];
//        self.btnContent.frame=CGRectMake(0, 0, self.contentView.frame.size.width-50, 60);
//        [self.btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        self.btnContent.titleLabel.font = ChatContentFont;
//        self.btnContent.titleLabel.numberOfLines = 0;
//        [self.btnContent addTarget:self action:@selector(btnContentClick)  forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:self.btnContent];
//        
//        [self.contentView addSubview:self.labelNum];
//        
//        
//        self.btnContent.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        self.btnContent.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//
//
//        
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UUAVAudioPlayerDidFinishPlay) name:@"VoicePlayHasInterrupt" object:nil];
//        
//        //红外线感应监听 Infrared sensor monitor
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(sensorStateChange:)
//                                                     name:UIDeviceProximityStateDidChangeNotification
//                                                   object:nil];
//        contentVoiceIsPlaying = NO;
//
//    }
//    return self;
//}
//
////头像点击 Avatar Click
//- (void)btnHeadImageClick:(UIButton *)button{
//    if ([self.delegate respondsToSelector:@selector(headImageDidClick:userId:)])  {
//        [self.delegate headImageDidClick:self userId:self.messageFrame.message.strId];
//    }
//}
//
//-(void)SetSeenStatus:(NSString *)Status
//{
//    
//}
//
//
//- (void)btnContentClick{
//    //play audio
//    if (self.messageFrame.message.type == UUMessageTypeVoice) {
//        if(!contentVoiceIsPlaying){
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"VoicePlayHasInterrupt" object:nil];
//            contentVoiceIsPlaying = YES;
//            audio = [UUAVAudioPlayer sharedInstance];
//            audio.delegate = self;
//            //        [audio playSongWithUrl:voiceURL];
//            [audio playSongWithData:songData];
//        }else{
//            [self UUAVAudioPlayerDidFinishPlay];
//        }
//    }
//    //show the picture
//    else if (self.messageFrame.message.type == UUMessageTypePicture)
//    {
//        if (self.btnContent.backImageView) {
//            [UUImageAvatarBrowser showImage:self.btnContent.backImageView];
//        }
//        if ([self.delegate isKindOfClass:[UIViewController class]]) {
//            [[(UIViewController *)self.delegate view] endEditing:YES];
//        }
//    }
//    // show text and gonna copy that
//    else if (self.messageFrame.message.type == UUMessageTypeText)
//    {
//        [self.btnContent becomeFirstResponder];
//        UIMenuController *menu = [UIMenuController sharedMenuController];
//        [menu setTargetRect:self.btnContent.frame inView:self.btnContent.superview];
//        [menu setMenuVisible:YES animated:YES];
//    }
//}
//
//- (void)UUAVAudioPlayerBeiginLoadVoice
//{
//    [self.btnContent benginLoadVoice];
//}
//- (void)UUAVAudioPlayerBeiginPlay
//{
//    //开启红外线感应
//    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
//    [self.btnContent didLoadVoice];
//}
//- (void)UUAVAudioPlayerDidFinishPlay
//{
//    //关闭红外线感应
//    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
//    contentVoiceIsPlaying = NO;
//    [self.btnContent stopPlay];
//    [[UUAVAudioPlayer sharedInstance]stopSound];
//}
//
//
////内容及Frame设置
//- (void)setMessageFrame:(UUMessageFrame *)messageFrame{
//
//    _messageFrame = messageFrame;
//    UUMessage *message = messageFrame.message;
//    
//    // 1、设置时间
//    self.labelTime.text = message.strTime;
//    self.labelTime.frame = messageFrame.timeF;
//    
//    // 2、设置头像
//    headImageBackView.frame = messageFrame.iconF;
//    self.btnHeadImage.frame = CGRectMake(2, 2, ChatIconWH-4, ChatIconWH-4);
//    [self.btnHeadImage setBackgroundImageForState:UIControlStateNormal
//                                          withURL:[NSURL URLWithString:message.strIcon]
//                                 placeholderImage:[UIImage imageNamed:@"headImage.jpeg"]];
//   
//
//    // 3、设置下标
//    self.labelNum.text = message.strName;
//    // 4、设置内容
//    
//    //prepare for reuse
//    [self.btnContent setTitle:@"" forState:UIControlStateNormal];
//    self.btnContent.voiceBackView.hidden = YES;
//    self.btnContent.backImageView.hidden = YES;
//
//    self.btnContent.frame = messageFrame.contentF;
//    
//    if (message.from == UUMessageFromMe) {//syed
//        self.btnContent.isMyMessage = YES;
//        [self.btnContent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentRight, ChatContentBottom, ChatContentLeft);
//        self.blueDot.frame=CGRectMake(self.contentView.frame.size.width+38, self.btnHeadImage.frame.size.height+38, 15, 15);
//
//    }else{
//        self.btnContent.isMyMessage = NO;
//        [self.btnContent setTitleColor:[UIColor blueColor] forState:UIControlStateNormal]; //syed
//        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentLeft, ChatContentBottom, ChatContentRight);
//        self.blueDot.frame=CGRectMake(25, self.btnHeadImage.frame.size.height+38, 15, 15);
//     }
//   
//  
//    
//
//    //背景气泡图 Background bubble chart
//    UIImage *normal;
//    if (message.from == UUMessageFromMe) { //syed
//        normal = [UIImage imageNamed:@"chat"];
//        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
//    }
//    else{
//        normal = [UIImage imageNamed:@"recChat"];
//        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
//    }
//    [self.btnContent setBackgroundImage:normal forState:UIControlStateNormal];
//    [self.btnContent setBackgroundImage:normal forState:UIControlStateHighlighted];
//
//    switch (message.type) {
//        case UUMessageTypeText:
//            [self.btnContent setTitle:message.strContent forState:UIControlStateNormal];
//            break;
//        case UUMessageTypePicture:
//        {
//            self.btnContent.backImageView.hidden = NO;
//            self.btnContent.backImageView.image = message.picture;
//            self.btnContent.backImageView.frame = CGRectMake(0, 0, self.btnContent.frame.size.width, self.btnContent.frame.size.height);
//            [self makeMaskView:self.btnContent.backImageView withImage:normal];
//        }
//            break;
//        case UUMessageTypeVoice:
//        {
//            self.btnContent.voiceBackView.hidden = NO;
//            self.btnContent.second.text = [NSString stringWithFormat:@"0.%@",message.strVoiceTime]; //syed
//            songData = message.voice;
////            voiceURL = [NSString stringWithFormat:@"%@%@",RESOURCE_URL_HOST,message.strVoice];
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
//    if (messageFrame.nameF.origin.x > 160) {
//        self.labelNum.frame = CGRectMake(self.btnContent.frame.origin.x+10 , _btnContent.frame.size.height+_btnContent.frame.origin.y -25, 100, messageFrame.nameF.size.height);
//        self.labelNum.textAlignment = NSTextAlignmentLeft;
//    }else{
//        self.labelNum.frame = CGRectMake(self.btnHeadImage.frame.origin.x+self.btnHeadImage.frame.size.width-10, messageFrame.nameF.origin.y + 3, 80, messageFrame.nameF.size.height);
//        self.labelNum.textAlignment = NSTextAlignmentRight;
//    }
//}
//
//- (void)makeMaskView:(UIView *)view withImage:(UIImage *)image
//{
//    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
//    imageViewMask.frame = CGRectInset(view.frame, 0.0f, 0.0f);
//    view.layer.mask = imageViewMask.layer;
//}
//
////处理监听触发事件
//-(void)sensorStateChange:(NSNotificationCenter *)notification;
//{
//    if ([[UIDevice currentDevice] proximityState] == YES){
//        NSLog(@"Device is close to user");
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//    }
//    else{
//        NSLog(@"Device is not close to user");
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    }
//}
//
//@end
//
//
//
