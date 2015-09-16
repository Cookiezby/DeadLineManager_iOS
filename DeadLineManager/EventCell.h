//
//  EventCell.h
//  DeadLineManager
//
//  Created by cookie on 15/9/16.
//  Copyright (c) 2015年 cookie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell

+ (UINib*)nib;

- (void)setLabel:(NSMutableDictionary*)values;

@end
