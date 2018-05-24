//
//  LHDetailViewController.m
//  ByHouseMoney
//
//  Created by 李辉 on 2018/5/23.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHDetailViewController.h"

#import "LHAccount.h"

@interface LHDetailViewController ()

@property (nonatomic, strong) LHAccount *account;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;

@end

@implementation LHDetailViewController

+ (instancetype)detailVCWithAccount:(LHAccount *)account delegate:(id<LHDetailViewControllerDelegate>)delegate {
    LHDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LHDetailViewController"];
    vc.account = account;
    vc.delegate = delegate;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.account) {
        self.nameTextField.text = self.account.name;
        self.nameTextField.enabled = NO;
        [self.moneyTextField becomeFirstResponder];
        self.moneyTextField.text = [NSString stringWithFormat:@"%ld", (long)self.account.money];
    } else {
        [self.nameTextField becomeFirstResponder];
    }
}

- (IBAction)didTapOnOKButton:(id)sender {
    NSString *name = self.nameTextField.text;
    NSInteger money = [self.moneyTextField.text integerValue];
    if (name.length > 0 && money > 0) {
        LHAccount *account = [[LHAccount alloc] initWithName:name money:@(money)];
        if ([self.delegate respondsToSelector:@selector(detailViewController:finishBuildAccount:)]) {
            [self.delegate detailViewController:self finishBuildAccount:account];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
