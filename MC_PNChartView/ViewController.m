//
//  ViewController.m
//  MC_PNChartView
//
//  Created by mc on 2017/11/21.
//  Copyright © 2017年 mc. All rights reserved.
//

#import "ViewController.h"
#import "LineChartView.h"
#import "PieChartView.h"
#import "BarChartView.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define NAV_HEIGHT 64.0


typedef NS_ENUM(NSUInteger, TJChartType) {
    LineChart,
    PieChart,
    BarChart,
    PiePercentChart,
};

@interface ChartDataModel: NSObject

@property (strong, nonatomic) NSNumber *chartType;

@property (copy, nonatomic) NSString *titleString;

@property (copy, nonatomic) NSString *subTitleString;

@property (strong, nonatomic) NSArray *datas;


@end

@implementation ChartDataModel


@end

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray<NSMutableArray<ChartDataModel *> *> *scrollDatasource;

@property (strong, nonatomic) UITableView *tableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupViews];
    [self loadDatasource];

}

- (void) setupViews {
    self.navigationItem.title = @"MC_PNChartDemo";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = (SCREEN_WIDTH-20)/4*3+50;
    self.tableView.sectionHeaderHeight = 0.0;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    [self.view addSubview:self.tableView];
}

- (void) loadDatasource {
    NSDictionary *dict = [[self parseJson:@"0"] objectForKey:@"data"];
    NSDictionary *dict1 = [self parseJson:@"1"];
    NSDictionary *dict2 = [[self parseJson:@"2"] objectForKey:@"data"];
    NSDictionary *dict3 = [[self parseJson:@"3"] objectForKey:@"data"];

    [self.scrollDatasource[0] removeAllObjects];
    ChartDataModel *linemodel = [[ChartDataModel alloc] init];
    linemodel.chartType = @(LineChart);
    linemodel.titleString = @"实收总额";
    linemodel.subTitleString = [dict objectForKey:@"totalMoney"];
    
    linemodel.datas = [dict objectForKey:@"orderData"];
    [self.scrollDatasource.firstObject addObject:linemodel];
    
    ChartDataModel *chart = [[ChartDataModel alloc] init];
    chart.chartType = @(PieChart);
    chart.titleString = @"支付方式统计";
    chart.datas = [dict objectForKey:@"payWayData"];
    [self.scrollDatasource.firstObject addObject:chart];
    
    ChartDataModel *chart1 = [[ChartDataModel alloc] init];
    chart1.chartType = @(PieChart);
    chart1.titleString = @"订单类型统计";
    chart1.datas = [dict objectForKey:@"orderTypeData"];
    [self.scrollDatasource.firstObject addObject:chart1];
    
    
    [self.scrollDatasource[1] removeAllObjects];
    ChartDataModel *model = [[ChartDataModel alloc] init];
    model.chartType = @(PieChart);
    model.titleString = @"订单来源统计";
    model.datas = [dict1 objectForKey:@"data"];
    [self.scrollDatasource[1] addObject:model];
    
    ChartDataModel *model1 = [[ChartDataModel alloc] init];
    model1.chartType = @(PiePercentChart);
    model1.titleString = @"优惠总额";
    model1.subTitleString = [dict2 objectForKey:@"discountMoney"];
    model1.datas = [dict2 objectForKey:@"discountData"];
    
    ChartDataModel *model2 = [ChartDataModel new];
    model2.chartType = @(PieChart);
    model2.titleString = @"退款总额";
    model2.subTitleString = [dict2 objectForKey:@"refundMoney"];
    model2.datas = [dict2 objectForKey:@"refundData"];
    [self.scrollDatasource[1] addObject:model1];
    [self.scrollDatasource[1] addObject:model2];
    
    
    [self.scrollDatasource[2] removeAllObjects];
    ChartDataModel *model3 = [[ChartDataModel alloc] init];
    model3.chartType = @(LineChart);
    model3.titleString = @"充值总额";
    model3.subTitleString = [dict3 objectForKey:@"rechargeMoney"];
    model3.datas = [dict3 objectForKey:@"rechargeData"];
    [self.scrollDatasource[2] addObject:model3];
    
    ChartDataModel *model4 = [ChartDataModel new];
    model4.chartType = @(LineChart);
    model4.titleString = @"余额消耗总额";
    model4.subTitleString = [dict3 objectForKey:@"consumeMoney"];
    model4.datas = [dict3 objectForKey:@"consumeData"];
    [self.scrollDatasource[2] addObject:model4];
    
    ChartDataModel *model5 = [ChartDataModel new];
    model5.chartType = @(LineChart);
    model5.titleString = @"购买卡次总额";
    model5.subTitleString = [dict3 objectForKey:@"scardMoney"];
    model5.datas = [dict3 objectForKey:@"scardData"];
    [self.scrollDatasource[2] addObject:model5];
    
    [self.tableView reloadData];
}

- (NSDictionary *)parseJson:(NSString *)jsonName {
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return dict;
}

#pragma mark - UITableViewDelegate & UITableViewDatasource Methods
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuseInditifer = @"StatisticalChartCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseInditifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseInditifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    for (UIView *vi in cell.contentView.subviews) {
        [vi removeFromSuperview];
    }
    ChartDataModel *model = self.scrollDatasource[indexPath.section][indexPath.row];
    TJChartType chartType = [model.chartType unsignedIntegerValue];
    CGFloat height = (SCREEN_WIDTH-20)/4*3+50;
    if (chartType == LineChart) {
        LineChartView *chartView = [[LineChartView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        [chartView setChartTitle:model.titleString];
        [chartView setChartSubTitle:model.subTitleString];
        [chartView drawLineChartLineView:model.datas];
        [cell.contentView addSubview:chartView];
    }else if(chartType == PieChart) {
        PieChartView *chartView = [[PieChartView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        [chartView setChartTitle:model.titleString];
        chartView.isPercent = false;
        [chartView drawPieChartView:model.datas];
        [cell.contentView addSubview:chartView];
        
    }else if(chartType == PiePercentChart){
        PieChartView *chartView = [[PieChartView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        [chartView setChartTitle:model.titleString];
        chartView.isPercent = true;
        chartView.showPullLine = true;
        chartView.showOnlyValues = false;
        chartView.showNumberLabel = false;
        chartView.showlegendValue = false;
        [chartView drawPieChartView:model.datas];
        [cell.contentView addSubview:chartView];
        
    }else if (chartType == BarChart) {
        BarChartView *chartView = [[BarChartView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, height)];
        [chartView setChartTitle:model.titleString];
        [chartView drawLineChartLineView:model.datas];
        [cell.contentView addSubview:chartView];
    }
    
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.scrollDatasource.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.scrollDatasource[section] count];
}

- (NSMutableArray *)scrollDatasource {
    if (!_scrollDatasource) {
        NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:3];
        NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:3];
        NSMutableArray *array3 = [NSMutableArray arrayWithCapacity:3];
        _scrollDatasource = [NSMutableArray arrayWithCapacity:3];
        [_scrollDatasource addObject:array1];
        [_scrollDatasource addObject:array2];
        [_scrollDatasource addObject:array3];
    }
    return _scrollDatasource;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
