//
//  SecondViewController.m
//  helpSky
//
//  Created by peters on 15/12/24.
//  Copyright © 2015年 peters. All rights reserved.
//

#import "SecondViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SecondViewController ()<MPMediaPickerControllerDelegate>{
    UIView *navigationView;
    UIView *playbarView;
    UISlider *slider;
    UIImageView *bgImg;
    
    //2.视图是否隐藏
    BOOL isHide;
    BOOL isPlay;
    //3.记录当前图片在数组中的下标
    NSInteger index;
    
    CGFloat artHeight;
    CGFloat artWight;
    MPMediaItemCollection *mediaItem;
    MPMediaItem* cractItem;
}

@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artImage;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (nonatomic ,strong) MPMediaPickerController *mediaPicker;
@property (nonatomic ,strong) MPMusicPlayerController *musicPlayer;
@property (weak, nonatomic) IBOutlet UIButton *playMusic;

@end

@implementation SecondViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    isPlay = NO;
    index = 0;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KBackGroundColor;
    
    
    self.view.layer.cornerRadius = 5;
    
    self.view.layer.masksToBounds = YES;
    artHeight = _artImage.bounds.size.height;
    artWight = _artImage.bounds.size.width;
    
    _artImage.layer.cornerRadius = 5;
    _artImage.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
-(MPMusicPlayerController *)musicPlayer{
    if (!_musicPlayer) {
        _musicPlayer=[MPMusicPlayerController systemMusicPlayer];
        [_musicPlayer beginGeneratingPlaybackNotifications];//开启通知，否则监控不到MPMusicPlayerController的通知
        [self addNotification];//添加通知

    }
    return _musicPlayer;
}

/**
 *  创建媒体选择器
 *
 *  @return 媒体选择器
 */
-(MPMediaPickerController *)mediaPicker{
    if (!_mediaPicker) {
        
        _mediaPicker=[[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeAny];
        _mediaPicker.allowsPickingMultipleItems=YES;//允许多选
        _mediaPicker.showsCloudItems=YES;//显示icloud选项
        _mediaPicker.prompt=@"请选择要播放的音乐";
        _mediaPicker.delegate=self;//设置选择器代理
    }
    return _mediaPicker;
}

/**
 */
-(MPMediaQuery *)getLocalMediaQuery{
    MPMediaQuery *mediaQueue=[MPMediaQuery songsQuery];
    for (MPMediaItem *item in mediaQueue.items) {
        NSLog(@"标题：%@,%@",item.title,item.albumTitle);
    }
    return mediaQueue;
}

/**
 *  取得媒体集合
 *
 *  @return 媒体集合
 */
-(MPMediaItemCollection *)getLocalMediaItemCollection{
    MPMediaQuery *mediaQueue=[MPMediaQuery songsQuery];
    NSMutableArray *array=[NSMutableArray array];
    for (MPMediaItem *item in mediaQueue.items) {
        [array addObject:item];
        NSLog(@"标题：%@,%@",item.title,item.albumTitle);
    }
    MPMediaItemCollection *mediaItemCollection=[[MPMediaItemCollection alloc]initWithItems:[array copy]];
    return mediaItemCollection;
}

#pragma mark - MPMediaPickerController代理方法
//选择完成
-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    mediaItem = mediaItemCollection;
    cractItem =[mediaItemCollection.items firstObject];
    MPMediaItemArtwork *artwork= [cractItem valueForKey:MPMediaItemPropertyArtwork];
    UIImage *image=[artwork imageWithSize:CGSizeMake(artWight - 20, artHeight - 20)];
    NSLog(@"标题：%@,表演者：%@,专辑：%@",cractItem.title ,cractItem.artist,cractItem.albumTitle);
    [self.artImage setImage:image];
    self.TitleLabel.text = [NSString stringWithFormat:@"%@\n%@",cractItem.title,cractItem.artist];
    
    [self.musicPlayer setQueueWithItemCollection:mediaItem];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//取消选择
-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 通知
/**
 *  添加通知
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(playbackStateChange:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
}

/**
 *  播放状态改变通知
 *
 *  @param notification 通知对象
 */
-(void)playbackStateChange:(NSNotification *)notification{
    switch (self.musicPlayer.playbackState) {
        case MPMusicPlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMusicPlaybackStatePaused:
            NSLog(@"播放暂停.");
            break;
        case MPMusicPlaybackStateStopped:
            NSLog(@"播放停止.");
            break;
        case MPMusicPlaybackStateSeekingForward:
            NSLog(@"下一首");
            break;
        case MPMusicPlaybackStateSeekingBackward:
            NSLog(@"back");
            break;
            
        default:
            break;
    }
}

- (IBAction)pickMusic:(id)sender {
    [self presentViewController:self.mediaPicker animated:YES completion:nil];
}

- (IBAction)lastMusic:(id)sender {
    [self.musicPlayer skipToPreviousItem];
    [self lastItem];
}

- (void)lastItem{
    if (index > 0 ) {
        index--;
    }else{
        index = mediaItem.items.count - 1;
    }
    cractItem = mediaItem.items[index];
    MPMediaItemArtwork *artwork= [cractItem valueForKey:MPMediaItemPropertyArtwork];
    UIImage *image=[artwork imageWithSize:CGSizeMake(artWight - 20, artHeight - 20)];//专辑图片
    NSLog(@"标题：%@,表演者：%@,专辑：%@",cractItem.title ,cractItem.artist,cractItem.albumTitle);
    if (image) {
        [self.artImage setImage:image];
    }
    
    self.TitleLabel.text = [NSString stringWithFormat:@"%@\n%@",cractItem.title,cractItem.artist];
    
}


- (void)nextItem{
    if (index<mediaItem.items.count - 1) {
        index++;
    }else{
        index = 0;
    }
    
  
    cractItem = mediaItem.items[index];
    MPMediaItemArtwork *artwork= [cractItem valueForKey:MPMediaItemPropertyArtwork];
    UIImage *image=[artwork imageWithSize:CGSizeMake(artWight - 20, artHeight - 20)];//专辑图片
    NSLog(@"标题：%@,表演者：%@,专辑：%@",cractItem.title ,cractItem.artist,cractItem.albumTitle);
    [self.artImage setImage:image];
    self.TitleLabel.text = [NSString stringWithFormat:@"%@\n%@",cractItem.title,cractItem.artist];
    

}

- (IBAction)controlMusic:(id)sender {
    if (isPlay) {
        [self.musicPlayer pause];

        isPlay = NO;
        _playButton.selected = NO;
    }else{
        [self.musicPlayer play];

        isPlay = YES;
        _playButton.selected = YES;
    }
        
}

- (IBAction)NestMusic:(id)sender {
    [self.musicPlayer skipToNextItem];
    [self nextItem];
}

- (IBAction)stopPlay:(id)sender {
    [self.musicPlayer stop];
}
@end
