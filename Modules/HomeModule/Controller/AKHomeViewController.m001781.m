//
//  AKHomeViewController.m
//  Project
//
//  Created by ankye on 2016/11/15.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKHomeViewController.h"
#import "AKADView.h"

@interface AKHomeViewController ()

@end

@implementation AKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)doActionTest:(id)sender {
    
    [self createDlg:@"NavTitle1" withColor:[UIColor whiteColor]];
    [self createDlg:@"NavTitle2" withColor:[UIColor redColor]];
    [self createDlg:@"NavTitle3" withColor:[UIColor greenColor]];
    [self createDlg:@"NavTitle4" withColor:[UIColor blueColor]];
}

-(void) createDlg:(NSString*)title withColor:(UIColor*)color
{
    NSMutableDictionary* attributes = [AKPopupManager buildPopupAttributes:YES showNav:YES style:STPopupStyleFormSheet navTitle:title touchBGClose:YES onClick:^(NSInteger channel, NSMutableDictionary *attributes) {
        NSLog(@"On Click");
    } onClose:^(NSMutableDictionary *attributes) {
        NSLog(@"On Close");
        
    }];
    [[AKPopupManager sharedManager] showView:[[AKADView alloc] initWithColor:color] withAttributes:attributes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
