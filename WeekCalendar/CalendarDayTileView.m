//
//  CalendarDayTile.m
//  TimePrep
//
//  Created by Marko Strizic on 5/25/13.
//  Copyright (c) 2013 XEE Tech. All rights reserved.
//

#import "CalendarDayTileView.h"
#import "CalendarEventTileView.h"
#import "ImportantDayEventTileView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDate-Utilities.h"


#define FONT(SIZE) [UIFont systemFontOfSize:SIZE]
#define FONT_BOLD(SIZE) [UIFont boldSystemFontOfSize:SIZE]

NSString *const kTitleViewPassedDayImage = @"DayTileTopBarPast";
NSString *const kTitleViewCurrentDayImage = @"DayTileTopBarCurrent";
NSString *const kTitleViewNextDayImage = @"DayTileTopBarNormal";


const float kMarginDayTile = 5.f;


static NSDateFormatter *dateFormatter;

@implementation CalendarDayTileView

@synthesize titleView = _titleView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 53/2.f)];
        _titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _titleView.userInteractionEnabled = YES;
        _titleView.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginDayTile, 0, _titleView.width-2*kMarginDayTile, _titleView.height-2*kMarginDayTile)];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.userInteractionEnabled = YES;
        _titleLabel.center = CGPointMake(_titleView.width/2.f, _titleView.height/2.f);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = FONT(15.f);
        [_titleView addSubview:_titleLabel];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, _titleView.yBottom-2.f, self.width, self.height-_titleView.yBottom+2.f)];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _contentView.backgroundColor = [UIColor blueColor];
        [self insertSubview:_contentView belowSubview:_titleView];
        
        _tableView = [[UITableView alloc] initWithFrame:_contentView.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = [CalendarEventTileView height];
        _tableView.contentInset = UIEdgeInsetsMake(kMarginDayTile/2.f, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_contentView addSubview:_tableView];
        
        [_tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
        self.backgroundColor = [UIColor whiteColor];
        
        if (dateFormatter == Nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat: @"dd-MM cccc"];
//            if (!displayDates) {
//                [dateFormatter setDateFormat: @"cccc"];
//            }
        }
        
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 0.5f;
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
        longGesture.minimumPressDuration = 0.2f;
        longGesture.cancelsTouchesInView = NO;
        [_titleView addGestureRecognizer:longGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        tapGesture.cancelsTouchesInView = NO;
        tapGesture.delaysTouchesEnded = YES;
        [_titleView addGestureRecognizer:tapGesture];
        
        _moverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DayTileMover"]];
        _moverView.userInteractionEnabled = YES;
        [_titleView addSubview:_moverView];
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    _moverView.x = _titleView.width-_moverView.width-8.f;
    _moverView.centerY = _titleView.height/2.f;
    _moverView.hidden = self.y == 0 ? YES : NO;
}


-(void) longGesture:(UILongPressGestureRecognizer*)sender
{
//    [_titleView removeGestureRecognizer:sender];
    _enableMovingTiles = YES;
    [self animateStart];
}

-(void) tapGesture:(UITapGestureRecognizer*)sender
{
    if ([self.delegate respondsToSelector:@selector(calendarDayTileView:didSelectDay:)]) {
        [self.delegate calendarDayTileView:self didSelectDay:_date];
    }
}

-(void) dealloc
{
    [_tableView removeObserver:self forKeyPath:@"contentSize"];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([_tableView isEqual:object] && [keyPath isEqualToString:@"contentSize"]) {
        if (_tableView.contentSize.height>_tableView.height) {
            _tableView.scrollEnabled = YES;
        }else{
            _tableView.scrollEnabled = NO;
        }
    }
}

#pragma mark -
#pragma mark Animations

-(void) animateStart
{
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _titleView.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        _titleView.alpha = 0.9f;
        self.alpha = 0.5f;
    } completion:^(BOOL finished) {
    }];
}

-(void) animateEnd
{
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _titleView.transform = CGAffineTransformIdentity;
        _titleView.alpha = 1.f;
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
    }];
}


#pragma mark -
#pragma mark Touch Delegates

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
//    [self animateStart];
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint point = [touch locationInView:self.superview];
    _deltaY = point.y;
    
}


-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.y == 0) {
        return;
    }

    if (_enableMovingTiles) {
        
        if ([self.delegate respondsToSelector:@selector(calendarDayTileViewMoving:withTouch:)]) {
            UITouch *touch = [[touches allObjects] objectAtIndex:0];
            [self.delegate calendarDayTileViewMoving:self withTouch:touch];
        }
        
    }

}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    _enableMovingTiles = NO;
    NSLog(@"isMovingTopBorder = NO");
    [self animateEnd];
}


#pragma mark -
#pragma mark Public methods

-(void) addEvents:(NSArray*)events
{
    _events = events;
    [self refreshEvents];
}

-(void) configureWithDate:(NSDate *)date
{
    _date = date;
    NSString *dateString = [dateFormatter stringFromDate:date];
    _titleLabel.text = [dateString uppercaseString];
    
//    _titleLabel.text = title;
    if ([date isToday]) {
        _titleView.image = [[UIImage imageNamed:kTitleViewCurrentDayImage] resizableImageWithCapInsets:UIEdgeInsetsMake(5.f, 1.f, 5.f, 1.f)];
        _contentView.backgroundColor = COLOR_DAYTILE_LIGHT_BLUE;
        _titleLabel.textColor = [UIColor whiteColor];
    }else if ([date isLaterThanDate:[NSDate date]])
    {
        _titleView.image = [[UIImage imageNamed:kTitleViewNextDayImage] resizableImageWithCapInsets:UIEdgeInsetsMake(5.f, 1.f, 5.f, 1.f)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _titleLabel.textColor = COLOR_DAYTILE_DARK_GREY;
    }else{
        _titleView.image = [[UIImage imageNamed:kTitleViewPassedDayImage] resizableImageWithCapInsets:UIEdgeInsetsMake(0.f, 1.f, 0.f, 1.f)];
        _contentView.backgroundColor = COLOR_DAYTILE_LIGHT_GREY;
        _titleLabel.textColor = COLOR_DAYTILE_DARK_GREY;
    }
}

-(void) refreshEvents
{
    WeekEventModel *importantEvent;
    for (WeekEventModel *event in _events) {
        if (event.eventState == WeekEventTypeAllDay) {
            importantEvent = event;
            break;
        }
    }
    if (importantEvent) {
        NSMutableArray *mutEvents = [NSMutableArray arrayWithArray:_events];
        [mutEvents removeObject:importantEvent];
        [mutEvents insertObject:importantEvent atIndex:0];
        _events = mutEvents;
    }
    [_tableView reloadData];
}


#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    WeekEventModel *event = _events[indexPath.row];
    if (event.eventType == WeekEventTypeAllDay) {
        ImportantDayEventTileView *importantCell = [ImportantDayEventTileView cellForTableView:tableView];
        [importantCell configureWithEvent:event];
        cell = importantCell;
    }else{
        CalendarEventTileView *eventCell = [CalendarEventTileView cellForTableView:tableView];
        [eventCell configureWithEvent:event];
        cell = eventCell;
    }
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(calendarDayTileView:didSelectEvent:)]) {
        [self.delegate calendarDayTileView:self didSelectEvent:[_events objectAtIndex:indexPath.row]];
    }
}

@end
