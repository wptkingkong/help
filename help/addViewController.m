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
    //新建导航按钮
    UIBarButtonItem *saveButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNote:)];
    self.navigationController.navigationBar.tintColor = kLightBlueColor;
    //设置导航名称
    self.navigationItem.title=@"朝花";
    //添加按钮
    self.navigationItem.rightBarButtonItem=saveButton;
    //初始化textView
    self.view.backgroundColor = klineGrayColor;
    textView=[[UITextView alloc] initWithFrame:CGRectMake(10 , 70, self.view.bounds.size.width - 20, self.view.bounds.size.height - 90)];
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
    //将textView放倒view中
    [self.view addSubview:textView];
}
//添加事件
-(void)saveNote:(id)sender{
    //初始化数组
    NSMutableArray *initNoteArray = [[NSMutableArray alloc]init];
    //判断NSUserDefaults中是否有key叫note的数据如果没有就添加
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"note"]==nil) {
        [[NSUserDefaults standardUserDefaults] setObject:initNoteArray forKey:@"note"];
    }
    //新建临时数组来接收NSUserDefaults数据
    NSArray *tempNoteArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
    //复制数组
    NSMutableArray *mutableNoteArray = [tempNoteArray mutableCopy];
    //获取文本框的值
    NSString *textstring = [self.textView text];
    //添加到负责数组中
    [mutableNoteArray insertObject:textstring atIndex:0 ];
    [[NSUserDefaults standardUserDefaults] setObject:mutableNoteArray forKey:@"note"];
    
    NSMutableArray *initDateArray = [[NSMutableArray alloc]init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"date"]==nil) {
        [[NSUserDefaults standardUserDefaults] setObject:initDateArray forKey:@"date"];
    }
    NSArray *tempDateArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"date"];
    NSMutableArray *mutableDateArray = [tempDateArray mutableCopy];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init ];
    //格式化时间
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSDate *now = [NSDate date];
    NSString *datestring = [dateFormatter stringFromDate:now];
    [mutableDateArray insertObject:datestring atIndex:0 ];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableDateArray forKey:@"date"];
    //隐藏键盘
    [self.textView resignFirstResponder];
    //回到根目录
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
    
}

@end
