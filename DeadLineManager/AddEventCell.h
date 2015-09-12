//
//  AddThingsCell.h
//  ZBYToDoList
//
//  Created by cookie on 15/9/5.
//  Copyright (c) 2015年 cookie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddEventCell : UITableViewCell <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;



+ (UINib*) getNib;
- (void)setTextFieldPlaceHolderWithIndex: (NSIndexPath*)indexPath;


@end


