//
//  CalendarIPhoneWeekView.h
//  TimePrep
//
//  Created by Marko Strizic on 7/18/12.
//  Copyright (c) 2013 XEE Tech. All rights reserved.
//
#import "CalendarIPhoneGridViewWeek.h"


#import <Foundation/Foundation.h>

@interface CalendarIPhoneWeekView : CalendarIPhoneGridViewWeek {
    BOOL _isSetup;
    WeekEventModel *_currentEvent;
    float requiredTime;
    float allocatedTime;
}

@property (nonatomic, strong, readonly) UIView *controlsFrame;

-(void) showControlsInView:(UIView*) view;
-(void) refreshEvents;

@end
