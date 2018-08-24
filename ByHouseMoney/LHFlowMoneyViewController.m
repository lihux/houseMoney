//
//  LHFlowMoneyViewController.m
//  ByHouseMoney
//
//  Created by 李辉 on 2018/7/9.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHFlowMoneyViewController.h"

#import <math.h>

#import "LHAccount.h"

#define kBankStandYearRate 0.049
#define kGJJYearRate 0.0325

@interface LHFlowMoneyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *totalMoneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *houseDiscountTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankDiscountTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UITextField *myInputTextField;
@property (weak, nonatomic) IBOutlet UITextField *myWFInputTextField;
@property (weak, nonatomic) IBOutlet UITextField *myGJJTextField;
@property (weak, nonatomic) IBOutlet UITextField *myWFGJJTextField;
@property (weak, nonatomic) IBOutlet UITextField *zjRateTextField;
@property (weak, nonatomic) IBOutlet UITextField *futureIncomeTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;

@end

@implementation LHFlowMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnBackgroundView:)];
    [self.view addGestureRecognizer:gesture];
}

#pragma mark - actions

- (IBAction)didTapOnCalculateButton:(id)sender {
    [self didTapOnBackgroundView:nil];
    NSInteger totalPrice = [self.totalMoneyTextField.text floatValue] * 10000;
    CGFloat houseDiscount = [self.houseDiscountTextField.text integerValue] / 100.0;
    NSInteger houseNetPrice = totalPrice * houseDiscount;
    NSInteger totalBorrow = (NSInteger)(houseNetPrice * 0.65), gjjBorrow = 120 * 10000;
    totalBorrow -=(totalBorrow % 10000);
    NSInteger comBorrow = totalBorrow - gjjBorrow, pureFirstPay = totalPrice - totalBorrow;
    CGFloat bankMonthRate = kBankStandYearRate * (1 + [self.bankDiscountTextField.text integerValue] / 100.0) / 12.0;
    CGFloat gjjMonthRate = kGJJYearRate / 12.0;
    CGFloat zjRate = [self.zjRateTextField.text floatValue] * 0.01;
    NSInteger futureIncome = [self.futureIncomeTextField.text integerValue];
    NSInteger months = [self.yearTextField.text integerValue] * 12;
    NSInteger totalInput = [self.myInputTextField.text integerValue] + [self.myWFInputTextField.text integerValue] + [self.myGJJTextField.text integerValue] + [self.myWFGJJTextField.text integerValue];
    NSString *result = [NSString stringWithFormat:@"总价%.1f万元\t评估%.0f成新\t网签价:%ld万 贷款总额:%ld万\n 纯首付%.1f万, 商贷%ld万, 公积金%ld万", totalPrice / 10000.0, houseDiscount * 100, houseNetPrice / 10000, totalBorrow / 10000, pureFirstPay / 10000.0, comBorrow / 10000, gjjBorrow / 10000];


    //等额本息计算公式：每月月供额 = 贷款本金×月利率×(1+月利率)^还款月数〕/〔(1+月利率)^还款月数-1〕
    //公积金贷款月还款额计算：
    CGFloat gjjTemp = pow(1 + gjjMonthRate, months);
    CGFloat gjjMonthPay = (gjjBorrow * gjjMonthRate * gjjTemp) / (gjjTemp - 1);
    
    //商贷月还款额计算：
    CGFloat comTemp = pow(1 + bankMonthRate, months);
    CGFloat comMonthPay = (comBorrow * bankMonthRate * comTemp) / (comTemp - 1);
    NSInteger totalMonthPay = (NSInteger)(gjjMonthPay + comMonthPay);
    NSInteger monthLeft = totalInput - totalMonthPay;
    CGFloat taxC = houseNetPrice * 0.01, zjf = totalPrice * zjRate;
    NSInteger totalNeed = pureFirstPay + taxC + zjf;
    NSInteger creditTax = 43000;
    
    result = [result stringByAppendingString:[NSString stringWithFormat:@"\n月还款公积金:%ld元, ", (NSInteger)gjjMonthPay]];
    result = [result stringByAppendingString:[NSString stringWithFormat:@"商贷:%ld元, ", (NSInteger)comMonthPay]];
    result = [result stringByAppendingString:[NSString stringWithFormat:@"总计:%ld元, ", totalMonthPay]];
    result = [result stringByAppendingString:[NSString stringWithFormat:@"\n家庭月入:%ld元, 还房贷后净剩:%ld元", totalInput, monthLeft]];
    result = [result stringByAppendingString:[NSString stringWithFormat:@"\n净首付:%.1f万，契税:%.2f万,中介费%.4f万", pureFirstPay / 10000.0, taxC / 10000, zjf / 10000]];
    result = [result stringByAppendingString:[NSString stringWithFormat:@"\n总首付:%.2f万", (pureFirstPay + taxC + zjf) / 10000]];
    
    NSArray *accounts = [LHAccount loadAssetAccounts];
    NSInteger totalCurrency = futureIncome;
    for (LHAccount *account in accounts) {
        totalCurrency += account.money;
    }

    result = [result stringByAppendingString:[NSString stringWithFormat:@"已筹:%ld万,契税刷信用卡\t因此需借贷：%.2f万元", totalCurrency / 10000, (totalNeed - totalCurrency - creditTax) / 10000.0]];

    self.resultLabel.text = result;
}

- (void)didTapOnBackgroundView:(id)sender {
    for (UITextField *textField in self.textFields) {
        [textField resignFirstResponder];
    }
}

@end
