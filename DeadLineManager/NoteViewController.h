//
//  NoteViewController.h
//  DeadLineManager
//
//  Created by cookie on 15/9/13.
//  Copyright (c) 2015年 cookie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoteViewDelegate

- (void)noteFinshEdit:(NSString*) noteString;

@end

@interface NoteViewController : UIViewController

@property (strong,nonatomic) id<NoteViewDelegate>delegate;
@property (strong,nonatomic) NSMutableString* note;

@end
