//
//  FlyDetailTableViewCell.h
//  Security
//
//  Created by walg on 2017/1/5.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyBasicTableViewCell.h"

static const int Fly_FontSize = 14.f;

@interface FlyDisPlayTableViewCell : FlyBasicTableViewCell

@property (nonatomic, strong) UITextField *  leftField;
@property (nonatomic, strong) UITextField *  rightField;

@property (nonatomic, strong) NSString    *  leftString;
@property (nonatomic, strong) NSString    *  rightString;

@property (nonatomic, assign) BOOL           showSecurityButton;

@end
