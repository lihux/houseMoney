//
//  LHDetailViewController.h
//  ByHouseMoney
//
//  Created by 李辉 on 2018/5/23.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LHAccount;
@class LHDetailViewController;

@protocol LHDetailViewControllerDelegate<NSObject>

- (void)detailViewController:(LHDetailViewController *)viewController finishBuildAccount:(LHAccount *)account;

@end

@interface LHDetailViewController : UIViewController

@property (nonatomic, weak) id<LHDetailViewControllerDelegate> delegate;

+ (instancetype)detailVCWithAccount:(LHAccount *)account delegate:(id<LHDetailViewControllerDelegate>)delegate;

@end
