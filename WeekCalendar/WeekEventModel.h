//
//  WeekEventModel.h
//  WeekCalendar
//
//  Created by Marko Strizic on 08/11/13.
//  Copyright (c) 2013 XEE Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    WeekEventStateCompleted,
    WeekEventStateFailed,
    WeekEventStateNormal
}WeekEventState;

typedef enum{
    WeekEventTypeNormal,
    WeekEventTypeAllDay
}WeekEventType;

@interface WeekEventModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) WeekEventState eventState;
@property (nonatomic, assign) WeekEventType eventType;


@end
