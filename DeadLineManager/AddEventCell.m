//
//  AddThingsCell.m
//  ZBYToDoList
//
//  Created by cookie on 15/9/5.
//  Copyright (c) 2015年 cookie. All rights reserved.
//

#import "AddEventCell.h"

@implementation AddEventCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.textField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTextFieldPlaceHolderWithIndex:(NSIndexPath*)indexPath{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    self.textField.placeholder = @"EventName";
                   break;
                case 1:
                    self.textField.placeholder = @"Place";
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

+ (UINib*) getNib{
    return [UINib nibWithNibName:@"AddEventCell" bundle:[NSBundle mainBundle]];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField resignFirstResponder];
    return NO;
}

@end
