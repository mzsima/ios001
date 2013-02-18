//
//  ViewController.m
//  NumberChoice
//
//  Created by Mizusima Yuusuke on 13/01/25.
//  Copyright (c) 2013年 Mizusima Yuusuke. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    int question;
    UIView *top;
    UIView *bottom;
}
@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    // 数字の１をセット
    question = 1;
    [self showQuestion];
}

- (void)showQuestion
{
    // 全部クリアする
    for (UIView *v in self.view.subviews) {
        [v removeFromSuperview];
    }
    [self createQuestion];
    [self readyAnswerPanel];
}

- (void)createQuestion
{
    // 板を用意
    top = [[UIView alloc] initWithFrame:CGRectMake(0, -200, 320, 60)];
    top.backgroundColor = [UIColor blackColor];
    [self.view addSubview:top];
    bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 600, 320, 60)];
    bottom.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottom];
    
    // 穴をあける
    for (int i=0; i<question; i++) {
        CGRect rect = CGRectMake(i*30+10, 60, 20, 20);
        UIView *topHole = [[UIView alloc] initWithFrame:rect];
        topHole.center = CGPointMake(topHole.center.x, 60);
        topHole.backgroundColor = [UIColor whiteColor];
        [top addSubview:topHole];
        
        UIView *bottomHole = [[UIView alloc] initWithFrame:rect];
        bottomHole.center = CGPointMake(bottomHole.center.x, 0);
        bottomHole.backgroundColor = [UIColor whiteColor];
        [bottom addSubview:bottomHole];
    }
    
    // 上下からUIViewを打ち合わせる、噛み合わせて四角になるように
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
        top.center = CGPointMake(160, 150);
        bottom.center = CGPointMake(160, 210);
    } completion:^(BOOL finished) {
    }];
}

- (void)readyAnswerPanel
{
    // MutableArrayで番号をシャッフル
    NSMutableArray *array = [[@"1 2 3 4 5 6 7 8 9 10" componentsSeparatedByString:@" "] mutableCopy];
    for (int i = 9; i > 0; i--) {
        int randomNum = arc4random() % i;
        [array exchangeObjectAtIndex:i withObjectAtIndex:randomNum];
    }
    
    for (int i=0; i<10; i++) {
        
        UILabel *panel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        panel.textAlignment = 1; //center
        panel.text = [array objectAtIndex:i];
        panel.textColor = [UIColor whiteColor];
        panel.backgroundColor = [UIColor blackColor];
        panel.userInteractionEnabled = YES;
        [self.view addSubview:panel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNum:)];
        [panel addGestureRecognizer:tap];
        
        [UIView animateWithDuration:0.3 delay:0.1 * i options:UIViewAnimationCurveEaseOut animations:^{
            panel.center = CGPointMake((i%5)*60 + 35, 350 + 50 * (i/5));
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)tapNum:(UIGestureRecognizer*)gr
{
    UILabel *answer = (UILabel*)gr.view;
    
    int number = [answer.text intValue];
    
    // 壁の穴に黄色いのをはめていく
    for (int i=0; i<number; i++) {
        UIView *light = [[UIView alloc] initWithFrame:answer.frame];
        light.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:light];
        [UIView animateWithDuration:0.2 delay:0.2*i options:UIViewAnimationCurveEaseInOut animations:^{
            light.bounds = CGRectMake(0,0,20,20);
            light.center = CGPointMake(i*30+20, 180);
        } completion:^(BOOL finished) {
            
            // 最後まで穴に回答が飛んでいたったら。
            if (i==number-1) {
                if (number == question) {
                    // 正解の場合
                    if (question == 10) {
                        // clear
                        [self clear];
                    } else {
                        // next
                        [self collectAndNext];
                    }
                } else {
                    [self missAndRetry];
                }
            }
            
        }];
    }
}

- (void)clear
{
    // 上から Clearという文字ををふらせる。
    UILabel *clear = [[UILabel alloc] initWithFrame:CGRectMake(600, 240, 0, 0)];
    clear.font = [UIFont boldSystemFontOfSize:70];
    clear.textColor = [UIColor blueColor];
    clear.text = @"Clear";
    clear.backgroundColor = [UIColor clearColor];
    [clear sizeToFit];
    [self.view addSubview:clear];
    [UIView animateWithDuration:0.5 animations:^{
        clear.center = self.view.center;
    }];
}

- (void)collectAndNext
{
    // 横から、nextという文字を滑らせる
    UILabel *next = [[UILabel alloc] initWithFrame:CGRectMake(600, 240, 0, 0)];
    next.font = [UIFont boldSystemFontOfSize:40];
    next.textColor = [UIColor greenColor];
    next.text = @"Next";
    next.backgroundColor = [UIColor clearColor];
    [next sizeToFit];
    [self.view addSubview:next];
    [UIView animateWithDuration:0.5 animations:^{
        next.center = self.view.center;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            next.center = CGPointMake(-200, 240);
        } completion:^(BOOL finished) {
            [next removeFromSuperview];
            // カウントアップ
            question++;
            // restart
            [self showQuestion];
            
        }];
    }];
}

- (void)missAndRetry
{
    // 横から、missという文字を滑らせる
    UILabel *miss = [[UILabel alloc] initWithFrame:CGRectMake(600, 240, 0, 0)];
    miss.font = [UIFont boldSystemFontOfSize:50];
    miss.textColor = [UIColor redColor];
    miss.text = @"Miss";
    miss.backgroundColor = [UIColor clearColor];
    [miss sizeToFit];
    [self.view addSubview:miss];
    [UIView animateWithDuration:0.5 animations:^{
        miss.center = self.view.center;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            miss.center = CGPointMake(-200, 240);
        } completion:^(BOOL finished) {
            [miss removeFromSuperview];
            
            // restart
            [self showQuestion];
            
        }];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
