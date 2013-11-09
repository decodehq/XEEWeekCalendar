//
//  UIView+Frame.m
//  XEEKit
//
//  Created by Marko Strizic on 10/24/12.
//  Copyright (c) 2013 XEE Tech. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat) height {
    return self.bounds.size.height;
}

- (CGFloat) width {
    return self.bounds.size.width;
}

- (CGFloat) x {
    return self.frame.origin.x;
}

- (CGFloat) y {
    return self.frame.origin.y;
}

- (CGFloat) centerY {
    return self.center.y;
}

- (CGFloat) centerX {
    return self.center.x;
}

- (void) setHeight:(CGFloat) newHeight {
    CGRect frame = self.frame;
    frame.size.height = newHeight;
    self.frame = frame;
}

- (void) setWidth:(CGFloat) newWidth {
    CGRect frame = self.frame;
    frame.size.width = newWidth;
    self.frame = frame;
}

- (void) setX:(CGFloat) newX {
    CGRect frame = self.frame;
    frame.origin.x = newX;
    self.frame = frame;
}

- (void) setY:(CGFloat) newY {
    CGRect frame = self.frame;
    frame.origin.y = newY;
    self.frame = frame;
}

- (void) setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void) setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

-(void) setXRight:(CGFloat)xRight{
    self.width = xRight-self.x;
}

-(CGFloat) xRight{
    return self.frame.origin.x + self.frame.size.width;
}

-(void) setYBottom:(CGFloat)yBottom{
    self.height = yBottom-self.y;
}

-(CGFloat) yBottom{
    return self.frame.origin.y + self.frame.size.height;
}


-(void) sizeToFitSubviews{
    CGFloat width=0;
    CGFloat height=0;
    for (UIView *subView in self.subviews) {
        if (subView.xRight>width) {
            width = subView.xRight;
        }
        if (subView.yBottom > height) {
            height = subView.yBottom;
        }
    }
    self.width = width;
    self.height = height;
}




@end
