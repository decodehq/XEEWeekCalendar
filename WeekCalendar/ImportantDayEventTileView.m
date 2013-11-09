//
//  ImportantDayEventTileView.m
//  TimePrep
//
//  Created by Marko Strizic on 5/26/13.
//  Copyright (c) 2013 XEE Tech. All rights reserved.
//

#import "ImportantDayEventTileView.h"
#import <QuartzCore/QuartzCore.h>

#define COLOR_DAYTILE_DARK_BLUE UIColorFromRGB(0x40528a)

#define FONT(SIZE) [UIFont systemFontOfSize:SIZE]
#define FONT_BOLD(SIZE) [UIFont boldSystemFontOfSize:SIZE]


@implementation ImportantDayEventTileView

const float kMargin = 5.f;


-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.height = 20.f+kMargin;
        self.width = W_WIDTH/2.f;
        
        UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(kMargin, kMargin/4.f, self.width-2*kMargin, self.height-kMargin/2.f)];
        borderView.layer.cornerRadius = 2.f;
        borderView.layer.borderWidth = 1.5f;
        borderView.layer.borderColor = [UIColor redColor].CGColor;
        [self addSubview:borderView];
        
        self.textLabel.text = @"All day event";
        self.textLabel.font = FONT(14.f);
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = COLOR_DAYTILE_DARK_BLUE;
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return self;
}

-(void) configureWithEvent:(WeekEventModel*)event
{
    self.textLabel.text = event.title;
}

@end
