//
//  DetailModalView.m
//  TimePrep
//
//  Created by Marko Strizic on 7/20/12.
//  Copyright (c) 2013 XEE Tech. All rights reserved.
//

#import "EventInfoModalView.h"

#define MARGIN 10.f
#define VIEW_FRAME CGRectMake(0, 0, 280, 255)
#define WIDTH VIEW_FRAME.size.width - 2*MARGIN

#define FONT(SIZE) [UIFont systemFontOfSize:SIZE]
#define FONT_BOLD(SIZE) [UIFont boldSystemFontOfSize:SIZE]
#define BLUE_COLOR [UIColor colorWithRed: 1.0f/255 green: 39.0f/255 blue: 80.0f/255 alpha: 1.0]


#define COLOR_TIME_DARK_BLUE UIColorFromRGB(0x40528a)

@implementation EventInfoModalView

@synthesize event = _event;


-(id) initWithEvent:(WeekEventModel*) event{
    if (self = [super init]) {
        
        _event = event;
        
        UIView *contentView = [self contentView];

        UIView *borderView = [self borderViewWithFrame:contentView.frame];
        contentView.center = CGPointMake(borderView.width/2.f, borderView.height/2.f);
        [borderView addSubview:contentView];
        
        [self addSubview:borderView];
        self.frame = borderView.bounds;
        _overlayView = [self overlayView];
        self.layer.rasterizationScale = RASTERIZATION_SCALE;
    }
    return self;
}

-(void) presentInView:(UIView*)view
     onCompleteAction:(BlockEventInfoView)blockComplete
         onFailAction:(BlockEventInfoView)blockFail
        onWillPresent:(BlockEventInfoView)blockPresent
        onWillDismiss:(BlockEventInfoView)blockDismiss;
{
    [view addSubview:self];
    _blockCompleteAction = blockComplete;
    _blockFailAction = blockFail;
    _blockWillDismiss = blockDismiss;
    _blockWillPresent = blockPresent;
}



-(UIView*) borderViewWithFrame:(CGRect)frame
{
    UIImage *image = [[UIImage imageNamed:@"FrameBorder"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.f, 20.f, 20.f, 20.f)];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundImageView.userInteractionEnabled = YES;
    backgroundImageView.frame = CGRectMake(0, 0, frame.size.width+10.f, frame.size.height+10.f);
    backgroundImageView.image = image;
    return backgroundImageView;
}

-(UIControl*) overlayView
{
    UIControl *overlayView = [[UIControl alloc] init];
    [overlayView addTarget:self action:@selector(removeFromSuperviewAnimated) forControlEvents:UIControlEventTouchDown];
    overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
    return overlayView;
}

#pragma mark -
#pragma mark Drawing Frame

-(UIView*) contentView{
    
    UIView *view = [[UIView alloc] initWithFrame:VIEW_FRAME];
    view.backgroundColor = [UIColor colorWithWhite:0.7f alpha:0.95f];
    
    
    BOOL is24HoursFormat = YES;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterShortStyle;
    //formatter.dateFormat = @"hh:mm";
    NSString *startTime = [formatter stringFromDate:_event.startDate];
    if ([startTime rangeOfString:@"PM"].location != NSNotFound || [startTime rangeOfString:@"AM"].location != NSNotFound) {
        is24HoursFormat = NO;
    }
    NSString *endTime = [formatter stringFromDate:_event.endDate];
    NSString *title = _event.title;
    NSString *subtitle = _event.notes;
    

    //Title
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, view.width-4*MARGIN, 40)];
    titleView.userInteractionEnabled = NO;
    titleView.font = FONT_BOLD(18.f);
    titleView.textColor = BLUE_COLOR;
    titleView.backgroundColor = [UIColor clearColor];
    titleView.numberOfLines = 0;
    titleView.text = title;
    titleView.height = [title sizeWithFont:titleView.font constrainedToSize:CGSizeMake(titleView.width, 150.f)].height;
    [view addSubview:titleView];
    

    //Subtitle
    UILabel *subtitleView = [[UILabel alloc]
                                initWithFrame:CGRectMake(MARGIN,titleView.yBottom+MARGIN,WIDTH, 50)];
    subtitleView.userInteractionEnabled = NO;
    subtitleView.font = FONT(15.f);
    subtitleView.textColor = BLUE_COLOR;
    subtitleView.backgroundColor = [UIColor clearColor];
    subtitleView.numberOfLines = 0;
    subtitleView.text = subtitle;
    subtitleView.height = [subtitle sizeWithFont:subtitleView.font constrainedToSize:CGSizeMake(subtitleView.width, 150.f)].height;
    [view addSubview:subtitleView];
    
    //Frame for showing time
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN, subtitleView.y+subtitleView.height+MARGIN, WIDTH, 22)];
    timeView.backgroundColor = [UIColor clearColor];
    
    UIImageView *timeContainer1 = [[UIImageView alloc] init];
    timeContainer1.backgroundColor = COLOR_TIME_DARK_BLUE;
    timeContainer1.layer.cornerRadius = 2.f;
    CGRect frame = timeContainer1.frame;
    frame.size = is24HoursFormat ? CGSizeMake(58, 22) : CGSizeMake(90, 22);
    timeContainer1.frame = frame;
    [timeView addSubview:timeContainer1];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(timeContainer1.x + timeContainer1.width+4, timeContainer1.height/2, 10, 2)];
    line.backgroundColor = BLUE_COLOR;
    [timeView addSubview:line];
    
    UIImageView *timeContainer2 = [[UIImageView alloc] init];
    timeContainer2.backgroundColor = timeContainer1.backgroundColor;
    timeContainer2.layer.cornerRadius = timeContainer1.layer.cornerRadius;
    frame = timeContainer2.frame;
    frame.origin = CGPointMake(line.xRight+4, 0);
    frame.size = is24HoursFormat ? CGSizeMake(58, 22) : CGSizeMake(90, 22);
    timeContainer2.frame = frame;
    [timeView addSubview:timeContainer2];
    
    UILabel *startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, is24HoursFormat?52:86, 20)];
    startTimeLabel.backgroundColor = [UIColor clearColor];
    startTimeLabel.textColor = [UIColor whiteColor];
    startTimeLabel.textAlignment = NSTextAlignmentCenter;
    startTimeLabel.center = timeContainer1.center;
    startTimeLabel.text = startTime;
    [timeView addSubview:startTimeLabel];
    
    UILabel *endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, is24HoursFormat?52:86, 20)];
    endTimeLabel.backgroundColor = [UIColor clearColor];
    endTimeLabel.textColor = [UIColor whiteColor];
    endTimeLabel.textAlignment = NSTextAlignmentCenter;
    endTimeLabel.center = timeContainer2.center;
    endTimeLabel.text = endTime;
    [timeView addSubview:endTimeLabel];
    
    [view addSubview:timeView];
    
    //Event status frame
    UIImageView *eventStatusFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"event_status_frame"]];
    eventStatusFrame.frame = CGRectMake(MARGIN, timeView.yBottom+2*MARGIN, view.width-2*MARGIN, eventStatusFrame.image.size.height);
    [view addSubview:eventStatusFrame];
    
    UILabel *eventStatus = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 35)];
    eventStatus.textColor = [UIColor grayColor];
    eventStatus.backgroundColor = [UIColor clearColor];
    eventStatus.font = FONT_BOLD(20.f);
    eventStatus.textAlignment = NSTextAlignmentCenter;
    eventStatus.center = eventStatusFrame.center;
    
    switch (_event.eventState) {
        case WeekEventStateNormal:
            eventStatus.text = @"Current";
            break;
        case WeekEventStateCompleted:
            eventStatus.text = @"Completed";
            break;
        case WeekEventStateFailed:
            eventStatus.text = @"Failed";
            break;
        default:
            eventStatus.text = @"";
            break;
    }
    [view addSubview:eventStatus];
    
    //Buttons
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"x_button"] forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(view.width-50, -10, 60, 60);

    [closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeButton];
    
    if (_event.eventState != WeekEventStateFailed && _event.eventState != WeekEventStateCompleted) {
        
        UIButton *buttonCompleted = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonCompleted.frame = CGRectMake(5, eventStatus.yBottom + MARGIN, 130, 50);
        [buttonCompleted setImage:[UIImage imageNamed:@"cfa_completed_iPhone"] forState:UIControlStateNormal];
        [buttonCompleted addTarget:self action:@selector(buttonCompleted:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:buttonCompleted];
        
        UIButton *buttonFailed = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonFailed.frame = CGRectMake(buttonCompleted.xRight + 10, buttonCompleted.y, 130, 50);
        [buttonFailed setImage:[UIImage imageNamed:@"cfa_failed_iPhone"] forState:UIControlStateNormal];
        [buttonFailed addTarget:self action:@selector(buttonFailed:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:buttonFailed];
        view.height = buttonCompleted.yBottom+MARGIN-7.f;
    }else{
        view.height = eventStatus.yBottom+2*MARGIN;
    }
    return view;
}

-(UIView*) contentViewForImportantDate{
    
    UIView *view = [[UIView alloc] initWithFrame:VIEW_FRAME];
    view.layer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grain_white2"]].CGColor;
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"x_button"] forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(view.width-50, -10, 60, 60);
    [closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeButton];
    
    
    NSString *title = _event.title;

    
    //Title
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, view.width-4*MARGIN, 40)];
//    titleView.xRight = closeButton.x-MARGIN;
    titleView.userInteractionEnabled = NO;
    titleView.font = FONT_BOLD(18.f);
    titleView.textColor = BLUE_COLOR;
    titleView.backgroundColor = [UIColor clearColor];
    titleView.numberOfLines = 0;
    titleView.text = title;
    titleView.height = [title sizeWithFont:titleView.font constrainedToSize:CGSizeMake(titleView.width, 150.f)].height;
    [view addSubview:titleView];
        
    //Event status frame
    UIImageView *eventStatusFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"event_status_frame"]];
    eventStatusFrame.centerX = view.width/2.f;
    eventStatusFrame.y = titleView.yBottom + 2*MARGIN;
    [view addSubview:eventStatusFrame];
    
    UILabel *eventStatus = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 35)];
    eventStatus.textColor = [UIColor grayColor];
    eventStatus.backgroundColor = [UIColor clearColor];
    eventStatus.font = FONT_BOLD(20.f);
    eventStatus.textAlignment = NSTextAlignmentCenter;
    eventStatus.center = eventStatusFrame.center;
    eventStatus.text = @"Important Date";
    [view addSubview:eventStatus];
    
    
    view.height = eventStatusFrame.yBottom+2*MARGIN;
    

    
    return view;
}

#pragma mark -
#pragma mark Animations

-(void) willMoveToSuperview:(UIView *)newSuperview
{
    self.layer.shouldRasterize = YES;
    if (newSuperview == nil) {
        return;
    }
    if (_blockWillPresent) {
        _blockWillPresent(self);
    }
    _overlayView.alpha = 0.f;
    _overlayView.frame = newSuperview.bounds;
    [newSuperview addSubview:_overlayView];
    self.alpha=0.f;
    self.center = CGPointMake(newSuperview.width/2.f, newSuperview.height/2.f);
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        self.layer.shouldRasterize = NO;
    }];
    
    [UIView animateWithDuration:0.6f animations:^{
        _overlayView.alpha = 1.f;
    }];
}

-(void) removeFromSuperviewAnimated
{
    self.layer.shouldRasterize = YES;
    if (_blockWillDismiss) {
        _blockWillDismiss(self);
    }
    [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
    }];
    [UIView animateWithDuration:0.6f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        _overlayView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



#pragma mark -
#pragma mark Buttons Actions

-(void) closeView{
    [self removeFromSuperviewAnimated];
}

-(void) buttonCompleted:(UIButton*)sender{
    if (_blockCompleteAction) {
        _blockCompleteAction(self);
    }
    [self closeView];
}

-(void) buttonFailed:(UIButton*)sender{
    [self closeView];
    if (_blockFailAction) {
        _blockFailAction(self);
    }
}


@end
