//
//  LHTaxCalViewController.m
//  ByHouseMoney
//
//  Created by 李辉 on 2019/8/26.
//  Copyright © 2019 李辉. All rights reserved.
//

#import "LHTaxCalViewController.h"

@interface LHTaxCalViewController ()

@property (weak, nonatomic) IBOutlet UITextField *salaryTextField;
@property (weak, nonatomic) IBOutlet UITextField *GJJBaseTextField;
@property (weak, nonatomic) IBOutlet UITextField *childTextField;
@property (weak, nonatomic) IBOutlet UITextField *houseLoadTextField;
@property (weak, nonatomic) IBOutlet UITextField *parentTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UITextField *extraTextField;

@end

@implementation LHTaxCalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个税计算";
}

- (IBAction)didTapOnCalculateButton:(id)sender {
    CGFloat salary = [self.salaryTextField.text floatValue];//月薪
    CGFloat base = [self.GJJBaseTextField.text floatValue];//公积金月缴存上限
    CGFloat childReduce = [self.childTextField.text floatValue];//养娃减税
    CGFloat houseLoadReduce = [self.houseLoadTextField.text floatValue];//房贷减税
    CGFloat parentRecude = [self.parentTextField.text floatValue];//父母养老减税
    CGFloat extraIncome = [self.extraTextField.text floatValue];//餐补等其他补助
    if (salary <= 0 || base <= 0) {
        return;//输入内容非法，取消计算
    }
    
    CGFloat total = salary * 12;//年总收入】
    CGFloat baseReduce = 5000;//基础扣除数，2019更新
    CGFloat realBase = salary > base ? base : salary;
    CGFloat dbtc = 3;//大病统筹每月3块钱
    CGFloat month5X1JReduce = realBase * 0.222 + dbtc;//公积金12%,养老保险8%,医疗保险2%,失业保险0.2%
    CGFloat monthTaxPart = salary - childReduce - houseLoadReduce - parentRecude - baseReduce - month5X1JReduce;//每月的应纳税所得额
    CGFloat totalTaxPart = monthTaxPart * 12;//全年应纳税所得额
    
    CGFloat tax = 0;
    if (totalTaxPart <= 36000) {
        tax = totalTaxPart * 0.03;//3.6万以下3%
    } else if (totalTaxPart <= 144000) {
        tax = totalTaxPart * 0.1 - 2520;//14.4万以下10%，速算扣除数2520
    } else if (totalTaxPart <= 300000) {
        tax = totalTaxPart * 0.2 - 16920;
    } else if (totalTaxPart <= 420000) {
        tax = totalTaxPart * 0.25 - 31920;
    } else if (totalTaxPart <= 660000) {
        tax = totalTaxPart * 0.3 - 52920;
    } else if (totalTaxPart <= 960000) {
        tax = totalTaxPart * 0.35 - 85920;//我在这里哟^_^
    } else {
        tax = totalTaxPart * 0.45 - 181920;//好吧，年薪百万的哥们，你赢了
    }
    
    CGFloat pureIncome = total - (month5X1JReduce * 12) - tax;
    
    CGFloat gjj = realBase * 0.24;
    CGFloat yb = realBase * 0.028;
    CGFloat oldMoney = realBase * 0.08;
    CGFloat part2 = gjj + yb;
    CGFloat part2Income = part2 * 12;
    CGFloat totalIncome = pureIncome + part2Income;
    CGFloat realTotalIncome = totalIncome + oldMoney * 12;
    
    CGFloat realRealTotalIncom = realTotalIncome + (extraIncome * 12);
    NSString *result = [NSString stringWithFormat:@"年工资总收入%.4f万元，平均每月：%ld元\n\n五险一金提取总收入%.4f万元，平均每月%ld元\n年总收入%.4f万元，平均每月:%ld元", pureIncome / 10000, (NSInteger)pureIncome / 12, part2Income / 10000, (NSInteger)part2, totalIncome / 10000, (NSInteger)totalIncome / 12];
    result = [NSString stringWithFormat:@"%@\n\n算上养老保险个人账户的绝对总收入是：%.4f万元，平均每月 %ld元, 养老个人账户%ld元", result, realTotalIncome / 10000, (NSInteger)realTotalIncome / 12, (NSInteger)oldMoney];
    
    if (extraIncome > 0) {
        result = [NSString stringWithFormat:@"%@\n\n算上养老和饭补等所有的绝对总收入是：%.4f万元，平均每月 %ld元, 饭补等每月%ld元", result, realRealTotalIncom / 10000, (NSInteger)realRealTotalIncom / 12, (NSInteger)extraIncome];
    }
    
    result = [NSString stringWithFormat:@"%@\n\n税前年薪是：%.4f万,共计纳税%.4f万元！", result, salary * 12 / 10000, tax / 10000];
    
    self.resultLabel.text = result;
}

@end
