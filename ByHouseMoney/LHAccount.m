
//
//  LHAccount.m
//  ByHouseMoney
//
//  Created by 李辉 on 2018/5/23.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHAccount.h"

@implementation LHAccount

- (instancetype)initWithName:(NSString *)name money:(NSNumber *)money {
    if (self = [super init]) {
        self.name = name;
        self.money = [money integerValue];
    }
    return self;
}

+ (NSArray *)loadAccountsFor:(NSString *)key {
    NSString *infos = [[NSUserDefaults standardUserDefaults] stringForKey:key];
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

+ (void)saveAssetAccounts:(NSArray *)accounts forKey:(NSString *)key {
    if (accounts.count > 0) {
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
        for (LHAccount *account in accounts) {
            [tempDic setObject:@(account.money) forKey:account.name];
        }
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:tempDic options:NSJSONWritingPrettyPrinted error:&error];
        if (data) {
            NSString *info = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [[NSUserDefaults standardUserDefaults] setObject:info forKey:key];
        } else {
            NSLog(@"保存数据失败");
        }
    }
}

#pragma mark - 总资产
+ (NSArray *)loadAssetAccounts {
    return [self loadAccountsFor:[self assetKey]];
}

+ (void)saveAssetAccounts:(NSArray *)accounts {
    [self saveAssetAccounts:accounts forKey:[self assetKey]];
}

+(NSString *)assetKey {
    return NSStringFromClass([self class]);
}

#pragma mark - 欠款
+ (NSArray *)loadCreditAccounts {
    return [self loadAccountsFor:[self creditKey]];
}

+ (void)saveCreditAccounts:(NSArray *)accounts {
    [self saveAssetAccounts:accounts forKey:[self creditKey]];
}

+(NSString *)creditKey {
    return [NSString stringWithFormat:@"Credit_%@", NSStringFromClass([self class])];
}

@end
