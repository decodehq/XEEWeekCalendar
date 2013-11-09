//
//  ModalView.m
//  TimePrep
//
//  Created by Marko Strizic on 5/24/13.
//  Copyright (c) 2013 XEE Tech. All rights reserved.
//

#import "ModalView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ModalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [[UIImage imageNamed:@"FrameBorder"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.f, 20.f, 20.f, 20.f)];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundImageView.image = image;
        [self addSubview:backgroundImageView];
        
        _overlayView = [[UIControl alloc] init];
        [_overlayView addTarget:self action:@selector(removeFromSuperviewAnimated) forControlEvents:UIControlEventTouchDown];
        _overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
    }
    return self;
}


-(id) initWithContentView:(UIView*)contentView showingPoint:(CGPoint)point
{
    if (self = [self initWithFrame:CGRectMake(point.x, point.y, contentView.width+12.f, contentView.height+12.f)]) {
        self.center = point;
        contentView.layer.cornerRadius = 2.f;
        contentView.center = CGPointMake(self.width/2.f, self.height/2.f);
        [self addSubview:contentView];
    }
    return self;
}

-(void) presentInView:(UIView*)view onWillPresent:(BlockModalViewWillPresent)blockWillPresent onWillDismiss:(BlockModalViewWillDismiss)blockWillDismiss
{
    [view addSubview:self];
    _blockWillPresent = blockWillPresent;
    _blockWillDismiss = blockWillDismiss;
}


-(void) willMoveToSuperview:(UIView *)newSuperview
{
    if (_blockWillPresent) {
        _blockWillPresent(self);
    }
    _overlayView.alpha = 0.f;
    _overlayView.frame = newSuperview.bounds;
    [newSuperview addSubview:_overlayView];
    
    [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.6f animations:^{
        _overlayView.alpha = 1.f;
    }];
}

-(void) removeFromSuperviewAnimated
{
    if (_blockWillDismiss) {
        _blockWillDismiss(self);
    }
    [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
    }];
    [UIView animateWithDuration:0.6f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        _overlayView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}




@end
