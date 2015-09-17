//
//  EventCell.m
//  DeadLineManager
//
//  Created by cookie on 15/9/16.
//  Copyright (c) 2015年 cookie. All rights reserved.
//

#import "EventCell.h"
#import  "Masonry.h"

@interface EventCell()

@property (strong,nonatomic) IBOutlet UILabel* eventName;
@property (strong,nonatomic) IBOutlet UILabel* eventDaysLeft;
@property (weak, nonatomic) IBOutlet UIImageView *eventPriorityImage;

@property (nonatomic)NSInteger eventID;
@property (nonatomic)NSInteger eventPriority;

@end


@implementation EventCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)initProperty{
   
    
    
}

+ (UINib*)nib{
    return [UINib nibWithNibName:@"EventCell" bundle:[NSBundle mainBundle]];
}

- (void)setCell:(NSMutableDictionary*)values{
    self.eventName.text = values[@"eventname"];
    self.eventDaysLeft.text = values[@"eventdeadline"];
    self.eventPriority = [values[@"eventpriority"] integerValue];
    self.eventID = [values[@"event_id"]integerValue];
    
    switch (self.eventPriority) {
        case 0:
            self.eventPriorityImage.image = [UIImage imageNamed:@"circleGreen"];
            break;
        case 1:
            self.eventPriorityImage.image = [UIImage imageNamed:@"circleYellow"];
            break;
        case 2:
            self.eventPriorityImage.image = [UIImage imageNamed:@"circleRed"];

            break;
        default:
            break;
    }

}
    



@end
