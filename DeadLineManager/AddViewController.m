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

@property (nonatomic)NSInteger eventID;
@property (strong,nonatomic) NSDate* deadLine;


@property CGFloat datePickerCellHeight;
@property CGFloat tagCellHeight;
@property (strong,nonatomic)NSMutableDictionary* propertyValues;


@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initProperty];
    [self addTap];
    if (self.editInfo && self.propertyValues!=nil) {
        self.eventID = [self.propertyValues[@"event_id"]integerValue];
        self.eventNameTextField.text = self.propertyValues[@"eventname"];
        self.eventDetail = self.propertyValues[@"eventdetail"];
        self.datePicker.date = [self dateOffset:[NSDate date] offset:[self.propertyValues[@"eventdeadline"] integerValue]+1];
        self.eventPriority = [self.propertyValues[@"eventpriority"]integerValue];
        [self setPriorityTagColor:self.eventPriority];
        self.deadLine = [self dateOffset:[NSDate date] offset:[self.propertyValues[@"eventdeadline"] integerValue]+1];
    }
  
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initProperty{
    self.dbManager = [[DBManager alloc]initWithDatabaseFilename:@"event.sql"];
    self.eventDetail = [NSMutableString stringWithFormat:@"%@",@""];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.datePickerCellHeight = 0;
    self.tagCellHeight = 0;
    
    self.datePicker  = [UIDatePicker new];
    self.datePicker.alpha = 0;
    [self.datePicker addTarget:self action:@selector(updateDateCell:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.minimumDate = [self dateOffset:[NSDate date] offset:1];
    
    self.deadLine = [self dateOffset:[NSDate date] offset:1];
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

- (void)setEditValues:(NSMutableDictionary*)values{
    self.propertyValues = [[NSMutableDictionary alloc]initWithDictionary:values];
}

- (void)setPriorityTagColor:(NSInteger)priority{
    switch (priority) {
        case 0:
            self.showTagRowButton.backgroundColor = [UIColor greenColor];
            break;
        case 1:
            self.showTagRowButton.backgroundColor = [UIColor yellowColor];
            break;
        case 2:
            self.showTagRowButton.backgroundColor = [UIColor redColor];

            break;
        default:
            break;
    }
}

- (IBAction)showTagCellButton:(id)sender{
    [self.eventNameTextField resignFirstResponder];
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

- (void)addTap{
    UITapGestureRecognizer* oneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    oneTap.delegate = self;
    oneTap.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:oneTap];
    oneTap.cancelsTouchesInView = NO;
}

- (void)hideKeyboard{
    [self.eventNameTextField resignFirstResponder];
}
/*- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (touch.view != self.eventNameTextField) {
        return NO;
        
    }//其实这个方法是限制gestrueRecognizer只在某个view里面有效，和隐藏键盘不同，隐藏键盘正是要点击textfield外面才行
    return YES;
}*/

- (NSDate*)stringToDate:(NSString*)string{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* deadLineDate = [dateFormatter dateFromString:string];
    return deadLineDate;
}

- (NSString*)dateString:(NSDate*)date{
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateString = [dateformatter stringFromDate:date];
    return dateString;
}

- (NSDate*)dateOffset:(NSDate*)date offset:(NSInteger)offset{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    // now build a NSDate object for the next day
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:offset];
    NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:date options:0];
  
    return nextDate;
    
}

- (IBAction)saveEvent:(id)sender{
    NSString* query;
    if (self.editInfo) {
        query = [NSString stringWithFormat:@"update event set eventname = '%@' , eventdetail = '%@', eventpriority = '%ld', eventdeadline = '%@' where event_id = '%ld'",self.eventNameTextField.text,self.eventDetail,self.eventPriority,[self dateString:self.deadLine],self.eventID];
    }else{
        query = [NSString stringWithFormat:@"insert into event values(null, '%@', '%ld', '%@' , '%@')",self.eventNameTextField.text,self.eventPriority,self.eventDetail,[self dateString:self.deadLine]];
    }
    
    [self.dbManager executeQuery:query];
    
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
    
    [self.delegate finish];
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

- (IBAction)cancelEvent:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

#pragma mark - NoteViewDelegate

- (void)noteFinshEdit:(NSString* )noteString{
    self.eventDetail = [[NSMutableString alloc]initWithFormat:@"%@",noteString];
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
        self.eventNameTextField.placeholder = @"記事名";
        [self.eventNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell).with.insets(UIEdgeInsetsMake(2, 15, 2, 50));
            //top left bottom right
        }];
        [cell addSubview:self.showTagRowButton];
        if(!self.editInfo){
            self.showTagRowButton.backgroundColor = [UIColor redColor];
        }
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
        cell.textLabel.text = @"記事";
        cell.detailTextLabel.text = @"添付";
    }
    if([indexPath compare:[NSIndexPath indexPathForRow:0 inSection:1]]==NSOrderedSame) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Value1Cell"];
        cell.textLabel.text = @"締め切り";
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

#pragma mark - UILocalNotification

- (void)setNotification{
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addNoteSegue"]) {
        NoteViewController* noteViewController = segue.destinationViewController;
        noteViewController.delegate = self;
        noteViewController.note = [NSMutableString stringWithFormat:@"%@",self.eventDetail];
    }
}


@end
