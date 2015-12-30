//
//  detilViewController.m
//  helpSky
//
//  Created by peters on 15/12/25.
//  Copyright © 2015年 peters. All rights reserved.
//

#import "detilViewController.h"

@interface detilViewController ()
@property UITextView *textView;
@end

@implementation detilViewController
@synthesize index,textView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = klineGrayColor;
    textView=[[UITextView alloc] initWithFrame:CGRectMake(10 , 70, self.view.bounds.size.width - 20, self.view.bounds.size.height - 90)];

    UIBarButtonItem *saveButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(editNote:)];
    self.navigationController.navigationBar.tintColor = kLightBlueColor;
 
    self.navigationItem.title=@"夕拾";

    self.navigationItem.rightBarButtonItem=saveButton;

    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];

    NSString *oldtext = [array objectAtIndex:self.index];
    
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
    self.textView.text = oldtext;
    [self.view addSubview:self.textView];
    
}

-(void)editNote:(id)sender{
    
    NSArray *tempArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];

    NSMutableArray *mutableArray = [tempArray mutableCopy];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init ];

    [dateFormatter setDateFormat:@"MM-dd HH:mm"];

    NSDate *now = [NSDate date];
    NSString *datestring = [dateFormatter stringFromDate:now];
    NSString *textstring = [self.textView text];

    [mutableArray removeObjectAtIndex:self.index];

    [mutableArray insertObject:textstring atIndex:0];

    [[NSUserDefaults standardUserDefaults] setObject:mutableArray forKey:@"note"];
    

    NSArray *tempDateArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"date"];

    NSMutableArray *mutableDateArray = [tempDateArray mutableCopy];

    [mutableDateArray removeObjectAtIndex:self.index];

    [mutableDateArray insertObject:datestring atIndex:0 ];

    [[NSUserDefaults standardUserDefaults] setObject:mutableDateArray forKey:@"date"];
    [self.textView resignFirstResponder];

    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}

@end
