//
//  FlyTabBarViewController.m
//  Security
//
//  Created by walg on 2017/1/4.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyTabBarViewController.h"

#import "FlyHomeViewController.h"

#import "FlyUserInfoViewController.h"

#import "FlySecurityViewController.h"

@interface FlyTabBarViewController ()<FlyConfirmDelegate>

@property (nonatomic, strong) UINavigationController *nvc;

@end

@implementation FlyTabBarViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FlyHomeViewController *homeVC = [[FlyHomeViewController alloc] init];
    UINavigationController *homeNV = [[UINavigationController alloc]initWithRootViewController:homeVC];
    homeNV.tabBarItem.title = @"主页";
    homeNV.tabBarItem.image = [UIImage imageNamed:@"home"];
//    homeNV.tabBarItem.selectedImage = [UIImage imageNamed:@"home_selected"];
    homeNV.navigationBar.hidden = YES;
    
    FlyUserInfoViewController *userInfoVC = [[FlyUserInfoViewController alloc] init];
    UINavigationController *userInfoNV = [[UINavigationController alloc]initWithRootViewController:userInfoVC];
    userInfoNV.tabBarItem.title = @"设置";
    userInfoNV.tabBarItem.image = [UIImage imageNamed:@"me"];
//    userInfoNV.tabBarItem.selectedImage = [UIImage imageNamed:@"me_selected"];
    userInfoNV.navigationBar.hidden = YES;
    
    self.viewControllers = @[homeNV,userInfoNV];
    
    [self setSelectedIndex:0];
    [self needShowView];
}

-(void)needShowView{
    if ([FlyUserSettingManager sharedInstance].needShowSecuriView) {
        [self showSecurityView];
    }
}

-(void)showSecurityView{
    
    FlySecurityViewController *securityView = [[FlySecurityViewController alloc] init];
    _nvc = [[UINavigationController alloc] initWithRootViewController:securityView];
    _nvc.navigationBarHidden = YES;
    _nvc.view.frame = self.view.bounds;

    securityView.delegate = self;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view addSubview:_nvc.view];
    }];
}

-(void)confirmSuccess{
    [self hiddenSecurityView];
}

-(void)confirmFailed{
    
}

-(void)hiddenSecurityView{
    
    [UIView animateWithDuration:0.2 animations:^{
        [_nvc.view removeFromSuperview];
    }];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
