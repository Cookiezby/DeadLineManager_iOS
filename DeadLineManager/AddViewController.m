//
//  AddThingViewController.m
//  DeadLineManager
//
//  Created by cookie on 15/9/13.
//  Copyright (c) 2015年 cookie. All rights reserved.
//

#import "AddViewController.h"
#import "Masonry.h"
#import "DBManager.h"

@interface AddViewController ()


@property (strong,nonatomic) DBManager* dbManager;
@property (strong,nonatomic) IBOutlet UITableView* tableView;
@property (strong,nonatomic) UIDatePicker* datePicker;
@property (strong,nonatomic) UITextField* eventNameTextField;
@property (strong,nonatomic) NSString* eventName;
@property (strong,nonatomic) NSDate* date;
@property (strong,nonatomic) UIButton* showTagRowButton;

@property (strong,nonatomic) UIButton* tagButton_1;
@property (strong,nonatomic) UIButton* tagButton_2;
@property (strong,nonatomic) UIButton* tagButton_3;
@property (nonatomic)NSInteger eventPriority;

@property (strong,nonatomic) NSDate* deadLine;


@property CGFloat datePickerCellHeight;
@property CGFloat tagCellHeight;

@end

@implementation AddViewController

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
    self.dbManager = [[DBManager alloc]initWithDatabaseFilename:@"event.sql"];
    self.note = [NSMutableString stringWithFormat:@"%@",@""];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.datePickerCellHeight = 0;
    self.tagCellHeight = 0;
    
    
    self.datePicker  = [UIDatePicker new];
    self.datePicker.alpha = 0;
    [self.datePicker addTarget:self action:@selector(updateDateCell:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.minimumDate = [NSDate date];
    
    self.deadLine = [NSDate date];
    
    self.eventNameTextField = [UITextField new];
    self.showTagRowButton = [UIButton new];
    [self.showTagRowButton addTarget:self action:@selector(showTagCellButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tagButton_1 = [UIButton new];
    self.tagButton_2 = [UIButton new];
    self.tagButton_3 = [UIButton new];
    self.tagButton_1.tag = 100;
    self.tagButton_2.tag = 101;
    self.tagButton_3.tag = 102;
    self.tagButton_1.backgroundColor = [UIColor greenColor];
    self.tagButton_2.backgroundColor = [UIColor yellowColor];
    self.tagButton_3.backgroundColor = [UIColor redColor];
    [self.tagButton_1 addTarget:self action:@selector(tagCellButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.tagButton_2 addTarget:self action:@selector(tagCellButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.tagButton_3 addTarget:self action:@selector(tagCellButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.eventPriority = 2;
}

- (IBAction)showTagCellButton:(id)sender{
    self.tagCellHeight = self.tagCellHeight == 0 ? 44:0;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    self.tagCellHeight != 0 ? [self showTagCell]:[self hideTagCell];
}

- (IBAction)tagCellButton:(id)sender{
    UIButton* button = (UIButton*)sender;
    switch (button.tag) {
        case 100:
            self.eventPriority = 0;
            self.showTagRowButton.backgroundColor = [UIColor greenColor];
            break;
        case 101:
            self.eventPriority = 1;
             self.showTagRowButton.backgroundColor = [UIColor yellowColor];
            break;
        case 102:
            self.eventPriority = 2;
             self.showTagRowButton.backgroundColor = [UIColor redColor];
            break;
        default:
            break;
    }
}

- (IBAction)updateDateCell:(id)sender{
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    self.deadLine = self.datePicker.date;
    cell.detailTextLabel.text = [self dateString:self.deadLine];
}

- (void)showTagCell{
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell addSubview:self.tagButton_1];
    [cell addSubview:self.tagButton_2];
    [cell addSubview:self.tagButton_3];
    
    [self.tagButton_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.top.equalTo(@10);
        make.left.equalTo(@20);
        
    }];
    [self.tagButton_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.top.equalTo(@10);
        make.center.equalTo(cell);
        
    }];
    [self.tagButton_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.top.equalTo(@10);
        make.right.equalTo(@-20);
        
    }];
    
}

- (void)hideTagCell{
    [self.tagButton_1 removeFromSuperview];
    [self.tagButton_2 removeFromSuperview];
    [self.tagButton_3 removeFromSuperview];
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

- (NSString*)dateString:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents* dateCompontents = [calendar components:(NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit) fromDate:date];
    NSString* dateString = [NSString stringWithFormat:@"%ld/%ld/%ld",dateCompontents.year,dateCompontents.month,(long)dateCompontents.day];
    return dateString;
}

- (IBAction)saveEvent:(id)sender{
    
    
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateString = [dateformatter stringFromDate:self.date];
    NSString* query = [NSString stringWithFormat:@"insert into event values(null, '%@', '%ld', '%@' , '%@')",self.eventNameTextField.text,self.eventPriority,self.note,dateString];
    
    NSLog(@"%@",dateString);
    
    [self.dbManager executeQuery:query];
    
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
    
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

- (IBAction)cancelEvent:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

#pragma mark - NoteViewDelegate

- (void)noteFinshEdit:(NSString* )noteString{
    self.note = [[NSMutableString alloc]initWithFormat:@"%@",noteString];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:self.eventNameTextField];
        self.eventNameTextField.placeholder = @"EventName";
        [self.eventNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell).with.insets(UIEdgeInsetsMake(2, 15, 2, 50));
            //top left bottom right
        }];
        self.showTagRowButton.backgroundColor = [UIColor redColor];
        [cell addSubview:self.showTagRowButton];
        [self.showTagRowButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(24, 24));
            make.top.equalTo(@10);
            make.right.equalTo(@-20);
        }];
    }
    if([indexPath compare:[NSIndexPath indexPathForRow:1 inSection:0]]==NSOrderedSame) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if([indexPath compare:[NSIndexPath indexPathForRow:2 inSection:0]]==NSOrderedSame){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Value1Cell"];
        cell.textLabel.text = @"Description";
        cell.detailTextLabel.text = @"Add";
    }
    if([indexPath compare:[NSIndexPath indexPathForRow:0 inSection:1]]==NSOrderedSame) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Value1Cell"];
        cell.textLabel.text = @"DeadLine";
        cell.detailTextLabel.text = [self dateString:self.deadLine];
    }
    if([indexPath compare:[NSIndexPath indexPathForRow:1 inSection:1]]==NSOrderedSame){
        
    }
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([indexPath compare:[NSIndexPath indexPathForRow:0 inSection:0]]==NSOrderedSame){
        
    }
    if([indexPath compare:[NSIndexPath indexPathForRow:1 inSection:0]]==NSOrderedSame){
        
    }
    if([indexPath compare:[NSIndexPath indexPathForRow:2 inSection:0]]==NSOrderedSame) {
        [self performSegueWithIdentifier:@"addNoteSegue" sender:self];
    }
    if([indexPath compare:[NSIndexPath indexPathForRow:0 inSection:1]]==NSOrderedSame) {
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
        NoteViewController* noteViewController = segue.destinationViewController;
        noteViewController.delegate = self;
        noteViewController.note = [NSMutableString stringWithFormat:@"%@",self.note];
    }
}


@end
