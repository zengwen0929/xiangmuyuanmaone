//
//  CHOriginaView.m
//  WB
//
//  Created by 刘生文 on 13/3/28.
//  Copyright © 2013年 apple. All rights reserved.
//

#import "CHOriginaView.h"
#import "CHStatusFrame.h"
#import "CHStatus.h"
#import "UIImageView+WebCache.h"
#import "CHPhotosView.h"

@interface CHOriginaView ()

// 头像
@property (nonatomic, weak) UIImageView *iconView;

// 昵称
@property (nonatomic, weak) UILabel *nameView;

// vip
@property (nonatomic, weak) UIImageView *vipView;

// 时间
@property (nonatomic, weak) UILabel *timeView;

// 来源
@property (nonatomic, weak) UILabel *sourceView;

// 正文
@property (nonatomic, weak) UILabel *textView;

// 配图
@property (nonatomic, weak) CHPhotosView *photosView;

@end

@implementation CHOriginaView

#pragma mark - 2、重写set方法来设置控件的Frame和内容------
- (void)setStatusF:(CHStatusFrame *)statusF {
    _statusF = statusF;
    // 设置frame
    [self setUpFrame];
    // 设置data
    [self setUpData];
}

- (void)setUpData
{
    CHStatus *status = _statusF.status;
    // 头像
    [_iconView sd_setImageWithURL:status.user.profile_image_url placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    // 昵称
    if (status.user.vip) {
        _nameView.textColor = [UIColor redColor];
    }else{
        _nameView.textColor = [UIColor blackColor];
    }
    _nameView.text = status.user.name;
    // vip
    NSString *imageName = [NSString stringWithFormat:@"common_icon_membership_level%d",status.user.mbrank];
    UIImage *image = [UIImage imageNamed:imageName];
    _vipView.image = image;
    // 时间
    _timeView.text = status.created_at;
    // 来源
    _sourceView.text = status.source;
    // 正文
    _textView.text = status.text;
    // 配图
    _photosView.pic_urls = status.pic_urls;
}

- (void)setUpFrame {
    // 头像
    _iconView.frame = _statusF.originalIconFrame;
    // 昵称
    _nameView.frame = _statusF.originalNameFrame;
    // vip
    if (_statusF.status.user.vip) { // 是vip
        _vipView.hidden = NO;
        _vipView.frame = _statusF.originalVipFrame;
        
    }else{
        _vipView.hidden = YES;
    }
    // 时间 每次有新的时间都需要计算时间frame
    CHStatus *status = _statusF.status;
    CGFloat timeX = _nameView.frame.origin.x;
    CGFloat timeY = CGRectGetMaxY( _nameView.frame) + CHStatusCellMargin * 0.5;
    CGSize timeSize = [status.created_at sizeWithFont:CHTimeFont];
    _timeView.frame = (CGRect){{timeX,timeY},timeSize};
    // 来源
    CGFloat sourceX = CGRectGetMaxX(_timeView.frame) + CHStatusCellMargin;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:CHSourceFont];
    _sourceView.frame = (CGRect){{sourceX,sourceY},sourceSize};
    // 正文
    _textView.frame = _statusF.originalTextFrame;
    // 配图
    _photosView.frame = _statusF.originalPhotosFrame;
}

#pragma mark - 1、初始化控件------
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加所有子控件
        [self setUpAllChildView];
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageWithStretchableName:@"timeline_card_top_background"];
    }
    return self;
}

// 添加所有子控件
- (void)setUpAllChildView {
    // 头像
    UIImageView *iconView = [[UIImageView alloc] init];
    [self addSubview:iconView];
    _iconView = iconView;
    // 昵称
    UILabel *nameView = [[UILabel alloc] init];
    nameView.font = CHNameFont;
    [self addSubview:nameView];
    _nameView = nameView;
    // vip
    UIImageView *vipView = [[UIImageView alloc] init];
    [self addSubview:vipView];
    _vipView = vipView;
    // 时间
    UILabel *timeView = [[UILabel alloc] init];
    timeView.font = CHTimeFont;
    timeView.textColor = [UIColor orangeColor];
    [self addSubview:timeView];
    _timeView = timeView;
    // 来源
    UILabel *sourceView = [[UILabel alloc] init];
    sourceView.font = CHSourceFont;
    sourceView.textColor = [UIColor lightGrayColor];
    [self addSubview:sourceView];
    _sourceView = sourceView;
    // 正文
    UILabel *textView = [[UILabel alloc] init];
    textView.font = CHTextFont;
    textView.numberOfLines = 0;
    [self addSubview:textView];
    _textView = textView;
    // 配图
    CHPhotosView *photosView = [[CHPhotosView alloc] init];
    [self addSubview:photosView];
    _photosView = photosView;
}

@end
