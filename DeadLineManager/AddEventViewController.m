//
//  AddToDoThingViewController.m
//  ZBYToDoList
//
//  Created by cookie on 15/9/4.
//  Copyright (c) 2015年 cookie. All rights reserved.
//

#import "AddEventViewController.h"
#import "DBManager.h"
#define EVENT_NAME_CELL_INDEX [NSIndexPath indexPathForRow:0 inSection:0]
#define EVENT_PLACE_CELL_INDEX [NSIndexPath indexPathForRow:1 inSection:0]
#define DATE_CELL_INDEX [NSIndexPath indexPathForRow:0 inSection:1]
#define DATEPICKER_CELL_INDEX [NSIndexPath indexPathForRow:1 inSection:1]
#define DESCRIPTION_CELL_INDEX [NSIndexPath indexPathForRow:2 inSection:1]
#define DESCRIPTION_CELL_PICKER_NO_SHOW_INDEX [NSIndexPath indexPathForRow:1 inSection:1]

@interface AddEventViewController (){
    
}

@property(strong,nonatomic)UITableView* tableView;
@property(strong,nonatomic)UIDatePicker* datePicker;
@property(nonatomic)NSInteger section_1_Count;
@property(nonatomic)NSInteger datePickerHeight;
@property(nonatomic)BOOL datePickedOnShow;

@property(strong,nonatomic)NSMutableDictionary* event;
@property(strong,nonatomic)NSDate* date;

@property(strong,nonatomic)DBManager* dbManager;


@end

@implementation AddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self addTap];
    [self initDatePicker];
    self.dbManager = [[DBManager alloc]initWithDatabaseFilename:@"event.sql"];
     // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initTableView{
    CGRect tableViewFrame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    self.tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[AddEventCell getNib] forCellReuseIdentifier:@"AddThingsWithTextFieldCell"];
    [self.view addSubview:self.tableView];
     self.section_1_Count = 1;
}


# pragma - mark method

- (IBAction)finshEditing:(id)sender {
    [self saveEvent];
    [self closeAddThingsView];
}

- (IBAction)cancelAddThing:(id)sender {
    [self closeAddThingsView];
}

- (void)closeAddThingsView{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

- (void)addTap{
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    oneTap.delegate = self;
    oneTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:oneTap];
}

- (void)hideKeyBoard{
    NSUInteger nameCellIndex[] = {0, 0};
    NSUInteger placeCellIndex[] = {0, 1};
    NSIndexPath *nameCellPath = [[NSIndexPath alloc] initWithIndexes:nameCellIndex length:2];
    NSIndexPath *placeCellPath = [[NSIndexPath alloc] initWithIndexes:placeCellIndex length:2];
    AddEventCell* nameCell = (AddEventCell*)[self.tableView cellForRowAtIndexPath:nameCellPath];
    AddEventCell* placeCell = (AddEventCell*)[self.tableView cellForRowAtIndexPath:placeCellPath];
    AddEventCell* descriptionCell;
    [nameCell.textField resignFirstResponder];
    [placeCell.textField resignFirstResponder];
}


- (void)initDatePicker{
    self.datePicker = [[UIDatePicker alloc]init];
    self.datePickerHeight = CGRectGetHeight(self.datePicker.frame);
    self.datePickedOnShow = NO;
    [self.datePicker addTarget:self action:@selector(updateDateCell) forControlEvents:UIControlEventValueChanged];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.minimumDate = [NSDate date];
}

- (void)insertDatePickerCell:(NSIndexPath*)indexPath{
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.datePicker.alpha = 0;
    [cell addSubview:self.datePicker];
    [UIView animateWithDuration:0.5 animations:^(){
        self.datePicker.alpha = 1;
    }];
   
}

- (void)initEventFilePath{
    
}

- (NSString*)dateString:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents* dateCompontents = [calendar components:(NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit) fromDate:date];
    NSString* dateString = [NSString stringWithFormat:@"%ld/%ld/%ld",dateCompontents.year,dateCompontents.month,dateCompontents.day];
    return dateString;
}


- (void)updateDateCell{
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:DATE_CELL_INDEX];
    cell.detailTextLabel.text = [self dateString:self.datePicker.date];
}


- (void)saveEvent{
    AddEventCell* eventNameCell = (AddEventCell*)[self.tableView cellForRowAtIndexPath:EVENT_NAME_CELL_INDEX];
    AddEventCell* eventPlaceCell = (AddEventCell*)[self.tableView cellForRowAtIndexPath:EVENT_PLACE_CELL_INDEX];
    
    NSString* eventNameString = eventNameCell.textField.text;
    NSString* eventPlaceString = eventPlaceCell.textField.text;
    NSDate* eventDate = self.date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* eventDateString = [dateFormatter stringFromDate:eventDate];
    
    //run the sql query
    NSString* query = [NSString stringWithFormat:@"insert into event values(null,'%@','%@',NULL,'%@')",eventNameString,eventPlaceString,eventDateString];
    [self.dbManager executeQuery:query];
    
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
}


#pragma - mark UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (![touch.view isKindOfClass: [UITextField class]]) {
        [self hideKeyBoard];
        return NO;
    }
    return YES;
}

#pragma - mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.datePickedOnShow) {
        return ([indexPath compare:DATEPICKER_CELL_INDEX] == NSOrderedSame ? self.datePickerHeight : 44);
    }else{
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([indexPath compare:DATE_CELL_INDEX]==NSOrderedSame){
        if (!self.datePickedOnShow) {
            if(self.section_1_Count < 3){
                self.section_1_Count ++;
                self.datePickedOnShow = YES;
                [self insertDatePickerCell:DATEPICKER_CELL_INDEX];
                //here i want to add a datepicker
            }
            
        }
        else{
            self.section_1_Count--;
            self.datePickedOnShow = NO;
            [self.datePicker removeFromSuperview];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:DATEPICKER_CELL_INDEX] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma - mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return self.section_1_Count;
            break;
        case 2:
            return 1;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        AddEventCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AddThingsWithTextFieldCell"];
        [cell setTextFieldPlaceHolderWithIndex:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    // section = 1
    }else if([indexPath compare: DATE_CELL_INDEX] == NSOrderedSame){
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AddThingsCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AddThingsCell"];
            cell.textLabel.text = @"Dead Line";
            cell.detailTextLabel.textColor = [UIColor redColor];
            if (!self.datePickedOnShow) {
                cell.detailTextLabel.text = [self dateString:[NSDate date]];
                self.date = [NSDate date];
            }else{
                cell.detailTextLabel.text = [self dateString:self.datePicker.date];
                self.date = self.datePicker.date;
            }
          
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        return cell;
    }
    else{
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AddThingsCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AddThingsCell"];

        }
        return cell;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
