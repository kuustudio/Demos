//
//  ViewController.m
//  UICollectionView+Runtime
//
//  Created by Walg on 2018/12/1.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "ViewController.h"
#import "FlyFlowLayout.h"
#import <objc/runtime.h>
#import "FlyMenuController.h"
#import "FlyCollectionView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


#ifdef DEBUG
//#define FlyLog(FORMAT, ...) fprintf(stderr, "\n\n******(class)%s(begin)******\n(SEL)%s\n(data)%s\n******(class)%s(end)******\n\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __FUNCTION__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String], [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String]);

#define FlyLog(FORMAT, ...) fprintf(stderr, "\n%s\n",[[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);

#else
#define FlyLog(FORMAT, ...) nil
#endif

static NSString * kIdentifier_CELL     = @"cell_identifier";
static NSString * kIdentifier_HEADER   = @"header_identifier";
static NSString * kIdentifier_FOOTER   = @"footer_identifier";
static NSString * kIdentifier_HEADER_A = @"header_identifier_a";

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView  * collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout  * layout;

@property (nonatomic, assign) CGFloat   itemHeight;

@property (nonatomic, strong) NSMutableArray   *   dataSourceArr;

@property (nonatomic, strong) NSIndexPath   *   currentIndexPath;
@property (nonatomic, strong) FlyMenuItem   *   repeatItem;
@property (nonatomic, strong) FlyMenuItem   *   pasteItem;
@property (nonatomic, strong) FlyMenuItem   *   deleteItem;
@property (nonatomic, strong) FlyMenuController   *   menuController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _itemHeight = 100.f;
//    _dataSourceArr = [@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16"] mutableCopy];
    _dataSourceArr = [@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"] mutableCopy];
    
    UIMenuItem * repeatItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(a)];
    UIMenuItem * deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(a)];
    
    [[UIMenuController sharedMenuController] setMenuItems:@[repeatItem, deleteItem]];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

- (void)a
{
    
}

- (FlyMenuController *)menuController
{
    if (!_menuController) {
        _menuController = [FlyMenuController sharedMenuController];
        _repeatItem = [[FlyMenuItem alloc] initWithTitle:@"复制" fontSize:14.f];
        _pasteItem = [[FlyMenuItem alloc] initWithTitle:@"粘贴" fontSize:14.f];
        _deleteItem = [[FlyMenuItem alloc] initWithTitle:@"删除" fontSize:14.f];
        [_menuController setMenuItems:@[_repeatItem,_deleteItem]];
        __weak typeof(self) weakSelf = self;
        _menuController.flyMenuClickBlock = ^(FlyMenuItem * _Nonnull menuItem, UIView * _Nonnull relyView) {
            [weakSelf menuDidClick:menuItem];
        };
    }
    return _menuController;
}

- (void)menuDidClick:(FlyMenuItem *)menuItem
{
    id object = _dataSourceArr[_currentIndexPath.row];
    if (menuItem == _repeatItem) {
        [_dataSourceArr insertObject:object atIndex:_currentIndexPath.row];
        [self.collectionView insertItemsAtIndexPaths:@[_currentIndexPath]];
    } else if (menuItem == _pasteItem) {
        
        [self.collectionView insertItemsAtIndexPaths:@[_currentIndexPath]];
    } else if (menuItem == _deleteItem) {
        [_dataSourceArr removeObjectAtIndex:_currentIndexPath.row];
        [self.collectionView deleteItemsAtIndexPaths:@[_currentIndexPath]];
    }
}

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
//        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[FlyCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        [_collectionView setContentInset:UIEdgeInsetsMake(60.f, 15.f, 60.f, 15.f)];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kIdentifier_CELL];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kIdentifier_HEADER];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kIdentifier_HEADER_A];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kIdentifier_FOOTER];
//        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:@"ABCD_ABCD" withReuseIdentifier:@"EUEUEUEU"];

        [_collectionView setBackgroundColor:[UIColor cyanColor]];
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    FlyLog(@" 1、SectionNum---->>>>numberOfSectionsInCollectionView");
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    FlyLog(@" 2、ItemsNum---->>>>numberOfItemsInSection section:%ld",section);
    return _dataSourceArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifier_CELL forIndexPath:indexPath];
    
    UILabel * label = [cell.contentView viewWithTag:10086];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:cell.bounds];
        [label setTag:10086];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor blackColor]];
        [label setNumberOfLines:0];
        [label setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.3]];
        //        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClickAction)];
        //        [label addGestureRecognizer:tap];
        //        [label setUserInteractionEnabled:YES];
        [cell.contentView addSubview:label];
    }
    
    UIButton * button = [cell.contentView viewWithTag:10087];
    if (!button) {
        button = [[UIButton alloc] initWithFrame:cell.bounds];
        [button addTarget:self action:@selector(buttonClickAction) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:10087];
        [button setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
        [cell.contentView addSubview:button];
    }
    
    UIView * view = [cell.contentView viewWithTag:10088];
    if (!view) {
        view = [[UIView alloc] initWithFrame:cell.bounds];
        [view setTag:10088];
        [view setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.3]];
        //        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClickAction)];
        //        [view addGestureRecognizer:tap];
        [cell.contentView addSubview:view];
    }
    
    [cell setBackgroundColor:[UIColor purpleColor]];
    CGRect cellBounds = cell.bounds;
    
    [label setFrame:CGRectMake(0, 0, cellBounds.size.width * 0.5, cellBounds.size.height)];
    [button setFrame:CGRectMake(cellBounds.size.width * 0.5, 0, cellBounds.size.width * 0.5, cellBounds.size.height * 0.5)];
    [view setFrame:CGRectMake(cellBounds.size.width * 0.5, cellBounds.size.height * 0.5, cellBounds.size.width * 0.5, cellBounds.size.height * 0.5)];
//    [label setText:[NSString stringWithFormat:@"%@-%@\n %p",@(indexPath.section),@(indexPath.row),cell]];
    
    [label setText:[NSString stringWithFormat:@"%@-%@",@(indexPath.section),@(indexPath.row)]];
//    [label setText:_dataSourceArr[indexPath.row]];
    
    FlyLog(@" 3、cell---->>>>cellForItemAtIndexPath index:%@",indexPath);
    
    return cell;
}

- (void)buttonClickAction
{
    FlyLog(@"buttonClickAction");
}

- (void)labelClickAction
{
    FlyLog(@"labelClickAction");
}

- (void)viewClickAction
{
    FlyLog(@"viewClickAction");
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = @"";
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        identifier = kIdentifier_HEADER;
    } else {
        identifier = kIdentifier_FOOTER;
    }
    UICollectionReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        [reusableView setBackgroundColor:[UIColor purpleColor]];
    } else {
        [reusableView setBackgroundColor:[UIColor redColor]];
    }
    
    UILabel * label = [reusableView viewWithTag:10086];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:reusableView.bounds];
        [label setTag:10086];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor blackColor]];
        [reusableView addSubview:label];
    }
    [label setFrame:reusableView.bounds];
    [label setText:kind];
    
    FlyLog(@" 4、Suppleme---->>>>viewForSupplemen kind:%@ index:%@ point : %@",kind,indexPath,[NSValue valueWithCGPoint:reusableView.frame.origin]);
    
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlyLog(@" 5、itemSize---->>>>sizeForItemAtIndexPath index:%@",indexPath);
    CGFloat height = 50.f;
    CGFloat weight = 100.f;
    if (indexPath.row % 3 == 1) {
        height = 150.f;
    } else if (indexPath.row % 3 == 2) {
        height = 100.f;
    }
    if (indexPath.row % 4 == 1) {
        weight = 50.f;
    } else if (indexPath.row % 4 == 2) {
        weight = 100.f;
    } else if (indexPath.row % 4 == 3) {
        weight = 150.f;
    }
    return CGSizeMake(weight, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    FlyLog(@" 6、LineSpacing---->>>>minimumLineSpacingForSectionAtIndex section:%ld",section);
    return 10.f;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    FlyLog(@" 7、InteritemSpacing---->>>>minimumInteritemSpacingForSectionAtIndex section:%ld",section);
    return 10.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    FlyLog(@" 8、inset---->>>>insetForSectionAtIndex section:%ld",section);
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    FlyLog(@" 9、SizeForHeader---->>>>referenceSizeForHeaderInSection section:%ld",section);
    return CGSizeMake(100.f, 45.f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    FlyLog(@" 10、SizeForFooter---->>>>referenceSizeForFooterInSection section:%ld",section);
    return CGSizeMake(100.f, 30.f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlyLog(@" ---->>>>>>>>didSelectItemAtIndexPath");
//    if (indexPath.row % 3 == 0) {
//        FlyLog(@" *->>reload : %ld - %ld",indexPath.section,indexPath.row);
//        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
//        //        [self.layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    } else if (indexPath.row % 3 == 1) {
//        FlyLog(@" *->>insert : %ld - %ld",indexPath.section,indexPath.row);
//        [self.dataSourceArr insertObject:@"1" atIndex:indexPath.row];
//        [collectionView insertItemsAtIndexPaths:@[indexPath]];
//        //        [self.layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    } else {
//        FlyLog(@" *->>delete : %ld - %ld",indexPath.section,indexPath.row);
//        [self.dataSourceArr removeObjectAtIndex:indexPath.row];
//        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
//        //        [self.layout setScrollDirection:UICollectionViewScrollDirectionVertical];
//    }
//    [self.collectionView reloadData];
//    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
//    if (cell) {
//        _currentIndexPath = indexPath;
//        [self.menuController showRelyView:cell inView:collectionView];
//        [self.menuController setMenuVisible:YES animated:YES];
//    }
    
//    [self getClassMethods:self.collectionView];
    id instance = [NSClassFromString(@"_UILabelLayer") new];
    [self loopInstanceSuperClass:instance];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    FlyLog(@" 11、scroll---->>>>scrollViewDidScroll contentOffset.y:%f %@",scrollView.contentOffset.y,[NSValue valueWithCGSize:scrollView.contentSize]);
}

- (void)loopInstanceSuperClass:(id)instance
{
    while (![instance isMemberOfClass:[NSObject class]]) {
        [self getClassMethods:instance];
        instance = [[instance superclass] new];
    }
}

- (void)getClassMethods:(id)instance
{
    FlyLog(@"-------------------------********-------------------------");
    FlyLog(@"当前类名：%@",[instance class])
    NSMutableArray *methodArray = [NSMutableArray array];
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList([instance class], &methodCount);
    for (int i= 0; i<methodCount; i++) {
        Method method = methodList[i];
        SEL  methodSEL = method_getName(method);
        [methodArray addObject:NSStringFromSelector(methodSEL)];
    }
    free(methodList);
    FlyLog(@"实例方法：%@",methodArray);
    
    //类方法都是在元类方法列表里
    methodCount = 0;
    const char *clsName = class_getName([instance class]);
    Class metaClass = objc_getMetaClass(clsName);
    Method * metaMethodList = class_copyMethodList(metaClass, &methodCount);
    [methodArray removeAllObjects];
    for (int i = 0; i < methodCount ; i ++) {
        Method method = metaMethodList[i];
        SEL selector = method_getName(method);
        const char * methodCharName = sel_getName(selector);
        [methodArray addObject:NSStringFromSelector(selector)];
    }
    free(metaMethodList);
    FlyLog(@"类方法：%@",methodArray);
    
    
    //获取成员变量和属性
    NSMutableDictionary * nameTypeDict = [NSMutableDictionary dictionary];
    unsigned int ivarCount;
    Ivar * ivars = class_copyIvarList([instance class], &ivarCount);
    for (int i = 0; i<ivarCount; i++) {
        Ivar ivar = ivars[i];
        const char * ivarCharName = ivar_getName(ivar);
        const char * ivarCharType = ivar_getTypeEncoding(ivar);
        NSString * ivarName = [NSString stringWithCString:ivarCharName encoding:NSUTF8StringEncoding];
        NSString * ivarType = [NSString stringWithCString:ivarCharType encoding:NSUTF8StringEncoding];
        [nameTypeDict setObject:ivarType forKey:ivarName];
    }
    free(ivars);
    FlyLog(@"成员变量和属性:%@",nameTypeDict);
    
    //获取属性
    [nameTypeDict removeAllObjects];
    unsigned int outCount;
    objc_property_t * propertyList = class_copyPropertyList([instance class], &outCount);
    for (int i = 0; i<outCount; i++) {
        objc_property_t property = propertyList[i];
        const char * propertyChar = property_getName(property);
        const char * attributesChar = property_getAttributes(property);
        NSString * propertyName = [NSString stringWithCString:propertyChar encoding:NSUTF8StringEncoding];
        char * attributeValue = property_copyAttributeValue(property, attributesChar);
        NSString * attributesStr = @"";
        if (!attributesChar) {
            attributesStr = @"NULL";
        } else {
            attributesStr = [NSString stringWithCString:attributesChar encoding:NSUTF8StringEncoding];
        }
        [nameTypeDict setObject:attributesStr forKey:propertyName];
    }
    free(propertyList);
    FlyLog(@"属性:%@",nameTypeDict);

    //获取协议列表
    NSMutableArray *protocoArray = [NSMutableArray array];
    unsigned int protocoCount = 0;
    __unsafe_unretained Protocol ** protocolList =  class_copyProtocolList([instance class], &protocoCount);
    for (int i = 0; i<protocoCount; i++) {
        Protocol * protocol = protocolList[i];
        const char *protocolName =  protocol_getName(protocol);
        [protocoArray addObject:[NSString stringWithUTF8String:protocolName]];
    }
    FlyLog(@"协议列表：%@",protocoArray);
    FlyLog(@"-------------------------********-------------------------");
}

@end
