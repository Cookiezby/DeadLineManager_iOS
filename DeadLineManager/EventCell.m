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
@property (strong,nonatomic) IBOutlet UILabel* eventPriority;


@end


@implementation EventCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    //[self addSubview:self.eventName];
    //[self addSubview:self.eventDaysLeft];
    //[self addSubview:self.eventPriority];
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

- (void)setLabel:(NSMutableDictionary*)values{
    self.eventName.text = values[@"eventname"];
    self.eventPriority.text = values[@"eventpriority"];
    self.eventDaysLeft.text = values[@"eventdeadline"];
}
    



@end
