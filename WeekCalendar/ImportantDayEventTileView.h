//
//  ImportantDayEventTileView.h
//  TimePrep
//
//  Created by Marko Strizic on 5/26/13.
//  Copyright (c) 2013 XEE Tech. All rights reserved.
//

#import "XEETableViewCell.h"
#import "WeekEventModel.h"

@interface ImportantDayEventTileView : XEETableViewCell

-(void) configureWithEvent:(WeekEventModel*)event;


@end
