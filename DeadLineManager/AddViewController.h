//
//  AddViewController.h
//  DeadLineManager
//
//  Created by cookie on 15/9/15.
//  Copyright (c) 2015年 cookie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteViewController.h"

@protocol AddViewDelegate

- (void)finish;

@end

@interface AddViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NoteViewDelegate,UIGestureRecognizerDelegate>

@property (strong,nonatomic) NSMutableString* eventDetail;
@property (strong,nonatomic)id<AddViewDelegate>delegate;

@property (nonatomic)BOOL editInfo;// if add or edit edit is the update


- (void)setEditValues:(NSMutableDictionary*)values;

@end
