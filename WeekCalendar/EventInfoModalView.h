//
//  DetailModalView.h
//  TimePrep
//
//  Created by Marko Strizic on 7/20/12.
//  Copyright (c) 2013 XEE Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekEventModel.h"

@class EventInfoModalView;
typedef void (^BlockEventInfoView)(EventInfoModalView *view);
//typedef void (^BlockEventInfoViewCompleted)(ModalView *view);


@interface EventInfoModalView : UIView{
    UIButton *_buttonCompleted;
    UIButton *_buttonFailed;
    WeekEventModel *_event;
    UIControl *_overlayView;
    BlockEventInfoView _blockCompleteAction;
    BlockEventInfoView _blockFailAction;
    BlockEventInfoView _blockWillPresent;
    BlockEventInfoView _blockWillDismiss;
    
}


-(id) initWithEvent:(WeekEventModel*) event;
-(void) presentInView:(UIView*)view
     onCompleteAction:(BlockEventInfoView)blockComplete
         onFailAction:(BlockEventInfoView)blockFail
        onWillPresent:(BlockEventInfoView)blockPresent
        onWillDismiss:(BlockEventInfoView)blockDismiss;

@property (nonatomic, strong) WeekEventModel *event;

@end
