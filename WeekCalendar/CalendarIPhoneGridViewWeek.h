//
//  CalendarIPhoneGridView.h
//  TimePrep
//
//  Created by Marko Strizic on 7/18/12.
//  Copyright (c) 2013 XEE Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventInfoModalView.h"
#import <QuartzCore/QuartzCore.h>

#import "CalendarDayTileView.h"


typedef enum {
    Monday = 50,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
    Sunday
}CalendarWeekDays;



@interface CalendarIPhoneGridViewWeek : UIView <CalendarDayTileViewDelegate> {
    NSDate *_week;
    
    NSDate *_firstWeekDate;
    NSDate *_lastWeekDate;
    
    NSArray *_dayTileViews;
    
    NSUInteger _movingDayTileViewIndex;
    NSCalendar *_currentCalendar;
    NSArray *_layoutGrid;
}

@property (nonatomic, strong) NSArray *events;



-(void) drawEvents;
-(void) nextWeek;
-(void) previousWeek;
-(void) setWeek:(NSDate *)week;


@end








