//
//  ThirdViewController.m
//  helpSky
//
//  Created by peters on 15/12/24.
//  Copyright © 2015年 peters. All rights reserved.
//

#import "ThirdViewController.h"
#import "addViewController.h"
#import "detilViewController.h"

@interface ThirdViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    NSInteger rowindex;
}

@property (strong, nonatomic) IBOutlet UITableView *ListTableView;
@property (nonatomic)  NSMutableArray *noteArray;
@property (nonatomic)  NSMutableArray *dateArray;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kLightBlueColor;
   
    
    self.view.layer.cornerRadius = 5;
    self.view.layer.masksToBounds = YES;
    [self editTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editTableView{

    _ListTableView.dataSource = self;
    _ListTableView.delegate = self;
    _ListTableView.backgroundColor = klineGrayColor;
    _ListTableView.layer.cornerRadius = 5;
    UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    //最短长按的时间
    longPressReger.minimumPressDuration = 1.0;
    //将事件添加到tableView
    [self.ListTableView addGestureRecognizer:longPressReger];
    
}

//长按事件处理
-(void)longPress:(UILongPressGestureRecognizer *)sender{
    //判断状态是否是开始
    if (sender.state==UIGestureRecognizerStateBegan) {
        //得到cell用于提取选中行的下标
        UITableViewCell *cell = (UITableViewCell *)sender.view;
        //得到下标
        rowindex=cell.tag;
        //消息提示框
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"删除" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }
    
}
//消息提示框确认按钮点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //判断是非是确定时间的下标
    if (buttonIndex==1) {
        //提取NSUserDefaults的数据(内容)
        NSArray *tempArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
        //复制数组
        NSMutableArray *mutableArray = [tempArray mutableCopy];
        //按下标移除要删除的数据
        [mutableArray removeObjectAtIndex:rowindex];
        //重新封装到NSUserDefaults
        [[NSUserDefaults standardUserDefaults] setObject:mutableArray forKey:@"note"];
        //提取NSUserDefaults的数据(时间)
        NSArray *tempDateArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"date"];
        //复制数组
        NSMutableArray *mutableDateArray = [tempDateArray mutableCopy];
        //按下标移除要删除的数据
        [mutableDateArray removeObjectAtIndex:rowindex];
        //重新封装到NSUserDefaults
        [[NSUserDefaults standardUserDefaults] setObject:mutableDateArray forKey:@"date"];
        //刷新
        [self.ListTableView setNeedsDisplay];
        
        
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.dateArray=[[NSUserDefaults standardUserDefaults] objectForKey:@"date"];
    self.noteArray=[[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
    //刷新数据
    [self.ListTableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - tableView
//分组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//分行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_noteArray) {
        return [_noteArray count];
    }else{
        return 1;
    }
    
    
}
//设置行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // cell的标识
    static NSString *CellIdentifier = @"Cell";
    //初始化行
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = klineGrayColor;
    NSString *note  = nil;
    if(tableView == self.ListTableView){
        note = [self.noteArray objectAtIndex:indexPath.row];
    };
    NSString *date = [self.dateArray objectAtIndex:indexPath.row];
    //得到note的长度
    NSUInteger charnum = [note length];
    //判断note的长度如果大于22个字符用省略号表示
    if (charnum < 20) {
        cell.textLabel.text = note;
    }
    else{
        cell.textLabel.text = [[note substringToIndex:18] stringByAppendingString:@"..."];
    }
    //设置cell的标识用于获取选中行
    cell.tag = indexPath.row;
    //填充时间
    cell.detailTextLabel.text = date;
    //设置字体
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    return cell;
}
//行的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSLog(@"-- dianji");
    //初始化DetailViewController
    detilViewController *detailView=[[detilViewController alloc] init];
    //用导航推送到addView
    
    [self.navigationController pushViewController:detailView animated:YES];
    
    //选中行标识传值
    detailView.index=[indexPath row];
}



- (IBAction)AddNote:(id)sender {
    addViewController* addView=[[addViewController alloc] init];
    //用导航推送到addView
    [self.navigationController pushViewController:addView animated:YES];
    
}
- (IBAction)callMe:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"13732239853"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end
