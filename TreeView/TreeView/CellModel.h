//
//  CellModel.h
//  TreeView
//
//  Created by leo on 16/7/12.
//  Copyright © 2016年 huashen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellModel : NSObject

@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)NSInteger level;
@property(nonatomic,strong)NSArray *childArr;
@property(nonatomic,assign)BOOL isselect;
@property(nonatomic,assign)BOOL isexpand ;

// 改变model的选中状态
-(instancetype)changeSelectedState;

-(instancetype)initWithName:(NSString *)name  level:(NSInteger)level andChildArr:(NSArray *)array ;

+(instancetype)dataWithName:(NSString *)name level:(NSInteger)level andChildArr:(NSArray *)childArr;

-(void)addChild:(id)child;//添加子节点
-(void)removeChild:(id)child;//删除子节点
-(NSArray *)enumChildArrInModel;//查询所有的子节点
-(NSArray *)getListArrInModel;
@end
