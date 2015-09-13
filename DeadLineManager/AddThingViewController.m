//
//  AddThingViewController.m
//  DeadLineManager
//
//  Created by cookie on 15/9/13.
//  Copyright (c) 2015年 cookie. All rights reserved.
//

#import "AddEventViewController.h"

@interface AddEventViewController ()

@property (strong,nonatomic) IBOutlet UITableView* tableView;
@property (strong,nonatomic) UIDatePicker* datePicker;
@property (strong,nonatomic) UITextField* eventNameTextField;
@property (strong,nonatomic) NSMutableString* note;
@property (strong,nonatomic) NSString* eventName;
@property (strong,nonatomic) NSDate* date;

@property CGFloat datePickerCellHeight;
@property CGFloat tagCellHeight;

@end

@implementation AddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initProperty];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initProperty{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.datePickerCellHeight = 0;
    self.tagCellHeight = 0;
    
    self.datePicker  = [[UIDatePicker alloc]init];
    self.datePicker.alpha = 0;
   }

- (void)showTagCell{
    
}

- (void)hideTagCell{
    
}

- (void)showDatePickerCell{
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    [cell addSubview:self.datePicker];
    [UIView animateWithDuration:0.5 animations:^(){
        self.datePicker.alpha = 1.0;
    }];
}

- (void)hideDatePickerCell{
    [self.datePicker removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^(){
        self.datePicker.alpha = 0;
    }];

}


- (IBAction)saveEvent:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

- (IBAction)cancelEvent:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath compare:[NSIndexPath indexPathForRow:1 inSection:0]]==NSOrderedSame){
        return self.tagCellHeight;
    }
    if ([indexPath compare:[NSIndexPath indexPathForRow:1 inSection:1]]==NSOrderedSame) {
        return self.datePickerCellHeight;
    }else{
        return 44;
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"StaticCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StaticCell"];
    }
    
    if([indexPath compare:[NSIndexPath indexPathForRow:0 inSection:0]]==NSOrderedSame){
        
    }
    if ([indexPath compare:[NSIndexPath indexPathForRow:1 inSection:0]]==NSOrderedSame) {
    
    }
    if([indexPath compare:[NSIndexPath indexPathForRow:2 inSection:0]]==NSOrderedSame){
        
    }
    if ([indexPath compare:[NSIndexPath indexPathForRow:0 inSection:1]]==NSOrderedSame) {
        
    }
    if([indexPath compare:[NSIndexPath indexPathForRow:1 inSection:1]]==NSOrderedSame){
        
    }
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([indexPath compare:[NSIndexPath indexPathForRow:0 inSection:0]]==NSOrderedSame){
        self.tagCellHeight = self.tagCellHeight == 0 ? 44:0;
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        self.tagCellHeight != 0 ? [self showTagCell]:[self hideTagCell];
    }
    if([indexPath compare:[NSIndexPath indexPathForRow:1 inSection:0]]==NSOrderedSame){
        
    }
    if ([indexPath compare:[NSIndexPath indexPathForRow:2 inSection:0]]==NSOrderedSame) {
        [self performSegueWithIdentifier:@"addNoteSegue" sender:self];
    }
    if ([indexPath compare:[NSIndexPath indexPathForRow:0 inSection:1]]==NSOrderedSame) {
        self.datePickerCellHeight = self.datePickerCellHeight == 0 ? 200:0;
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerCellHeight != 0 ? [self showDatePickerCell]:[self hideDatePickerCell];
    }
    if([indexPath compare:[NSIndexPath indexPathForRow:1 inSection:1]]==NSOrderedSame){
    
        
    }
}






#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addNoteSegue"]) {
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
