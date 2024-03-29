//
//  UUMessageContentButton.m
//  BloodSugarForDoc
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import "UUMessageContentButton.h"
@implementation UUMessageContentButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //图片
        self.backImageView = [[UIImageView alloc]init];
        self.backImageView.userInteractionEnabled = YES;
        self.backImageView.layer.cornerRadius = 5;
        self.backImageView.layer.masksToBounds  = YES;
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backImageView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.backImageView];
        
        //语音
        self.voiceBackView = [[UIView alloc]init];
        [self addSubview:self.voiceBackView];
        self.second = [[UILabel alloc]init];
        if (IS_IPHONE_5S) {
            [self.second setFrame:CGRectMake(0, 0, 340, 20)];
            
        }
        else
        {
            [self.second setFrame:CGRectMake(0, 0, 490, 30)];
            
        }
        self.second.textAlignment = NSTextAlignmentCenter;
        self.second.font = [UIFont systemFontOfSize:14];
        
        self.voice = [[UIImageView alloc]init ];
        if (IS_IPHONE_5S) {
            [self.voice setFrame:CGRectMake(0, 0, 150, 20)];

        }
        else
        {
            [self.voice setFrame:CGRectMake(0, 0, 220, 30)];

        }
        self.voice.animationDuration = 1;
        self.voice.animationRepeatCount = 0;
        self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.indicator.center=CGPointMake(80, 15);
        [self.voiceBackView addSubview:self.indicator];
        [self.voiceBackView addSubview:self.voice];
        [self.voiceBackView addSubview:self.second];
       
        self.backImageView.userInteractionEnabled = NO;
        self.voiceBackView.userInteractionEnabled = NO;
        self.second.userInteractionEnabled = NO;
        self.voice.userInteractionEnabled = NO;
        
        self.second.backgroundColor = [UIColor clearColor];
        self.voice.backgroundColor = [UIColor clearColor];
        self.voiceBackView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
- (void)benginLoadVoice
{
    self.voice.hidden = YES;
    [self.indicator startAnimating];
}
- (void)didLoadVoice
{
    self.voice.hidden = NO;
    [self.indicator stopAnimating];
    [self.voice startAnimating];
}
-(void)stopPlay
{
//    if(self.voice.isAnimating){
        [self.voice stopAnimating];
//    }
}

- (void)setIsMyMessage:(BOOL)isMyMessage
{
    _isMyMessage = isMyMessage;
    if (isMyMessage) {
        self.backImageView.frame = CGRectMake(5, 5, 220, 220);
        self.voiceBackView.frame = CGRectMake(15, 10, 130, 35);
        self.second.textColor = [UIColor whiteColor];
    }else{
        self.backImageView.frame = CGRectMake(15, 5, 220, 220);
        self.voiceBackView.frame = CGRectMake(25, 10, 130, 35);
        self.second.textColor = [UIColor blackColor];
    }
    if (isMyMessage==YES) { //syed
        NSLog(@"to");
        self.voice.image = [UIImage imageNamed:@"mic"];
        self.voice.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"anim3"],
                                      [UIImage imageNamed:@"anim1"],
                                      [UIImage imageNamed:@"anim2"],nil];
        
    }
    else
    {
        NSLog(@"from");
        self.voice.image = [UIImage imageNamed:@"recevierAudio"];
        self.voice.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"recanim1"],
                                      [UIImage imageNamed:@"recanim2"],
                                      [UIImage imageNamed:@"recanim3"],nil];
        
        
    }

}
//添加
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(copy:));
}

-(void)copy:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.titleLabel.text;
}


@end
