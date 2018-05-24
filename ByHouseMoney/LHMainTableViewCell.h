//
//  LHMainTableViewCell.h
//  ByHouseMoney
//
//  Created by 李辉 on 2018/5/23.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LHAccount;

@interface LHMainTableViewCell : UITableViewCell

- (void)configCellWithAccount:(LHAccount *)account;

@end
