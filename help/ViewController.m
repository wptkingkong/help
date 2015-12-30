//
//  ViewController.m
//  helpSky
//
//  Created by peters on 15/12/24.
//  Copyright © 2015年 peters. All rights reserved.
//

#import "ViewController.h"
//tabbar 49

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,MBProgressHUDDelegate>{
    CGFloat Bheight;
    CGFloat Bwight;
    MBProgressHUD *HUD;
    int i;
}
@property (nonatomic ,strong) UIImageView *imaV;
@property (nonatomic ,strong) UITableView *tabV;
@property (nonatomic ,strong) UIView *bottomV;
@property (nonatomic ,strong) UICollectionView *colV;
@property (nonatomic ,strong) NSArray *FinalArry;
@property (nonatomic ,strong) NSDictionary *Finaldict;
@property (nonatomic ,strong) NSDictionary *secondDict;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    self.view.backgroundColor = kLightBlueColor;
    self.view.layer.cornerRadius = 5;
    self.view.layer.masksToBounds = YES;
    
    [self editBottomView];
    [self editTopView];
    
    i = 0;

    
    
}

- (void)viewWillAppear:(BOOL)animated{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager GET:@"http://apistore.baidu.com/microservice/weather?cityid=101210101" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *ar = (NSDictionary *)responseObject;
        _FinalArry = (NSArray*)ar[@"retData"];
        _secondDict = (NSDictionary *)_FinalArry;

 
        [self analysis];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)editTopView{
    _imaV = [[UIImageView alloc] initWithFrame:CGRectMake(18, 18 + 20, (KscreenWight - (18*3))/2, 150)];
    [self.view addSubview:_imaV];
    
//    self.imaV.backgroundColor = [UIColor redColor];
    self.imaV.layer.cornerRadius = 13;
    self.imaV.layer.borderColor = klineGrayColor.CGColor;
    self.imaV.layer.borderWidth = 0.5;
    self.imaV.layer.masksToBounds = YES;
    UIImage *ima = [UIImage imageNamed:@"userIma.jpg"];
    self.imaV.image = ima;
    
    
    
    _tabV = [[UITableView alloc] initWithFrame:CGRectMake(KscreenWight/2+9, 18 + 20, (KscreenWight - (18*3))/2, 150) style:UITableViewStyleGrouped];
    [self.view addSubview:_tabV];
    _tabV.delegate = self;
    _tabV.dataSource = self;
    _tabV.scrollEnabled = NO;
    _tabV.backgroundColor = KBackGroundColor;
    self.tabV.layer.cornerRadius = 13;
    self.tabV.layer.masksToBounds = YES;
    

    
    
    
}

- (void)editBottomView{
    _bottomV = [[UIView alloc] initWithFrame:CGRectMake(18, (KscreenHeight - 20 - 49)/2 + 9, KscreenWight - 36, (KscreenHeight - 20 - 49)/2 - 27)];
    [self.view addSubview:_bottomV];
    self.bottomV.backgroundColor = kAtributeTextColor;
    self.bottomV.layer.cornerRadius = 13;
    self.bottomV.layer.borderWidth = 0.5;
    self.bottomV.layer.borderColor = klineGrayColor.CGColor;
    self.bottomV.layer.masksToBounds = YES;
    

    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    Bheight = self.bottomV.bounds.size.height;
    Bwight = self.bottomV.bounds.size.width;
    self.colV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Bwight, Bheight)collectionViewLayout:flowLayout];
    _colV.delegate = self;
    _colV.dataSource = self;
    [self.colV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cocell"];
    self.colV.backgroundColor = KBackGroundColor;
    [self.bottomV addSubview:self.colV];
    

    
}


#pragma mark - collection
#pragma mark - collectionView delegate

//设置分区

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView{
    
    
    
    return 1;
    
}


//每个分区上的元素个数

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section

{
    
    return 4;
    
}

//设置元素内容

- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    static NSString *identify = @"Cocell";
    
    UICollectionViewCell *CollectCell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (CollectCell != nil) {
        while ([CollectCell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[CollectCell.contentView.subviews lastObject] removeFromSuperview];
        }
        
    }
    CollectCell.layer.cornerRadius = 5;
    CollectCell.layer.borderColor = klineGrayColor.CGColor;
    CollectCell.layer.borderWidth = 0.5;
    CollectCell.layer.masksToBounds = YES;

    UILabel *label = [[UILabel alloc] init];
    label.frame = CollectCell.bounds;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    NSString *str;
    [CollectCell.contentView addSubview:label];
    if (_Finaldict) {

        if (indexPath.row == 0 ) {
            str = [NSString stringWithFormat:@"当前温度 ：%@",_Finaldict[@"temp"]];
            label.text = str;
  
            NSLog(@"%i",i);
            i++;
        }
        
        if  (indexPath.row == 1){
            label.text = [NSString stringWithFormat:@"外面是%@哦",_Finaldict[@"weather"]];
        }
        
        if (indexPath.row == 2) {
            label.text = [NSString stringWithFormat:@"%@,%@",_Finaldict[@"WD"],_Finaldict[@"WS"]];
        }
        
        if (indexPath.row == 3) {
            label.text = [NSString stringWithFormat:@"日升是%@\n 落日在%@",_Finaldict[@"sunrise"],_Finaldict[@"sunset"]];
        }
        
    }
    
    return CollectCell;
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    

}

//设置元素的的大小框

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section

{
    
    UIEdgeInsets top = {10,10,10,10};
    
    return top;
    
}


//设置顶部的大小

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize size={0,0};
    
    return size;
    
}

//设置元素大小

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGSizeMake((Bwight - 30)/2,(Bwight - 30)/2);
    
}


#pragma tableView - mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSInteger index = 0;
    NSArray *title = @[@"姓名:",@"性别:"];
    NSArray *detil = @[@"hiahia",@"hybird"];
    cell.textLabel.text = title[index];
    cell.detailTextLabel.text = detil[index];
    index++;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    cell.userInteractionEnabled = NO;
    [cell sizeToFit];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat h = tableView.bounds.size.height;
    return (h - 36)/2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 9;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark bottom




- (void)analysis{
//
    _Finaldict = [NSDictionary dictionaryWithDictionary:_secondDict];
    [_colV reloadData];
}

@end
