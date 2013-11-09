//
//  CalendarEventTile.h
//  TimePrep
//
//  Created by Marko Strizic on 5/25/13.
//  Copyright (c) 2013 XEE Tech. All rights reserved.
//

#import "XEETableViewCell.h"
#import "WeekEventModel.h"


#define COLOR_DAYTILE_LIGHT_GREY UIColorFromRGB(0xdedede)
#define COLOR_DAYTILE_DARK_GREY UIColorFromRGB(0xa0a0a0)
#define COLOR_DAYTILE_DARK_BLUE UIColorFromRGB(0x40528a)
#define COLOR_DAYTILE_LIGHT_BLUE UIColorFromRGB(0xc9d2e3)

#define COLOR_EVENT_COMPLETED UIColorFromRGB(0x199800)
#define COLOR_EVENT_FAILED UIColorFromRGB(0xc51718)

extern const float kMarginEventTile;


@interface CalendarEventTileView : XEETableViewCell
{
    UIImageView *_leftImageView;
    UILabel *_timeLabel;
    UILabel *_titleLabel;
}

-(void) configureWithEvent:(WeekEventModel*)event;


@end

