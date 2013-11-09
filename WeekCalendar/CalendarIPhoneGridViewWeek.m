//
//  CalendarIPhoneGridView.m
//  TimePrep
//
//  Created by Marko Strizic on 7/18/12.
//  Copyright (c) 2013 XEE Tech. All rights reserved.
//

#import "CalendarIPhoneGridViewWeek.h"
#import "CalendarDayTileView.h"
#import <QuartzCore/CAAnimation.h>
#import "NSDate-Utilities.h"

@interface NSDate (CalendarDate)

@property (nonatomic,readonly) NSInteger weekday;

@end

static NSCalendar *calendar;

@implementation NSDate (CalendarDate)

-(NSInteger) weekday
{
    if (calendar == nil) {
        calendar = CURRENT_CALENDAR;
    }
    NSDateComponents *dateComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    return dateComponents.weekday;
}

@end


@interface LayoutItem : NSObject

@property (nonatomic,assign) CGFloat layoutKoef;

@end



@implementation CalendarIPhoneGridViewWeek (Private)

-(void) fillCalendarLabelsForWeek: (NSDate *) firstOfWeek displayDates: (BOOL) displayDates {
    
    NSDateComponents *componentsForDaydate = [[NSDateComponents alloc] init];
    
	for (int i = 0; i < 7; i++) {
        componentsForDaydate.day = i;
        
        NSDate *dayDate = [_currentCalendar dateByAddingComponents: componentsForDaydate toDate: firstOfWeek options: 0];
        CalendarDayTileView *dayTileView = [self dayTileViewForWeekDay:dayDate.weekday];
        [dayTileView configureWithDate:dayDate];
    }
}

-(CalendarDayTileView*) dayTileViewForWeekDay:(NSInteger)weekDay
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"weekDay =%d",weekDay];
    CalendarDayTileView *calendarDayTileView = [[_dayTileViews filteredArrayUsingPredicate:predicate] lastObject];
    return calendarDayTileView;
}



- (NSDate *)lastDayOfWeekFromDate:(NSDate *)date {
	CFCalendarRef currentCalendar = CFCalendarCopyCurrent();
	NSDateComponents *components = [_currentCalendar components:DATE_COMPONENTS fromDate:date];
	[components setDay: [components day] + 7];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	CFRelease(currentCalendar);
	return [_currentCalendar dateFromComponents:components];
}

- (NSDate *)firstDayOfWeekFromDate:(NSDate *)date {
	CFCalendarRef currentCalendar = CFCalendarCopyCurrent();
	NSDateComponents *components = [_currentCalendar components:DATE_COMPONENTS fromDate:date];
    NSUInteger day = ([components day] - ((([components weekday] - CFCalendarGetFirstWeekday(currentCalendar)) + 7) % 7));
	[components setDay: day];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	CFRelease(currentCalendar);
	return [_currentCalendar dateFromComponents:components];
}


- (NSDate *)nextWeekFromDate:(NSDate *)date {
	CFCalendarRef currentCalendar = CFCalendarCopyCurrent();
	NSDateComponents *components = [_currentCalendar components:DATE_COMPONENTS fromDate: date];
	[components setDay:([components day] - ([components weekday] - CFCalendarGetFirstWeekday(currentCalendar) - 7))];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	CFRelease(currentCalendar);
	return [_currentCalendar dateFromComponents:components];
}

- (NSDate *)previousWeekFromDate:(NSDate *)date {
	CFCalendarRef currentCalendar = CFCalendarCopyCurrent();
	NSDateComponents *components = [_currentCalendar components:DATE_COMPONENTS fromDate:date];
	[components setDay:([components day] - ([components weekday] - CFCalendarGetFirstWeekday(currentCalendar) + 7))];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	CFRelease(currentCalendar);
	return [_currentCalendar dateFromComponents:components];
}

@end

@implementation CalendarIPhoneGridViewWeek

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentCalendar = CURRENT_CALENDAR;
        self.backgroundColor = [UIColor blackColor];
        _events = [[NSMutableArray alloc] init];
        
        CGFloat dayTileHeightMonday = 1/3.f;
        CGFloat dayTileHeightTuesday = 1/3.f;
        CGFloat dayTileHeightWednesday = 1/3.f;
        CGFloat dayTileHeightThursday = 0.25f;
        CGFloat dayTileHeightFriday = 0.25f;
        CGFloat dayTileHeightSaturday = 0.25f;
        CGFloat dayTileHeightSunday = 0.25f;
        
        NSArray *leftGrid = @[@(dayTileHeightMonday),@(dayTileHeightTuesday),@(dayTileHeightWednesday)];
        NSArray *rightGrid = @[@(dayTileHeightThursday),@(dayTileHeightFriday),@(dayTileHeightSaturday),@(dayTileHeightSunday)];
        NSArray *dayTilesGrid = [leftGrid arrayByAddingObjectsFromArray:rightGrid];
        _layoutGrid = dayTilesGrid;
        
        
        
        
        [self layoutGrid];
        
        [self setWeek: [self firstDayOfWeekFromDate: [NSDate date]]];
        
        
        
        

        
        
    }
    return self;
}


-(void) layoutGrid
{
    NSDate *currentDate = [NSDate date];
    NSDate *firstWeekDate = [self firstDayOfWeekFromDate:currentDate];
    NSMutableArray *dayTileViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < 7; i++) {
        NSDateComponents *dateComponentsForTile = [[NSDateComponents alloc] init];
        dateComponentsForTile.day = i;
        NSDate *dateForTile = [_currentCalendar dateByAddingComponents:dateComponentsForTile toDate:firstWeekDate options:0];
        
        CalendarDayTileView *calDayTileView = [[CalendarDayTileView alloc] initWithFrame:CGRectMake(0, 0, self.width/2.f, 100.f)];
        calDayTileView.layoutKoef = [_layoutGrid[i] floatValue];
        calDayTileView.delegate = self;
        calDayTileView.weekDay = dateForTile.weekday;
        [self addSubview:calDayTileView];
        [dayTileViews addObject:calDayTileView];
    }
    _dayTileViews = dayTileViews;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    
    CGFloat dayTileWidth = self.width/2.f;
    int index = 0;
    CGFloat x = 0;
    CGFloat y = 0;
    for (CalendarDayTileView *dayTileView in _dayTileViews) {
        long height = dayTileView.layoutKoef*self.height;
        if (y+height > self.height) {
            y= 0;
            x= dayTileWidth;
        }
        
        dayTileView.frame = CGRectMake(x, y, dayTileWidth, height);
        x = dayTileView.x;
        y = dayTileView.yBottom;
        index++;
    }
}

-(void) showCalendarLabels {

    [self fillCalendarLabelsForWeek: _week displayDates: YES];
}



-(WeekEventModel*) eventOnPosition: (CGPoint) position {
    return nil;
}



-(void) drawEvents {
    
    //Adding events to view
    NSMutableDictionary *eventsForDay = [[NSMutableDictionary alloc] init];
    for (WeekEventModel *event in self.events) {
        if ([event.startDate compare:_firstWeekDate] == NSOrderedDescending &&
            [[event.endDate dateByAddingTimeInterval:-60*1] compare:_lastWeekDate] == NSOrderedAscending) {
            
            NSDateComponents *dateComponents = [_currentCalendar components:NSWeekdayCalendarUnit fromDate:event.startDate];
            NSInteger currentWeekDay = dateComponents.weekday;
            
            NSString *key = [NSString stringWithFormat:@"%ld",(long)currentWeekDay];
            if ([eventsForDay objectForKey:key]) {
                NSMutableArray *events = [eventsForDay objectForKey:key];
                [events addObject:event];
            }else{
                NSMutableArray *events = [[NSMutableArray alloc] initWithObjects:event, nil];
                [eventsForDay setObject:events forKey:key];
            }
        }
    }
    
    for (CalendarDayTileView *dayTileView in _dayTileViews) {
        NSArray *events = [eventsForDay objectForKey:[NSString stringWithFormat:@"%d",dayTileView.weekDay]];
        [dayTileView addEvents:events];

    }

}




#pragma mark - Week Navigation


-(void) nextWeek
{
    NSDate *newWeek = [NSDate date];
    newWeek = [self nextWeekFromDate: _week];
    [self setWeek: newWeek];
}

-(void) previousWeek
{
    NSDate *newWeek = [NSDate date];
    newWeek = [self previousWeekFromDate: _week];
    [self setWeek: newWeek];
}

- (void)setWeek:(NSDate *)week
{
    _firstWeekDate = [self firstDayOfWeekFromDate:week];
    _week = _firstWeekDate;
    _lastWeekDate = [self lastDayOfWeekFromDate:week];
    
    [self fillCalendarLabelsForWeek: _week displayDates: YES];
    
    [self drawEvents];
}

#pragma mark -
#pragma mark CalendarDayTileView Delegate

-(void) calendarDayTileView:(CalendarDayTileView *)view didSelectEvent:(WeekEventModel *)event
{
}

-(CGRect) calendarDayTileViewMoving:(CalendarDayTileView *)view withTouch:(UITouch *)touch
{

    _movingDayTileViewIndex = [_dayTileViews indexOfObject:view];
    
    CGPoint point = [touch locationInView:self];
    CGPoint previusPoint = [touch previousLocationInView:self];
    CGFloat deltaY = point.y-previusPoint.y;
    
    if (view.y != 0) {
        CalendarDayTileView *dayTileViewBefore = [_dayTileViews objectAtIndex:_movingDayTileViewIndex-1];
        CGFloat ratio = dayTileViewBefore.height/dayTileViewBefore.layoutKoef;
        
        CGRect dayTileBeforeNewFrame = dayTileViewBefore.frame;
        dayTileBeforeNewFrame.size.height +=deltaY;
        
        CGFloat newKoef = dayTileBeforeNewFrame.size.height/ratio;
        CGFloat difference = dayTileViewBefore.layoutKoef - newKoef;
        CGFloat currentViewNewKoef = view.layoutKoef+difference;
        if ((newKoef + currentViewNewKoef) == (dayTileViewBefore.layoutKoef + view.layoutKoef) &&
            newKoef > 0.1f && currentViewNewKoef > 0.1f) {
            dayTileViewBefore.layoutKoef = newKoef;
            view.layoutKoef = currentViewNewKoef;
            [self setNeedsLayout];
        }
    }
    
    return CGRectZero;
}


@end