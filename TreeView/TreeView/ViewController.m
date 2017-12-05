//
//  ViewController.m
//  TreeView
//
//  Created by leo on 16/7/12.
//  Copyright © 2016年 huashen. All rights reserved.
//

#import "ViewController.h"
#import "CellModel.h"
#import "JSONKit.h"

static NSInteger rownum = 10 ;
static NSArray  *expandArr  ;

#define  SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define  SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define  cellid     @"cell"
#define  custemcell @"custemcell"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView ;
}

@property(nonatomic,strong)NSArray *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    expandArr = [NSMutableArray array];
    [self prepareData];
    [self addTableview];
}


-(void)prepareData{
   CellModel *red = [CellModel dataWithName:@"red" level:2 andChildArr:nil];
   CellModel *green = [CellModel dataWithName:@"green" level:2 andChildArr:nil];
    NSArray *appleArr = [NSArray arrayWithObjects:red,green, nil];
    // 水果
    CellModel *apple = [CellModel dataWithName:@"apple" level:1 andChildArr:appleArr];
    CellModel *pear = [CellModel dataWithName:@"pear" level:1 andChildArr:appleArr];
    CellModel *bnana = [CellModel dataWithName:@"bnana" level:1 andChildArr:appleArr];
    CellModel *grape = [CellModel dataWithName:@"grape" level:1 andChildArr:appleArr];
    NSArray *array = [NSArray arrayWithObjects:apple,pear,bnana,grape, nil];
    CellModel *fruits = [CellModel dataWithName:@"fruits" level:0 andChildArr:array];
    CellModel *film = [CellModel dataWithName:@"电影" level:0 andChildArr:nil];
    CellModel *cartoon = [CellModel dataWithName:@"cartoon" level:0 andChildArr:nil];
    
    self.dataArr = [NSArray arrayWithObjects:fruits,film,cartoon,nil];

}

-(void)addTableview{
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    tableview.delegate = self ;
    tableview.dataSource = self ;
    tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine ;
    tableview.separatorColor = [UIColor yellowColor];
    //[tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [tableview registerNib:[UINib nibWithNibName:@"CustemCell" bundle:nil] forCellReuseIdentifier:@"custemcell"];
    [self.view addSubview:tableview];
    _tableView = tableview ;
}

#pragma mark tableviewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  1 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0 ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0 ;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil ;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CustemCell *cell = [tableView dequeueReusableCellWithIdentifier:custemcell];
    CellModel *model = [[CellModel alloc]init];
    model = self.dataArr[indexPath.row] ;
    cell.model = model ;
    cell.indentationLevel = cell.model.level ;
    cell.indentationWidth = 30.0 ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell ;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 // 点击的时候 将子节点添加到tableView中 展示
    // 获取到model
    CellModel *model = self.dataArr[indexPath.row];
    
    // 改变标记的折叠状态
    CellModel *newMod =[model changeSelectedState];
    
    NSMutableArray *dataArr = [self.dataArr mutableCopy];
    [dataArr replaceObjectAtIndex:indexPath.row withObject:newMod];
    self.dataArr = [dataArr copy];
    if (model.childArr.count) {
        // 选中状态为yes 展开视图
        if (model.isselect) {
        [self expandTableWithModel:model andIndxPath:indexPath];
        }else{
        //[self foldTableWithModel:model andIndexPath:indexPath];
        [self foldViewWith:model andINdexpath:indexPath];
        }
      }else{
    
    }

}

// 展开所有子节点
-(void)expandTableWithModel:(CellModel *)model andIndxPath:(NSIndexPath *)indexPath{

        // 获取model中的子节点
        //NSArray *childArr = [model.childArr copy];
       NSArray *childArr = [model getListArrInModel];
        // 将所有子节点 添加到数据源中
        NSMutableArray *dataArr = [self.dataArr mutableCopy];
        // 先确定范围 range
        NSRange range = NSMakeRange(indexPath.row + 1, childArr.count);
        // 创建一个indexset对象
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        // 插入数组中的元素
        [dataArr insertObjects:childArr atIndexes:set];
        self.dataArr = [dataArr copy];
        // 1 开始准备更新
        [_tableView beginUpdates];
        // 2 将想要移除的cell 的indexpath存入数组
        NSMutableArray *indexArr = [NSMutableArray array];
        // 3 执行delete方法
        for (int i = 0; i < childArr.count; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row+i+1 inSection:indexPath.section];
            [indexArr addObject:index];
        }
        
        [UIView animateWithDuration:2 animations:^{
        [_tableView insertRowsAtIndexPaths:indexArr withRowAnimation:UITableViewRowAnimationLeft];
        }];
        [_tableView endUpdates];
}

// 折叠所有子节点
-(void)foldTableWithModel:(CellModel *)model andIndexPath:(NSIndexPath *)indexPath{
    
    // 获取model中的子节点
    NSArray *childArr = [model.childArr copy];
    // 将所有子节点 添加到数据源中
    NSMutableArray *dataArr = [self.dataArr mutableCopy];
    // 先确定范围 range
    NSRange range = NSMakeRange(indexPath.row + 1, childArr.count);
    // 创建一个indexset对象
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
    // 删除子节点
    [dataArr removeObjectsInArray:childArr];
    self.dataArr = [dataArr copy];
    // 1 开始准备更新
    [_tableView beginUpdates];
    // 2 将想要移除的cell 的indexpath存入数组
    NSMutableArray *indexArr = [NSMutableArray array];
    // 3 执行delete方法
    for (int i = 0; i < childArr.count; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row+i+1 inSection:indexPath.section];
        [indexArr addObject:index];
    }
    
    [_tableView deleteRowsAtIndexPaths:indexArr withRowAnimation:UITableViewRowAnimationLeft];
    [_tableView endUpdates];
}

-(void)foldViewWith:(CellModel *)model andINdexpath:(NSIndexPath *)indexPath{
    
    // 获取model中的子节点
   // NSArray *childArr = [model.childArr copy];
    NSArray *childArr = [model getListArrInModel];
    // 将所有子节点 添加到数据源中
    NSMutableArray *dataArr = [self.dataArr mutableCopy];
    // 先确定范围 range
    NSRange range = NSMakeRange(indexPath.row + 1, childArr.count);
    // 创建一个indexset对象
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
    // 删除子节点
    //[dataArr removeObjectsInArray:childArr]; 如果有相同的子数组会导致错误
    [dataArr removeObjectsAtIndexes:set];
    self.dataArr = [dataArr copy];
    // 1 开始准备更新
    [_tableView beginUpdates];
    // 2 将想要移除的cell 的indexpath存入数组
    NSMutableArray *indexArr = [NSMutableArray array];
    // 3 执行delete方法
    for (int i = 0; i < childArr.count; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row+i+1 inSection:indexPath.section];
        [indexArr addObject:index];
    }
    
    [_tableView deleteRowsAtIndexPaths:indexArr withRowAnimation:UITableViewRowAnimationLeft];
    [_tableView endUpdates];
}











@end
