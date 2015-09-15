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
    self.textView.text = self.note;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)doneEdit:(id)sender{
    [self.delegate noteFinshEdit:self.textView.text];
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

- (IBAction)cancelEdit:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}


@end
