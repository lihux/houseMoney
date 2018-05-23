
//
//  LHAccount.m
//  ByHouseMoney
//
//  Created by 李辉 on 2018/5/23.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHAccount.h"

@implementation LHAccount

+ (NSArray *)loadAccounts {
    NSString *infos = [[NSUserDefaults standardUserDefaults] stringForKey:NSStringFromClass([self class])];
    if (infos) {
        NSData *jsonData = [infos dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            NSLog(@"json解析失败：%@", error.localizedDescription);
            return nil;
        }
        NSMutableArray *accounts = [[NSMutableArray alloc] init];
        for (NSString *key in dic.allKeys) {
            [accounts addObject:[[LHAccount alloc] initWithName:key money:dic[key]]];
        }
        return [NSArray arrayWithArray:accounts];
    }
    return nil;
}

- (instancetype)initWithName:(NSString *)name money:(NSNumber *)money {
    if (self = [super init]) {
        self.name = name;
        self.money = [money integerValue];
    }
    return self;
}

+ (void)saveAccounts:(NSArray *)accounts {
    if (accounts.count > 0) {
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
        for (LHAccount *account in accounts) {
            [tempDic setObject:@(account.money) forKey:account.name];
        }
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:tempDic options:NSJSONWritingPrettyPrinted error:&error];
        if (data) {
            NSString *info = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [[NSUserDefaults standardUserDefaults] setObject:info forKey:NSStringFromClass([self class])];
        } else {
            NSLog(@"保存数据失败");
        }
    }
}

@end
