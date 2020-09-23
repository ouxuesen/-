//
//  ReadParserTextListViewController.m
//  文件管理
//
//  Created by Ozone on 2020/9/23.
//  Copyright © 2020 ouxuesen. All rights reserved.
//

#import "ReadParserTextListViewController.h"
#import "UIView+AutoLayout.h"
#import "文件管理-Swift.h"
@interface ReadParserTextListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView*tableView;
@property(strong,nonatomic)NSArray*souceList;

@end

@implementation ReadParserTextListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.souceList = [DZMKeyedArchiver getArchiverList];
    self.title = @"小说列表";
    NSLog(@"当前解析数据列表=%@",self.souceList);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(NSArray *)souceList{
    if (!_souceList) {
        _souceList = [NSArray new];
    }
    return _souceList;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellIdentifier"];
    }
    //      let bookName = url.absoluteString.removingPercentEncoding?.lastPathComponent.deletingPathExtension ?? ""
    
    NSString* bookName = self.souceList[indexPath.row];
    cell.textLabel.text = bookName;
    return  cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.souceList.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    //小说
    [DZMMainUnitl quiteReadWithBookId:self.souceList[indexPath.row] viewcontroller:self];
   
}



@end
