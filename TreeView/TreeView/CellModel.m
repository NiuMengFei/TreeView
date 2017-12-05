//
//  CellModel.m
//  TreeView
//
//  Created by leo on 16/7/12.
//  Copyright © 2016年 huashen. All rights reserved.
//

#import "CellModel.h"

static NSMutableArray *expandArr ;

@implementation CellModel{
    NSMutableArray *_listArr ;
}

-(instancetype)initWithName:(NSString *)name  level:(NSInteger)level andChildArr:(NSArray *)array{
    if (self = [super init]) {
        self.name = name ;
        self.childArr = [NSArray arrayWithArray:array] ;
        self.level = level ;
        self.isselect = NO ;
        self.isexpand = NO ;
        _listArr = [NSMutableArray array];
    }
    return self ;
}

+(instancetype)dataWithName:(NSString *)name level:(NSInteger)level andChildArr:(NSArray *)childArr{
    return [[self alloc]initWithName:name level:level andChildArr:childArr];
}

-(void)addChild:(id)child{
    NSMutableArray *childArr = [self.childArr mutableCopy];
    [childArr insertObject:child atIndex:0];
    self.childArr = [childArr copy];
    
}
-(void)removeChild:(id)child{
    NSMutableArray *childArr = [self.childArr mutableCopy];
    [childArr removeObject:child];
    self.childArr = [childArr copy];
}

-(instancetype)changeSelectedState{
    if (self.isselect == NO) {
        self.isselect = YES ;
        self.isexpand = YES ;
    }else{
        self.isselect = NO ;
        self.isexpand = NO ;
    }
    return self ;
}


-(NSArray *)enumChildArrInModelWithArr:(NSMutableArray *)arr{
    if (self.childArr.count) {
        for (CellModel *mod in self.childArr) {
            [arr addObject:mod];
            if (mod.isexpand && mod.childArr.count) {
                [mod enumChildArrInModelWithArr:arr];
            }
        }
    }return arr ;
}

-(NSArray *)getListArrInModel{
    NSMutableArray *expandArr = [NSMutableArray array];
    NSArray *array = [self enumChildArrInModelWithArr:expandArr];
    return array ;
}


@end
