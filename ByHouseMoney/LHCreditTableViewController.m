//
//  LHCreditTableViewController.m
//  ByHouseMoney
//
//  Created by 李辉 on 2018/8/24.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHCreditTableViewController.h"

#import "LHAccount.h"
#import "LHMainTableViewCell.h"
#import "LHDetailViewController.h"

@interface LHCreditTableViewController () <LHDetailViewControllerDelegate>

@property (nonatomic, strong) NSArray *accounts;
@property (nonatomic, assign) NSInteger totalMoney;

@end

@implementation LHCreditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.accounts = [LHAccount loadCreditAccounts];
    [self reloadData];
}

- (void)reloadData {
    NSInteger totalMoney = 0;
    for (LHAccount *account in self.accounts) {
        totalMoney += account.money;
    }
    self.totalMoney = totalMoney;
    self.title = @"欠债";
    self.accounts = [self.accounts sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [(LHAccount *)obj1 money] < [(LHAccount *)obj2 money];
    }];
    [self.tableView reloadData];
}

#pragma mark - actions

- (IBAction)saveScreen:(id)sender {
    UIImage* image = nil;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，调整清晰度。
    UIGraphicsBeginImageContextWithOptions(self.tableView.contentSize, YES, [UIScreen mainScreen].scale);
    CGPoint savedContentOffset = self.tableView.contentOffset;
    CGRect savedFrame = self.tableView.frame;
    self.tableView.contentOffset = CGPointZero;
    self.tableView.frame = CGRectMake(0, 0, self.tableView.contentSize.width, self.tableView.contentSize.height);
    [self.tableView.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    self.tableView.contentOffset = savedContentOffset;
    self.tableView.frame = savedFrame;
    
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        //保存图片到相册
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    NSString *msg = error == NULL ? @"保存图片成功，可到相册查看" : @"保存图片失败";
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.accounts.count;
    return count > 0 ? count + 1 : count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifiler = NSStringFromClass([LHMainTableViewCell class]);
    LHMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiler forIndexPath:indexPath];
    LHAccount *account = indexPath.row == self.accounts.count ? [[LHAccount alloc] initWithName:@"总借入金额:" money:@(self.totalMoney)] : self.accounts[indexPath.row];
    [cell configCellWithAccount:account];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.row == self.accounts.count && self.accounts.count > 0) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *temp = [NSMutableArray arrayWithArray:self.accounts];
        [temp removeObjectAtIndex:indexPath.row];
        self.accounts = [NSArray arrayWithArray:temp];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [LHAccount saveCreditAccounts:self.accounts];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != self.accounts.count) {
        LHAccount *account = [self.accounts objectAtIndex:indexPath.row];
        LHDetailViewController *detailViewController = [LHDetailViewController detailVCWithAccount:account delegate:self];
        [self.navigationController pushViewController:detailViewController animated:YES];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - LHDetailViewControllerDelegate
- (void)detailViewController:(LHDetailViewController *)viewController finishBuildAccount:(LHAccount *)account {
    if (!account) {
        return;
    }
    BOOL hasDone = NO;
    for (LHAccount *temp in self.accounts) {
        if ([temp.name isEqualToString:account.name]) {
            temp.money = account.money;
            [self reloadData];
            hasDone = YES;
            break;
        }
    }
    if (!hasDone) {
        NSMutableArray *array = [NSMutableArray arrayWithObject:account];
        if (self.accounts.count > 0) {
            [array addObjectsFromArray:self.accounts];
        }
        self.accounts = [NSArray arrayWithArray:array];
        [self reloadData];
    }
    [LHAccount saveCreditAccounts:self.accounts];
}

#pragma mark - segue issues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[LHDetailViewController class]]) {
        [(LHDetailViewController *)segue.destinationViewController setDelegate:self];
    }
}

@end
