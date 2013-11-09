//
//  P1STableViewCell.h
//
//  Created by Marko Strizic on 1/23/13.
//  Copyright (c) 2013 XEE Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XEETableViewCell : UITableViewCell

+(id) cellForTableView:(UITableView*)tableView;
+(NSString*) identifier;
+ (CGFloat)height;
+ (CGFloat)width;
+ (CGSize)size;

@end
