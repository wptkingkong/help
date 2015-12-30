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

@interface ThirdViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>{
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
    longPressReger.minimumPressDuration = 1.0;
    [self.ListTableView addGestureRecognizer:longPressReger];
    
}


- (void)longPress:(UILongPressGestureRecognizer *)sender{
    if (sender.state==UIGestureRecognizerStateBegan) {
        UITableViewCell *cell = (UITableViewCell *)sender.view;
        rowindex=cell.tag;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"删除" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    if (buttonIndex==1) {
       
        NSArray *tempArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
    
        NSMutableArray *mutableArray = [tempArray mutableCopy];
        [mutableArray removeObjectAtIndex:rowindex];
        [[NSUserDefaults standardUserDefaults] setObject:mutableArray forKey:@"note"];
        NSArray *tempDateArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"date"];
        
        NSMutableArray *mutableDateArray = [tempDateArray mutableCopy];
        [mutableDateArray removeObjectAtIndex:rowindex];
        [[NSUserDefaults standardUserDefaults] setObject:mutableDateArray forKey:@"date"];
        [self.ListTableView setNeedsDisplay];
        
        
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.dateArray=[[NSUserDefaults standardUserDefaults] objectForKey:@"date"];
    self.noteArray=[[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
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
    
    static NSString *CellIdentifier = @"Cell";
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
    NSUInteger charnum = [note length];
    if (charnum < 20) {
        cell.textLabel.text = note;
    }
    else{
        cell.textLabel.text = [[note substringToIndex:18] stringByAppendingString:@"..."];
    }
    cell.tag = indexPath.row;
    cell.detailTextLabel.text = date;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    detilViewController *detailView=[[detilViewController alloc] init];
    [self.navigationController pushViewController:detailView animated:YES];
    detailView.index=[indexPath row];
}



- (IBAction)AddNote:(id)sender {
    addViewController* addView=[[addViewController alloc] init];
    [self.navigationController pushViewController:addView animated:YES];
    
}
- (IBAction)callMe:(id)sender {

    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"拨号"
                                                                              message: @"输入手机号"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"numbers";
        
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];

    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * numfield = textfields[0];
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",numfield.text];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
