//
//  P1STableViewCell.m
//  Squee2
//
//  Created by Marko Strizic on 1/23/13.
//  Copyright (c) 2013 XEE Tech. All rights reserved.
//

#import "XEETableViewCell.h"

@implementation XEETableViewCell

static NSMutableDictionary *s_cellSizes;


+(NSString*) identifier{
    return NSStringFromClass([self class]);
}

+(id) cellForTableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self identifier]];
    if (!cell) {
        if (!s_cellSizes) {
            s_cellSizes = [[NSMutableDictionary alloc] init];
        }
        cell = [[[self class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self identifier]];
    }
    return cell;
}

+ (CGFloat)height
{
    return [self size].height;
}

+ (CGFloat)width
{
    return [self size].width;
}

+ (CGSize)size
{
    // Cache the cell size; this way the user does pay the same performance penalty for height whether she
    // sets the UITableView rowHeight property or uses the row height callback
    NSValue *cellSizeValue = [s_cellSizes objectForKey:NSStringFromClass([self class])];
    if (! cellSizeValue) {
        // Instantiate a dummy cell
        UITableViewCell *cell = [self cellForTableView:nil];
        cellSizeValue = [NSValue valueWithCGSize:cell.bounds.size];
        [s_cellSizes setObject:cellSizeValue forKey:NSStringFromClass([self class])];
    }
    return [cellSizeValue CGSizeValue];
}

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
