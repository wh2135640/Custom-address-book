//
//  ViewController.m
//  Demo
//
//  Created by 王虎 on 16/7/4.
//  Copyright © 2016年 王虎. All rights reserved.
//
#define Screen_height  [[UIScreen mainScreen] bounds].size.height
#define Screen_width  [[UIScreen mainScreen] bounds].size.width
#define RGB(r,g,b)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

#import "ViewController.h"
#import "modeObject.h"
#import "GetFirstLetter.h"
#import "NSMutableArray+FilterElement.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "FollowGroupModel.h"
#import "UIColor+HexString.h"
#import "ClubListModel.h"
#import "Utils.h"
#import <AMapLocationKit/AMapLocationKit.h>
static CGFloat height = 64+30;
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>@property (nonatomic,strong) UITableView * tableView; //
@property (nonatomic,strong) UITableView * tableViewSection; //索引的tableview
@property (nonatomic,strong) NSMutableArray *dataArray; // 数据源大数组
@property (nonatomic,strong) NSMutableArray *searchList; // 搜索结果的数组
@property (nonatomic,strong) NSMutableArray *array; // 数据源数组 分组和每个区的模型
@property (nonatomic,strong) NSMutableArray *sectionIndexs; // 放字母索引的数组
@property (nonatomic,strong) UISearchBar * searchBar;//搜索框
@property (assign, nonatomic) BOOL searchBarActive;
@property (strong, nonatomic) UITableView *searchResultTableView;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (strong, nonatomic) NSString *selectedClub;
@property (nonatomic, strong) NSString *currentCity;
@property (nonatomic, strong) NSString *currentCityID;
@property (nonatomic, assign) BOOL hasGetData;
@property (nonatomic, strong) NSMutableArray *currentCityClub;
//@property (nonatomic,strong) modeObject * modeobject;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @" 排名";
    self.searchBarActive = NO;
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor grayColor];
    NSArray * array = @[@"北京市 ",@"长治市 ",@"保定市 ",@"顺义区 ",@"锡林格勒市 ",@"邢台市 ",@"包头市 ",@"沧州市 ",@"沂州市 ",@"潍坊市 ",@"呼和浩特市 ",@"晋城市 ",@"赤峰市 ",@"济宁市 ",@"1济宁市 ",@"#济宁市 "];//     NSArray * array = @[@"重庆"];
//    NSLog(@"%lu",(unsigned long)array.count);
    for (int i = 0 ; i<array.count; i++) {
        ClubListModel * modeobject = [[ClubListModel alloc]init];
        modeobject.club_name = array[i];
        [self.dataArray addObject:modeobject];
         [self.dataArray addObject:modeobject];
         [self.dataArray addObject:modeobject];
    }
//     NSLog(@"%lu",(unsigned long)self.dataArray.count);
//    self.tableView.backgroundColor = [UIColor blueColor];
    
     [self.view addSubview:self.tableView];
    
    self.tableViewSection.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableViewSection];
    [self.view addSubview:self.searchBar];
    [self setTitleAndView];
    [self setUpSectionIndexTitleWithStr];
    [self getCurrentCity];
//    [self tableViewInit];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - 单次定位
- (void)getCurrentCity {
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    self.locationManager.locationTimeout = 3;
    self.locationManager.reGeocodeTimeout = 3;
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error) {
            self.hasGetData = NO;
            NSLog(@"locationError:%ld - %@;", (long)error.code, error.localizedDescription);
            self.currentCity = @"";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
        if (regeocode) {
            self.hasGetData = YES;
            NSLog(@"reGeocode:%@", regeocode.city ? regeocode.city : regeocode.province);
            NSLog(@"%@",regeocode);
            self.currentCity = regeocode.city ? regeocode.city : regeocode.province;
            self.currentCity = [self.currentCity stringByReplacingOccurrencesOfString:@"市" withString:@""];
             [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
//        [self findCurrentCityID];
       
    }];

}
#pragma mark - 查找定位城市对应的id
//- (void)findCurrentCityID {
//    for (CityModel *model in self.cityArray) {
//        if ([self.currentCity isEqualToString:model.cityName]) {
//            self.currentCityID = model.cityId;
//            break;
//        }
//    }
//    [self getData];
//}

/**
 *
 *  @return 搜索view
 */
#pragma mark - setTitleAndView
- (void)setTitleAndView {
self.searchResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height, Screen_width, Screen_height-height)];
self.searchResultTableView.backgroundColor = [UIColor whiteColor];

//self.searchResultTableView.alpha = 0.5;
self.searchResultTableView.hidden = YES;
    self.searchResultTableView.dataSource = self;
    self.searchResultTableView.delegate = self;
[self.view addSubview:self.searchResultTableView];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
  
    [self.searchResults removeAllObjects];
    
    NSString *condition = self.searchBar.text;
    
    for (modeObject *model in self.dataArray) {
        NSString *content = model.nameString;
        if ([content containsString:condition]) {
            [self.searchResults addObject:model];
        }
    }
    if ([searchText isEqualToString:@""]) {
        self.searchResultTableView.hidden = YES;
    }else{
        self.searchResultTableView.hidden = NO;
    }
    [self.searchResultTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchResultTableView.hidden = YES;
    self.searchBar.showsCancelButton = NO;
    self.searchBarActive = NO;
    self.searchBar.text = @"";
   [self.searchResultTableView reloadData];
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        self.searchBarActive = NO;
        [self.searchBar resignFirstResponder];
    }
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    self.searchBarActive = YES;
//    self.searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    
//    [self.searchResults removeAllObjects];
    
    if ([searchBar.text isEqualToString:@""]) {
        self.searchResultTableView.hidden = YES;
    }else{
        self.searchResultTableView.hidden = NO;
    }
     [self.searchResultTableView reloadData];
    
    return YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

#pragma mark - 加载数据
- (void)setUpSectionIndexTitleWithStr{
    self.sectionIndexs = [NSMutableArray array];
    for (ClubListModel *model in self.dataArray) {
        char header1 = [GetFirstLetter getFirstWord:[model.club_name characterAtIndex:0]];
        [self.sectionIndexs addObject:[[NSString stringWithFormat:@"%c",header1] uppercaseString]];
    }
    // 去除数组中相同的元素
    self.sectionIndexs = [self.sectionIndexs filterTheSameElement];
    // 数组排序
    self.sectionIndexs = (NSMutableArray *)[self.sectionIndexs sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *string1 = obj1;
        NSString *string2 = obj2;
        return [string1 compare:string2];
    }];
    NSMutableArray *tempArray = [NSMutableArray array];
    NSMutableArray *tempArray2 = [NSMutableArray array];
    NSMutableArray *tempArray3 = [NSMutableArray array];
    NSMutableArray *nameArray = [NSMutableArray array];
    for (ClubListModel *model in self.dataArray) {
        [nameArray addObject:model.club_name];
    }
    // 将排序号的首字母数组取出 分成一个个组模型 和组模型下边的一个个 item
    for (NSString *string in self.sectionIndexs) {
        FollowGroupModel *group = [FollowGroupModel getGroupsWithArray:self.dataArray groupTitle:string];
        if ([Utils PureLetters:group.groupTitle]) {
            // 判断是纯字母
            [tempArray addObject:group];
        }else{
            //其他
            [tempArray2 addObject:group];
        }
    }
    for (FollowGroupModel *group in tempArray2) {
        if ([group.groupTitle isEqualToString:@"#"]) {
            [tempArray3 addObject:group];
        }
    }
    if (!(tempArray3.count>0)) {
        FollowGroupModel *group = [[FollowGroupModel alloc]init];
        group.groupTitle = @"#";
        group.follows = [[NSMutableArray alloc]init];
        [tempArray3 addObject:group];
    }
    for (FollowGroupModel *group in tempArray2) {
        
        if(![group.groupTitle isEqualToString:@"#"]){
            FollowGroupModel *group1 = tempArray3[0];
            for (ClubListModel *mode in group.follows) {
                [group1.follows addObject:mode];
            }
        }
    }
    if (tempArray3.count>0) {
        [tempArray addObject:tempArray3[0]];
    }
    self.array =[[NSMutableArray alloc]init];
    self.array = tempArray;
    NSMutableArray *tempArraySectionIndexs = [NSMutableArray array];
    NSMutableArray *tempArraySectionIndexs2 = [NSMutableArray array];
    for (NSString * str in self.sectionIndexs) {
        if ([Utils PureLetters:str]) {
            [tempArraySectionIndexs2 addObject:str];
            
        }else{
            [tempArraySectionIndexs addObject:str];
        }
    }
    BOOL isLastTitle =NO;
    for (NSString *str in tempArraySectionIndexs) {
        if ([str isEqualToString:@"#"]) {
            isLastTitle = YES;
            [tempArraySectionIndexs2 addObject:str];
        }
    }
    if (!isLastTitle && tempArraySectionIndexs.count>0) {
        [tempArraySectionIndexs2 addObject:[NSString stringWithFormat:@"#"]];
    }
    self.sectionIndexs = [[NSMutableArray alloc]init];
    self.sectionIndexs = tempArraySectionIndexs2;
    [self.tableView reloadData];
    self.tableViewSection.frame = CGRectMake(Screen_width-30, (Screen_height-_sectionIndexs.count*15-64-44)*2/3, 30, _sectionIndexs.count*25);
    [self.tableViewSection reloadData];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//      NSLog(@"===%lu",(unsigned long)self.dataArray.count);
    if (tableView == _tableView) {
        return self.array.count+1;
    }else{
        return 1;
    }
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        if (section == 0) {
            if (self.currentCity.length == 0) {
                return 2;
            } else {
                if (self.currentCityClub.count == 0) {
                    return 2;
                }
                return self.currentCityClub.count;
            }
        } else {
            FollowGroupModel *group = self.array[section-1];
            return group.follows.count;
        }
    } else if (tableView == _searchResultTableView){
        return _searchResults.count;
    } else {
        return _sectionIndexs.count;
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
    static NSString *CellIdentifier0 = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier0];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: CellIdentifier0];
        cell.clipsToBounds = YES;
        //选中cell背景色无色
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell的样式1:右侧添加箭头
        //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //        cell.backgroundColor=BackgroundColor;
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        [cell setHighlighted:YES animated:YES];
        [cell awakeFromNib];
    }
        if (indexPath.section == 0) {
            if (self.currentCity.length == 0) {
                cell.textLabel.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
                cell.textLabel.font = [UIFont systemFontOfSize:16];
              
                if (!self.hasGetData) {
                    cell.textLabel.text = self.currentCity.length>0 ? self.currentCity:@"未获取到周边定位，点击重新定位";
                 
                } else {
                    cell.textLabel.text = self.currentCity.length>0 ? self.currentCity:@"定位失败....";
                }
             
                if (indexPath.row == 1) {
                    cell.backgroundColor =[UIColor colorWithHexString:@"#f8f8f8"];
                    cell.textLabel.numberOfLines = 0;
                    cell.textLabel.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
                    cell.textLabel.font = [UIFont systemFontOfSize:13];
                    cell.textLabel.text = @"未获取到周边定位？请重新定位或使用顶部搜索功能，直接输入定位名或住址即可，支持任意两位及以上词组搜索。";
                }
                
                
//                cell.lineView.frame = CGRectMake(0, 45 - 1, Screen_width, 1);
            } else {
                
                if (self.currentCityClub.count == 0) {
                    cell.textLabel.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
                    cell.textLabel.font = [UIFont systemFontOfSize:14];
                    cell.textLabel.frame = CGRectMake(0, 45 - 1, Screen_width, 1);
                    cell.textLabel.text = self.currentCity;
                    if (indexPath.row == self.currentCityClub.count+1) {
                        cell.backgroundColor =[UIColor colorWithHexString:@"#f8f8f8"];
                        cell.textLabel.numberOfLines = 0;
                        cell.textLabel.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        cell.textLabel.text = @"未获取到周边定位？请重新定位或使用顶部搜索功能，直接输入定位名或住址即可，支持任意两位及以上词组搜索。";
                    }
                } else {
                    cell.textLabel.textColor = [UIColor blackColor];
                    cell.textLabel.font = [UIFont systemFontOfSize:16];
                    ClubListModel *followM = self.currentCityClub[indexPath.row];
                    cell.textLabel.text = followM.club_name;
                    if ((indexPath.row == self.currentCityClub.count-1)) {
//                        cell.lineView.frame = CGRectMake(0, 45 - 1, Screen_width, 1);
                    } else {
//                        cell.lineView.frame = CGRectMake(15, 45 - 1, Screen_width, 1);
                    }
                    if (indexPath.row == self.currentCityClub.count+1) {
                        cell.backgroundColor =[UIColor colorWithHexString:@"#f8f8f8"];
                        cell.textLabel.numberOfLines = 0;
                        cell.textLabel.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                        cell.textLabel.text = @"您所在定位不在其中？推荐使用顶部搜索功能，直接输入定位名或住址即可，支持任意两位及以上词组搜索。";
                    }
                }
            }
//            cell.lineTopView.hidden = YES;
            return cell;
        }else{
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#999999"];;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    FollowGroupModel *group = self.array[indexPath.section-1];
    ClubListModel *followM = group.follows[indexPath.row];
    cell.textLabel.text = followM.club_name;
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#99999"];
    
//    cell.reust_id = followM.nick_id;
        }
    return cell;
    }
    else if (tableView == _searchResultTableView){
        static NSString *CellIdentifiersearchResult = @"UITableViewCellsearchResult";
        UITableViewCell *cellsearchResult = [tableView dequeueReusableCellWithIdentifier:CellIdentifiersearchResult];
        if (cellsearchResult == nil) {
            cellsearchResult = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: CellIdentifiersearchResult];
            cellsearchResult.clipsToBounds = YES;
            //选中cell背景色无色
            //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //cell的样式1:右侧添加箭头
            //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //        cell.backgroundColor=BackgroundColor;
            cellsearchResult.selectionStyle=UITableViewCellSelectionStyleGray;
            [cellsearchResult setHighlighted:YES animated:YES];
            [cellsearchResult awakeFromNib];
        }
        
//        cellsearchResult.backgroundColor = [UIColor blackColor];
//        cellsearchResult.alpha = 0.5;
        cellsearchResult.textLabel.textColor = [UIColor colorWithHexString:@"#999999"];;
        cellsearchResult.textLabel.font = [UIFont systemFontOfSize:16];
        modeObject *followM = _searchResults[indexPath.row];
        cellsearchResult.textLabel.text = followM.nameString;
        cellsearchResult.textLabel.textColor = [UIColor redColor];
        cellsearchResult.textLabel.textColor = [UIColor colorWithHexString:@"#99999"];
        return cellsearchResult;
        //    cell.reust_id
    }
    else{
        static NSString *CellIdentifierIndexs = @"UITableViewCellIndexs";
        UITableViewCell *cellIndexs = [tableView dequeueReusableCellWithIdentifier:CellIdentifierIndexs];
        if (cellIndexs == nil) {
            cellIndexs = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: CellIdentifierIndexs];
            cellIndexs.clipsToBounds = YES;
            //去掉分割线
            self.tableViewSection.separatorStyle = UITableViewCellSelectionStyleNone;
            //选中cell背景色无色
                    cellIndexs.selectionStyle = UITableViewCellSelectionStyleNone;
            //cell的样式1:右侧添加箭头
            //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //        cell.backgroundColor=BackgroundColor;
            cellIndexs.selectionStyle=UITableViewCellSelectionStyleGray;
            [cellIndexs setHighlighted:YES animated:YES];
            [cellIndexs awakeFromNib];
        }
        cellIndexs.textLabel.text = _sectionIndexs[indexPath.row];
        cellIndexs.textLabel.font = [UIFont systemFontOfSize:12];
        cellIndexs.textLabel.textColor = [UIColor colorWithHexString:@"#03abff"];
        
        cellIndexs.backgroundColor = [UIColor clearColor];
        return cellIndexs;

    }
}
/**
 *   右侧的索引标题数组
 *
 *   @param tableView 标示图
 *
 *   @return 数组
 */

//- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView{
//    return self.searchController.active?nil:self.sectionIndexs;
//}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        if (indexPath.section == 0&&indexPath.row == self.currentCityClub.count+1) {
            return 64;
        }
         return 44;
    }
    else if (tableView == _searchResultTableView){
          return 44;
    }
    else{
        return 20;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _tableView) {
    return 36;
    }else{
        return 0;
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
   
    // 背景图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 36)];
    bgView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    // 显示分区的 label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, Screen_width, 30)];
        if (section == 0) {
            label.text = @"您可能在以下 定位";
             bgView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor =[UIColor colorWithHexString:@"#6f6f6f"];
        } else {
            FollowGroupModel *group = self.array[section-1];
            label.text = group.groupTitle;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor =[UIColor colorWithHexString:@"#999999"];
        }
   
    [bgView addSubview:label];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    return bgView;
    }else{
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
//        SJGProviderCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        [cell call:nil];
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSIndexPath
        *scrollIndexPath;
        //     UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        int a = 0;
      UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"%@",cell.textLabel.text);
        for (int i = 0;i<self.sectionIndexs.count;i++) {
            if ([[[NSString stringWithFormat:@"%@",cell.textLabel.text] uppercaseString] isEqualToString:_sectionIndexs[i]]) {
                if (a == 0) {
               scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:i+1];
                    a++;
                }
                
            }
        }
        // 让table滚动到对应的indexPath位置
        [[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void)tableViewInit{
    [self.view addSubview:self.tableView];
    
    
}

#pragma mark - 懒加载一些内容
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (NSMutableArray *)searchList{
    if (!_searchList) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height, Screen_width, Screen_height-height)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (UITableView *)tableViewSection{
    
    if (!_tableViewSection) {
//        _tableViewSection = [[UITableView alloc] initWithFrame:CGRectMake(Screen_width-30, (Screen_height-_sectionIndexs.count*15-64-44)*2/3, 30, _sectionIndexs.count*25)];
         _tableViewSection = [[UITableView alloc] initWithFrame:CGRectMake(Screen_width-30, (Screen_height-_sectionIndexs.count*15-64-44)*2/3, 30, _sectionIndexs.count*25)];
        _tableViewSection.delegate = self;
        _tableViewSection.dataSource = self;
    }
    return _tableViewSection;
}
-(UISearchBar * )searchBar{
    if(!_searchBar){
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, height-30 ,Screen_width, 30)];
        self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        self.searchBar.placeholder = @"花园";
        self.searchBar.delegate = self;
        self.searchBar.barTintColor = RGB(249,249,249);
        [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"cm-searchbox"] forState:UIControlStateNormal];
//        [self.searchBar setShowsCancelButton:YES];
        [self.searchBar setPositionAdjustment:UIOffsetMake(0, 0) forSearchBarIcon:UISearchBarIconSearch];
       
    }
    return _searchBar;
}
- (NSMutableArray *)searchResults{
    if (!_searchResults) {
        _searchResults = [NSMutableArray array];
    }
    return _searchResults;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
