//
//  CalendarIPhoneWeekView.m
//  TimePrep
//
//  Created by Marko Strizic on 7/18/12.
//  Copyright (c) 2013 XEE Tech. All rights reserved.
//

#import "CalendarIPhoneWeekView.h"


#define MARGIN 10
#define POPOVER_WIDTH 280
#define POPOVER_HEIGHT 300

@implementation CalendarIPhoneWeekView


-(id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftAction:)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        swipeLeft.delaysTouchesBegan = NO;
        [self addGestureRecognizer:swipeLeft];
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightAction:)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        swipeRight.delaysTouchesBegan = NO;
        [self addGestureRecognizer:swipeRight];
        
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    if (_controlsFrame) {
        _controlsFrame.center = CGPointMake(_controlsFrame.superview.width/2.f, _controlsFrame.superview.height/2.f);
    }
}


-(void) refreshEvents{
    [self drawEvents];
}

-(void) showControlsInView:(UIView *)view{
    
    UIView *controlsFrame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 35)];
    controlsFrame.backgroundColor = [UIColor clearColor];
    controlsFrame.center = CGPointMake(view.width/2.f, view.height/2.f);

    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed: @"calendar_button_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0.f, 0, 30.f, 30.f);
    backButton.centerY = controlsFrame.height/2.f;
    [controlsFrame addSubview:backButton];

    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setImage:[UIImage imageNamed: @"calendar_button_right"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [controlsFrame addSubview:nextButton];
    [nextButton sizeToFit];
    nextButton.frame = CGRectMake(0.f, 0, 30.f, 30.f);
    nextButton.centerY = controlsFrame.height/2.f;
    nextButton.x = controlsFrame.width-nextButton.width;
    [view addSubview:controlsFrame];
    
    [view setUserInteractionEnabled:YES];
    _controlsFrame = controlsFrame;
}


#pragma mark -
#pragma mark Navigation

-(void) nextButtonAction:(UIButton*)sender
{
    [self animationNextWeek];
    [self nextWeek];
}

-(void) backButtonAction:(UIButton*)sender
{
    [self animationPreviousWeek];
    [self previousWeek];
}

-(void) swipeLeftAction:(UISwipeGestureRecognizer*)sender
{
    [self animationNextWeek];
    [self nextWeek];}

-(void) swipeRightAction:(UISwipeGestureRecognizer*)sender
{
    [self animationPreviousWeek];
    [self previousWeek];
}

-(void) animationNextWeek
{
    self.layer.rasterizationScale = RASTERIZATION_SCALE;
    self.layer.shouldRasterize = YES;
    [UIView transitionWithView: self
                      duration: 0.4f
                       options: UIViewAnimationOptionTransitionCurlUp
                    animations: ^{
                    }
                    completion:^(BOOL finished){
                        self.layer.shouldRasterize = NO;
                    }
     ];

}

-(void) animationPreviousWeek
{
    self.layer.rasterizationScale = RASTERIZATION_SCALE;
    self.layer.shouldRasterize = YES;
    [UIView transitionWithView: self
                      duration: 0.4f
                       options: UIViewAnimationOptionTransitionCurlDown
                    animations: ^{
                    }
                    completion:^(BOOL finished){
                        self.layer.shouldRasterize = NO;
                    }
     ];

}


#pragma mark -
#pragma mark CalendarDayTileView Delegate

-(void) calendarDayTileView:(CalendarDayTileView *)view didSelectEvent:(WeekEventModel *)event
{
    [self showDetailModalViewForEvent:event fromDayTile:view];
}

-(void) calendarDayTileView:(CalendarDayTileView *)view didSelectDay:(NSDate *)date
{
    NSLog(@"Day selected: %@",date);
}

#pragma mark -
#pragma mark Modal Views

-(void) showDetailModalViewForEvent:(WeekEventModel*)event fromDayTile:(CalendarDayTileView*)dayTileView
{
    EventInfoModalView *detailModal = [[EventInfoModalView alloc] initWithEvent:event];
    [detailModal presentInView:self.window.rootViewController.view onCompleteAction:^(EventInfoModalView *view) {
        //update completed event
    } onFailAction:^(EventInfoModalView *view) {
        //implement on fail action
    } onWillPresent:^(EventInfoModalView *view) {
        //Select eventView
    } onWillDismiss:^(EventInfoModalView *view) {
        //Deselect eventView
    }];
    
}

@end
