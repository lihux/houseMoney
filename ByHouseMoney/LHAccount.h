//
//  LHAccount.h
//  ByHouseMoney
//
//  Created by 李辉 on 2018/5/23.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHAccount : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger money;

- (instancetype)initWithName:(NSString *)name money:(NSNumber *)money;
+ (void)saveAccounts:(NSArray *)accounts;
+ (NSArray *)loadAccounts;

@end
