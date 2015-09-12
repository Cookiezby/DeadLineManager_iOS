//
//  AddToDoThingViewController.h
//  ZBYToDoList
//
//  Created by cookie on 15/9/4.
//  Copyright (c) 2015年 cookie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEventCell.h"


@protocol  EventAddFinished



@end


@interface AddEventViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate >
@end
