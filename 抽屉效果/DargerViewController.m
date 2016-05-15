//
//  DargerViewController.m
//  抽屉效果
//
//  Created by 911 on 16/2/13.
//  Copyright © 2016年 bin. All rights reserved.
//

#import "DargerViewController.h"

@interface DargerViewController ()
@property (nonatomic, weak) UIView *leftView;
@property (nonatomic, weak) UIView *rightView;
@property (nonatomic, weak) UIView *midView;
@end

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define targetR 300
#define targetL -300
@implementation DargerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.midView addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];

    
}

- (void)tap{
    [UIView animateWithDuration:0.3 animations:^{
        self.midView.frame = self.view.bounds;
    }];
    
}

- (void)pan:(UIPanGestureRecognizer *)pan{

    //获取偏移量
    CGPoint transP = [pan translationInView:self.midView];
    
    //为何不适用transform 因为它只能修改x 和 y
//    self.midView.transform = CGAffineTransformTranslate(self.midView.transform, transP.x, transP.y);

    
    self.midView.frame = [self frameWihtOffsetX:transP.x];
    
    if (self.midView.frame.origin.x > 0) {
        self.rightView.hidden = YES;
    }else if(self.midView.frame.origin.x < 0){
        self.rightView.hidden = NO;
    }
    
//    当手指松开，做自动定位
    CGFloat target = 0;

    if (pan.state == UIGestureRecognizerStateEnded){
        
        if (self.midView.frame.origin.x > ScreenW * 0.5) {
             //1.判断当前view的x有没有大于屏幕宽度的一半 如果大于就是在右侧。
            target = targetR;
        }else if(CGRectGetMaxX(self.midView.frame) < ScreenW * 0.5){
            //2.判断在左侧 判断view的最大x有没有小于屏幕宽度的一半
            target = targetL;
        }
       
//       计算当前midView的frame
        CGFloat offset = target - self.midView.frame.origin.x;
        
        [UIView animateWithDuration:0.3 animations:^{
             self.midView.frame = [self frameWihtOffsetX:offset];
        }];
       
    }
    
    //复位
    [pan setTranslation:CGPointZero inView:self.midView];
    
}

#define maxY 100
//根据偏移量计算midView的frame
- (CGRect)frameWihtOffsetX:(CGFloat)offsetX{
    CGRect frame = self.midView.frame;
    frame.origin.x += offsetX;
    frame.origin.y = fabs(maxY * frame.origin.x / ScreenW);
    
    frame.size.height = self.view.frame.size.height - 2 * frame.origin.y;
    return frame;
}



- (void)setup{
//    leftview
    UIView *leftView = [[UIView alloc]initWithFrame:self.view.bounds];
    leftView.backgroundColor = [UIColor blueColor];
    self.leftView = leftView;
    [self.view addSubview:leftView];
//    rightview
    UIView *rightView = [[UIView alloc]initWithFrame:self.view.bounds];
    rightView.backgroundColor = [UIColor greenColor];
    self.rightView = rightView;
    [self.view addSubview:rightView];
//    midview
    UIView *midView = [[UIView alloc]initWithFrame:self.view.bounds];
    midView.backgroundColor = [UIColor redColor];
    self.midView = midView;
    [self.view addSubview:midView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
