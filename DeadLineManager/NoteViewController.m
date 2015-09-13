//
//  NoteViewController.m
//  DeadLineManager
//
//  Created by cookie on 15/9/13.
//  Copyright (c) 2015年 cookie. All rights reserved.
//

#import "NoteViewController.h"

@interface NoteViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textView becomeFirstResponder];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelEdit:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}


@end
