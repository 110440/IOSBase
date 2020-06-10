//
//  RootViewController.m
//  XiangFeiShu
//
//  Created by tanson on 2020/4/2.
//  Copyright © 2020 XiangFeiShu. All rights reserved.
//

#import "RootViewController.h"
#import "MallViewController.h"
#import "GoodsCategoriesViewController.h"
#import "ShoppingCartViewController.h"
#import "XiangFeiShuViewController.h"
#import "MineViewController.h"
#import "BootViewController.h"
#import "ShoppingCart.h"

@interface RootViewController ()<UITabBarControllerDelegate>

@end

@implementation RootViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initControllers];
    self.tabBar.translucent  = NO;
    self.delegate = self;
    self.tabBar.barTintColor = ColorWithHex(0xFFFFFF);
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:ColorWithHex(0x666666)} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:ColorWithHex(0x055703)} forState:UIControlStateSelected];
    
    //登录成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateShopCartBadgeValue) name:kLoginSuccessNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateShopCartBadgeValue) name:kAddToShoppingCartName object:nil];
    if([[UserManager shareManager] isLogined]){
        [self updateShopCartBadgeValue];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if([Utils isFirstInstallApp]){
        BootViewController * boot = [BootViewController new];
        boot.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:boot animated:NO completion:nil];
    }
}

-(void)updateShopCartBadgeValue{
    [ShoppingCart getListSucc:^(NSArray * _Nonnull list) {
        __block NSInteger totoal = 0;
        [list enumerateObjectsUsingBlock:^(ShoppingCartStore * store, NSUInteger idx, BOOL * stop) {
            totoal += store.list.count;
        }];
        [Utils updateShopCartBadgeValue:totoal];
    } fail:^(NSString * _Nonnull msg) {}];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.selectedViewController beginAppearanceTransition:YES animated: animated];
}

- (void)initControllers{
    
    MallViewController * m = [MallViewController new];
    UINavigationController * mall = [self navControllerWithContoller:m
                                                               image:@"store"
                                                               imgHL:@"store_pre"];
    mall.tabBarItem.title = @"商城";
    
    
    GoodsCategoriesViewController * c = [GoodsCategoriesViewController new];
    UINavigationController * cat = [self navControllerWithContoller:c
                                                               image:@"classify"
                                                               imgHL:@"classify_pre"];
    cat.tabBarItem.title = @"分类";
    
    
    ShoppingCartViewController * s = [ShoppingCartViewController new];
    UINavigationController * shopCart = [self navControllerWithContoller:s
                                                               image:@"shopping"
                                                               imgHL:@"shopping_pre"];
    shopCart.tabBarItem.title = @"购物车";
    
    
    XiangFeiShuViewController * x = [XiangFeiShuViewController new];
    UINavigationController * xiang = [self navControllerWithContoller:x
                                                              image:@"torreya"
                                                              imgHL:@"torreya_pre"];
    xiang.tabBarItem.title = @"香榧树";
    
    MineViewController * mi = [MineViewController new];
    UINavigationController * mine = [self navControllerWithContoller:mi
                                                              image:@"my"
                                                              imgHL:@"my_pre"];
    mine.tabBarItem.title = @"我的";
    
    self.viewControllers = @[mall,cat,xiang,shopCart,mine];
}

- (UINavigationController*) navControllerWithContoller:(UIViewController*)vc image:(NSString*)img imgHL:(NSString*)imgHL {
    UIImage * image = [[UIImage imageNamed:img] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * image2 = [[UIImage imageNamed:imgHL] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = image2;
    vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
    return [[BaseNavigationController alloc] initWithRootViewController:vc];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    if([viewController.tabBarItem.title isEqualToString:@"购物车"] &&![[UserManager shareManager] isLogined]){
        [UserManager showLoginWithVc:tabBarController completion:^{
            [tabBarController setSelectedViewController:viewController];
        }];
        return NO;
    }
    return YES;
}

@end
