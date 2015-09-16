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
    
    values[@"eventname"] = eventName;
    values[@"eventpriority"] = eventPriority;
    values[@"eventdeadline"] = eventDeadLine;
    
    [cell setLabel:values];
    return cell;
}
@end
