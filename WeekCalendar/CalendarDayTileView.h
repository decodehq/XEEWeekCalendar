//
//  CalendarDayTile.h
//  TimePrep
//
//  Created by Marko Strizic on 5/25/13.
//  Copyright (c) 2013 XEE Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekEventModel.h"

@class CalendarDayTileView;
@protocol CalendarDayTileViewDelegate <NSObject>
-(void) calendarDayTileView:(CalendarDayTileView*)view didSelectEvent:(WeekEventModel*)event;
-(CGRect) calendarDayTileViewMoving:(CalendarDayTileView*)view withTouch:(UITouch*)touch;
@optional
-(void) calendarDayTileView:(CalendarDayTileView*)view didSelectDay:(NSDate*)date;

@end

@interface CalendarDayTileView : UIView <UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_titleView;
    UILabel *_titleLabel;
    UIView *_contentView;
    UITableView *_tableView;
    NSArray *_events;
    BOOL _enableMovingTiles;
    CGFloat _firstTouchTimeStamp;
    CGFloat _deltaY;
    
    UIImageView *_moverView;
}

@property (nonatomic,weak) id<CalendarDayTileViewDelegate> delegate;
@property (nonatomic,readonly) UIImageView *titleView;
@property (nonatomic,readonly,strong) NSDate *date;
@property (nonatomic,assign) int weekDay;
@property (nonatomic,assign) CGFloat layoutKoef;

-(void) addEvents:(NSArray*)events;
-(void) configureWithDate:(NSDate*)date;
-(void) refreshEvents;


@end
