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
#import "AddViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (strong,nonatomic)UITableView* tableView;
@property (strong,nonatomic)DBManager* dbManager;
@property (strong,nonatomic)NSMutableArray* eventArr;




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
        make.top.equalTo(@110);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        //make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 44, 0, 0));
    }];
    
    [self.tableView registerNib:[EventCell nib] forCellReuseIdentifier:@"eventCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
    
    
    self.dbManager = [[DBManager alloc]initWithDatabaseFilename:@"event.sql"];
    self.searchBar.delegate = self;
    
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


- (NSMutableDictionary*)valuesOfIndexPath:(NSIndexPath*)indexPath{
    NSMutableDictionary* values = [[NSMutableDictionary alloc]init];
    NSInteger indexOfEventID = [self.dbManager.arrColumnNames indexOfObject:@"event_id"];
    NSInteger indexOfEventname = [self.dbManager.arrColumnNames indexOfObject:@"eventname"];
    NSInteger indexOfEventPriority = [self.dbManager.arrColumnNames indexOfObject:@"eventpriority"];
    NSInteger indexOfEventDeadLine = [self.dbManager.arrColumnNames indexOfObject:@"eventdeadline"];
    NSInteger indexOfEventDetail = [self.dbManager.arrColumnNames indexOfObject:@"eventdetail"];
    
    NSString* eventName = [[self.eventArr objectAtIndex:indexPath.row]objectAtIndex:indexOfEventname];
    NSString* eventPriority = [[self.eventArr objectAtIndex:indexPath.row]objectAtIndex:indexOfEventPriority];
    NSString* eventDeadLine = [[self.eventArr objectAtIndex:indexPath.row]objectAtIndex:indexOfEventDeadLine];
    NSString* event_id = [[self.eventArr objectAtIndex:indexPath.row]objectAtIndex:indexOfEventID];
    NSString* eventdetail = [[self.eventArr objectAtIndex:indexPath.row]objectAtIndex:indexOfEventDetail];
    NSInteger daysLeft = [self intervalToDate:[self stringToDate:eventDeadLine]];
   
    values[@"event_id"] = event_id;
    values[@"eventname"] = eventName;
    values[@"eventpriority"] = eventPriority;
    values[@"eventdeadline"] = [NSString stringWithFormat:@"%ld",daysLeft];
    values[@"eventdetail"] = eventdetail;
    //values[@"eventdate"] = [self stringToDate:eventDeadLine];
    
    return values;
}

- (IBAction)addEvent:(id)sender{
    [self performSegueWithIdentifier:@"addEventSegue" sender:self];
}

- (IBAction)editTableView:(id)sender{
    if (!self.tableView.editing) {
      [self.tableView setEditing:YES animated:YES];
    }else{
      [self.tableView setEditing:NO animated:YES];
    }
   
}

#pragma - mark DataBase

- (void)loadData{
    NSString* query = @"select * from event";
    if(self.eventArr != nil){
        self.eventArr = nil;
    }
    self.eventArr = [[NSMutableArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
    [self.tableView reloadData];
}

- (void)searchEvent:(NSString*)keyWord{
    NSString* query = [NSString stringWithFormat:@"select * from event where eventname like '%%%@%%'",keyWord];
    if (self.eventArr!= nil) {
        self.eventArr = nil;
    }
    self.eventArr = [[NSMutableArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
    [self.tableView reloadData];
}


- (void)deleteDate:(NSInteger)eventid{
    NSString* query = [NSString stringWithFormat:@"delete from event where event_id = %ld",eventid];
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

#pragma - mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    //return self.eventArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}


- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}
#pragma - mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.eventArr.count;
    //return 1;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EventCell* cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    [cell setCell:[self valuesOfIndexPath:indexPath]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"editEventSegue" sender:indexPath];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EventCell* cell = (EventCell*)[tableView cellForRowAtIndexPath:indexPath];
        [self.eventArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self deleteDate:cell.eventID];

    }
}
#pragma - mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self searchEvent:searchText];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}



#pragma - mark NavigationController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"editEventSegue"]) {
        AddViewController* addViewController = segue.destinationViewController;
        [addViewController setEditValues:[self valuesOfIndexPath:(NSIndexPath*)sender]];
        addViewController.editInfo = YES;
        addViewController.delegate = self;
        
    }else if([segue.identifier isEqualToString:@"addEventSegue"]){
        AddViewController* addViewController = segue.destinationViewController;
        addViewController.delegate = self;
    }
}

#pragma - mark AddViewDelegate

- (void)finish{
    [self loadData];
    [self.tableView reloadData];
}


@end
