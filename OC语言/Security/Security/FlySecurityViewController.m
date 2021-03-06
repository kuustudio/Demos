//
//  FlySecurityViewController.m
//  Security
//
//  Created by walg on 2017/5/25.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlySecurityViewController.h"

#import "LocalAuthentication/LocalAuthentication.h"

@interface FlySecurityViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *securitTextField;
@end

@implementation FlySecurityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([FlyUserSettingManager sharedInstance].passWord) {
        [self creatViews];
    }
    if ([FlyUserSettingManager sharedInstance].useTouchID) {
        [self userTouchID];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


-(void)creatViews
{
    _securitTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    [_securitTextField setTextAlignment:NSTextAlignmentCenter];
    _securitTextField.center = CGPointMake(SCREEN_WIDTH/2.0,200);
    _securitTextField.backgroundColor = [UIColor clearColor];
    _securitTextField.layer.borderWidth = 1;
    _securitTextField.layer.borderColor = [UIColor greenColor].CGColor;
    _securitTextField.secureTextEntry = YES;
    [_securitTextField setKeyboardType:UIKeyboardTypeNumberPad];
    _securitTextField.delegate =self;
    [self.view addSubview:_securitTextField];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setBackgroundColor:[UIColor clearColor]];
    [confirmBtn setFrame:CGRectMake(0, 0, 100, 30)];
    confirmBtn.center = CGPointMake(SCREEN_WIDTH/2.0, 200+40);
    [confirmBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmCliction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
}

-(void)confirmCliction
{
    if ([_securitTextField.text isEqualToString:[FlyUserSettingManager sharedInstance].passWord]) {
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(confirmSuccess)]){
                [self.delegate confirmSuccess];
            }
        }
    }else{
        
        
    }
}

-(void)userTouchID
{
    __block typeof(self) weakSelf = self;
    NSError *error = nil;
    LAContext  *context = [LAContext new];
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        NSLog(@"支持指纹识别");
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"使用指纹解锁" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.delegate) {
                        if ([weakSelf.delegate respondsToSelector:@selector(confirmSuccess)]){
                            [weakSelf.delegate confirmSuccess];
                        }
                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.delegate) {
                        if ([weakSelf.delegate respondsToSelector:@selector(confirmFailed)]) {
                            [weakSelf.delegate confirmFailed];
                        }
                    }
                });
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"系统取消授权，如其他APP切入");
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        NSLog(@"用户取消验证Touch ID");
                        [weakSelf.securitTextField becomeFirstResponder];
                    }];
                        
                        break;
                    }
                    case LAErrorAuthenticationFailed:
                    {
                        NSLog(@"授权失败");
                        break;
                    }
                    case LAErrorPasscodeNotSet:
                    {
                        NSLog(@"系统未设置密码");
                        break;
                    }
                    case LAErrorTouchIDNotAvailable:
                    {
                        NSLog(@"设备Touch ID不可用，例如未打开");
                        break;
                    }
                    case LAErrorTouchIDNotEnrolled:
                    {
                        NSLog(@"设备Touch ID不可用，用户未录入");
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"用户选择输入密码，切换主线程处理");
                            [weakSelf.securitTextField becomeFirstResponder];
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"其他情况，切换主线程处理");
                        }];
                        break;
                    }
                }
            }
        }];
    }else{
        NSLog(@"不支持指纹识别");
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        NSLog(@"%@",error.localizedDescription);
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self resignSelfFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)resignSelfFirstResponder
{
     [_securitTextField resignFirstResponder];
}

@end
