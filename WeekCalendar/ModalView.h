//
//  ModalView.h
//  TimePrep
//
//  Created by Marko Strizic on 5/24/13.
//  Copyright (c) 2013 XEE Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModalView;
typedef void (^BlockModalViewWillDismiss)(ModalView *view);
typedef void (^BlockModalViewWillPresent)(ModalView *view);


@interface ModalView : UIView{
    UIControl *_overlayView;
    BlockModalViewWillPresent _blockWillPresent;
    BlockModalViewWillDismiss _blockWillDismiss;
}

-(id) initWithContentView:(UIView*)contentView showingPoint:(CGPoint)point;

-(void) presentInView:(UIView*)view onWillPresent:(BlockModalViewWillPresent)blockWillPresent onWillDismiss:(BlockModalViewWillDismiss)blockWillDismiss;
-(void) removeFromSuperviewAnimated;


@end
