//
//  ViewController.m
//  DeadLineManager
//
//  Created by cookie on 15/9/12.
//  Copyright (c) 2015年 cookie. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "EventCell.h"
#import "DBManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (strong,nonatomic)UITableView* tableView;
@property (strong,nonatomic)DBManager* dbManager;
@property (strong,nonatomic)NSArray* eventArr;
//@property

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initProperty];
    [self loadData];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initProperty{
    self.tableView = [UITableView new];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.tableView registerNib:[EventCell nib] forCellReuseIdentifier:@"eventCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    self.dbManager = [[DBManager alloc]initWithDatabaseFilename:@"event.sql"];
    
}
#pragma - mark method
- (NSInteger)intervalToDate:(NSDate*)date{
    NSDate* dateNow = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit
                                               fromDate:dateNow
                                                 toDate:date
                                                options:0];
    return components.day;
}

- (NSDate*)stringToDate:(NSString*)string{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
   [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* deadLineDate = [dateFormatter dateFromString:string];
    return deadLineDate;
}


#pragma - mark DataBase

- (void)loadData{
    NSString* query = @"select * from event";
    if(self.eventArr != nil){
        self.eventArr = nil;
    }
    
    self.eventArr = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
    [self.tableView reloadData];
}


#pragma - mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}
#pragma - mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.eventArr.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EventCell* cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    NSInteger indexOfEventname = [self.dbManager.arrColumnNames indexOfObject:@"eventname"];
    NSInteger indexOfEventPriority = [self.dbManager.arrColumnNames indexOfObject:@"eventpriority"];
    NSInteger indexOfEventDeadLine = [self.dbManager.arrColumnNames indexOfObject:@"eventdeadline"];
    
    NSString* eventName = [[self.eventArr objectAtIndex:indexPath.row]objectAtIndex:indexOfEventname];
    NSString* eventPriority = [[self.eventArr objectAtIndex:indexPath.row]objectAtIndex:indexOfEventPriority];
    NSString* eventDeadLine = [[self.eventArr objectAtIndex:indexPath.row]objectAtIndex:indexOfEventDeadLine];
    
    NSMutableDictionary* values = [[NSMutableDictionary alloc]init];
    
    NSInteger temp = [self intervalToDate:[self stringToDate:eventDeadLine]];
    
    values[@"eventname"] = eventName;
    values[@"eventpriority"] = eventPriority;
    values[@"eventdeadline"] = [NSString stringWithFormat:@"%ld",temp];
    
    [cell setLabel:values];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"editEventSegue" sender:self];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    if (editing) {
        self.addButton.enabled = NO;
    } else {
        self.addButton.enabled = YES;
    }
}


@end
