//
//  addViewController.m
//  helpSky
//
//  Created by peters on 15/12/25.
//  Copyright © 2015年 peters. All rights reserved.
//

#import "addViewController.h"

@interface addViewController ()
@property UITextView * textView;
@end

@implementation addViewController
@synthesize textView;
- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *saveButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNote:)];
    self.navigationController.navigationBar.tintColor = kLightBlueColor;

    self.navigationItem.title=@"朝花";

    self.navigationItem.rightBarButtonItem=saveButton;
    self.view.backgroundColor = klineGrayColor;
    textView=[[UITextView alloc] initWithFrame:CGRectMake(10 , 70, self.view.bounds.size.width - 20, self.view.bounds.size.height - 90)];
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
    [self.view addSubview:textView];
}


- (void)saveNote:(id)sender{
    NSMutableArray *initNoteArray = [[NSMutableArray alloc]init];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"note"]==nil) {
        [[NSUserDefaults standardUserDefaults] setObject:initNoteArray forKey:@"note"];
    }

    NSArray *tempNoteArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
    NSMutableArray *mutableNoteArray = [tempNoteArray mutableCopy];

    NSString *textstring = [self.textView text];
    [mutableNoteArray insertObject:textstring atIndex:0 ];
    [[NSUserDefaults standardUserDefaults] setObject:mutableNoteArray forKey:@"note"];
    
    NSMutableArray *initDateArray = [[NSMutableArray alloc]init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"date"]==nil) {
        [[NSUserDefaults standardUserDefaults] setObject:initDateArray forKey:@"date"];
    }
    NSArray *tempDateArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"date"];
    NSMutableArray *mutableDateArray = [tempDateArray mutableCopy];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init ];

    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSDate *now = [NSDate date];
    NSString *datestring = [dateFormatter stringFromDate:now];
    [mutableDateArray insertObject:datestring atIndex:0 ];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableDateArray forKey:@"date"];

    [self.textView resignFirstResponder];

    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
    
}

@end
