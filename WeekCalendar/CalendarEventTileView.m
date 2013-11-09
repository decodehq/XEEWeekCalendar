//
//  CalendarEventTile.m
//  TimePrep
//
//  Created by Marko Strizic on 5/25/13.
//  Copyright (c) 2013 XEE Tech. All rights reserved.
//

#import "CalendarEventTileView.h"
#import <QuartzCore/QuartzCore.h>

const float kMarginEventTile = 5.f;

#define FONT(SIZE) [UIFont systemFontOfSize:SIZE]
#define FONT_BOLD(SIZE) [UIFont boldSystemFontOfSize:SIZE]

@implementation CalendarEventTileView

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        CGFloat leftImageViewHeight = IS_IPAD ? 30.f : 20.f;
        CGFloat leftImageViewWidth = IS_IPAD ? 60.f : 50.f;
        
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMarginEventTile, kMarginEventTile/2.f, leftImageViewWidth, leftImageViewHeight)];
        _leftImageView.backgroundColor = COLOR_DAYTILE_DARK_BLUE;
        _leftImageView.layer.cornerRadius = 2.f;
        [self addSubview:_leftImageView];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _leftImageView.width-kMarginEventTile/2.f, _leftImageView.height-kMarginEventTile)];
        _timeLabel.center = CGPointMake(_leftImageView.width/2.f, _leftImageView.height/2.f);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = FONT(IS_IPAD ? 16.f : 12.f);
        _timeLabel.textColor = [UIColor whiteColor];
        [_leftImageView addSubview:_timeLabel];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftImageView.xRight+kMarginEventTile,
                                                                _leftImageView.y,
                                                                self.width-_leftImageView.xRight-2*kMarginEventTile,
                                                                _leftImageView.height)];
        _titleLabel.backgroundColor = [UIColor orangeColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = FONT(IS_IPAD ? 16.f : 12.f);
        _titleLabel.textColor = COLOR_DAYTILE_DARK_BLUE;
        [self addSubview:_titleLabel];

        self.height = _leftImageView.yBottom+kMarginEventTile/2.f;
        
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    _leftImageView.frame = CGRectMake(kMarginEventTile, kMarginEventTile/2.f, _leftImageView.width, _leftImageView.height);
    _timeLabel.center = CGPointMake(_leftImageView.width/2.f, _leftImageView.height/2.f);
    _titleLabel.frame = CGRectMake(_leftImageView.xRight+kMarginEventTile,
                                   _leftImageView.y,
                                   self.width-_leftImageView.xRight-2*kMarginEventTile,
                                   _leftImageView.height);
}


-(void) configureWithEvent:(WeekEventModel*)event
{
    _titleLabel.text = event.title;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterShortStyle;
    //formatter.dateFormat = @"hh:mm";
    NSString *startTime = [formatter stringFromDate:event.startDate];
    
    BOOL is24HoursFormat = YES;
    if ([startTime rangeOfString:@"PM"].location != NSNotFound || [startTime rangeOfString:@"AM"].location != NSNotFound) {
        is24HoursFormat = NO;
    }
    _timeLabel.text = startTime;
    [self refreshColorForEvent:event];
}

-(void) refreshColorForEvent:(WeekEventModel*)event {
    switch (event.eventState) {
        case WeekEventStateFailed:
            _leftImageView.backgroundColor = COLOR_EVENT_FAILED;
            break;
        case WeekEventStateCompleted:
            _leftImageView.backgroundColor = COLOR_EVENT_COMPLETED;
            break;
        case WeekEventStateNormal:
            _leftImageView.backgroundColor = COLOR_DAYTILE_DARK_BLUE;
            break;
        default:
            break;
    }
}

@end
