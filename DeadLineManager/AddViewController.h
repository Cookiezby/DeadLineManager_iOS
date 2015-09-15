//
//  AddViewController.h
//  DeadLineManager
//
//  Created by cookie on 15/9/15.
//  Copyright (c) 2015年 cookie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteViewController.h"

@interface AddViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NoteViewDelegate>

@property (strong,nonatomic) NSMutableString* note;

@end
