//
//  LHMainTableViewCell.m
//  ByHouseMoney
//
//  Created by 李辉 on 2018/5/23.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHMainTableViewCell.h"

#import "LHAccount.h"

@interface LHMainTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end
@implementation LHMainTableViewCell

- (void)configCellWithAccount:(LHAccount *)account {
    if (account) {
        self.nameLabel.text = account.name;
        self.moneyLabel.text = [NSString stringWithFormat:@"%ld", (long)account.money];
    }
}

@end
