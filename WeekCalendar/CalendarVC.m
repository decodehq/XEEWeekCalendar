//
//  CalendarVC.m
//  WeekCalendar
//
//  Created by Marko Strizic on 08/11/13.
//  Copyright (c) 2013 XEE Tech. All rights reserved.
//

#import "CalendarVC.h"
#import "CalendarIPhoneWeekView.h"

@interface CalendarVC ()

@end

@implementation CalendarVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Week Calendar Example";
    
    CGFloat offsetY = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 64.f : 0.f;
    CGRect frame = CGRectMake(0, offsetY, self.view.width, self.view.height-offsetY);
    
    CalendarIPhoneWeekView *calendarIphoneWeekView = [[CalendarIPhoneWeekView alloc] initWithFrame:frame];
    calendarIphoneWeekView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:calendarIphoneWeekView];
    [calendarIphoneWeekView showControlsInView:self.navigationController.navigationBar];
    
    calendarIphoneWeekView.events = [self fakeEventsForCalendar];
    [calendarIphoneWeekView refreshEvents];
    
    
    NSString *title = @"Carefully prepared for Arc90";
    NSString *subtitle = @"This is a custom week calendar for iPhone and iPad. It presents just a small piece of our knowledge. Hope you like it.";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:subtitle delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:@"About Us", nil];
    alertView.delegate = self;
    [alertView show];
    
}

-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSLog(@"%@",self.view);
}

-(NSArray*) fakeEventsForCalendar
{
    NSDate *currentDate = [NSDate date];
    
    NSInteger eventDuration = 60*60*1.5;
    
    NSMutableArray *events = [[NSMutableArray alloc] init];
    for (int index = 0; index<80; index++) {
        WeekEventModel *event = [[WeekEventModel alloc] init];
        event.title = [NSString stringWithFormat:@"Event Title N.%d",index];
        event.notes = @"Some notes for each event.";
        NSTimeInterval number = arc4random()%(INT16_MAX*60*15);
        event.startDate = [currentDate dateByAddingTimeInterval:number];
        event.endDate = [event.startDate dateByAddingTimeInterval:eventDuration];
        event.eventState = WeekEventStateNormal;
        event.eventType = WeekEventTypeNormal;
        [events addObject:event];
    }
    return events;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark AlertView Delegate

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://xeetech.com"]];
    }
}

@end
