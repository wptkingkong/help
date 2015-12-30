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
    //新建导航按钮
    UIBarButtonItem *saveButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(editNote:)];
    self.navigationController.navigationBar.tintColor = kLightBlueColor;
    //设置导航名称
    self.navigationItem.title=@"夕拾";
    //将按钮添加到导航栏中
    self.navigationItem.rightBarButtonItem=saveButton;
    //提取NSUserDefaults
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
    //提取选中行的内容
    NSString *oldtext = [array objectAtIndex:self.index];
    
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
    //填充到文本框中
    self.textView.text = oldtext;
    [self.view addSubview:self.textView];
    
}

-(void)editNote:(id)sender{
    //提取NSUserDefaults(时间)
    NSArray *tempArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
    //复制数组
    NSMutableArray *mutableArray = [tempArray mutableCopy];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init ];
    //格式化时间
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    //获取当前时间
    NSDate *now = [NSDate date];
    NSString *datestring = [dateFormatter stringFromDate:now];
    NSString *textstring = [self.textView text];
    //移除旧内容
    [mutableArray removeObjectAtIndex:self.index];
    //添加新内容
    [mutableArray insertObject:textstring atIndex:0];
    //封装到NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:mutableArray forKey:@"note"];
    
    //提取NSUserDefaults(时间)
    NSArray *tempDateArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"date"];
    //复制数组
    NSMutableArray *mutableDateArray = [tempDateArray mutableCopy];
    //移除旧内容
    [mutableDateArray removeObjectAtIndex:self.index];
    //添加新内容
    [mutableDateArray insertObject:datestring atIndex:0 ];
    //封装到NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:mutableDateArray forKey:@"date"];
    [self.textView resignFirstResponder];
    //返回根视图
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}

@end
