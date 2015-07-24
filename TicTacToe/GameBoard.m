//
//  GameBoard.m
//  TicTacToe
//
//  Created by Rohan on 7/23/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "GameBoard.h"


@interface GameBoard()

@property (nonatomic, strong) NSArray *rows;

@end

@implementation GameBoard

- (id)initWithSize:(NSInteger)size {
    self = [super init];
    if (self) {
        _size = size;
        NSMutableArray *rows = [NSMutableArray arrayWithCapacity:size];
        for (int i = 0; i < 3; i++)  {
            [rows addObject:[NSMutableArray arrayWithObjects:@(Empty), @(Empty), @(Empty), nil]];
        }
        _rows = [rows copy];
    }
    return self;
}

- (BoardOccupant)occupantAtPositionRow:(NSInteger)row col:(NSInteger)column {
    return [self.rows[row][column] integerValue];
}

- (void)occupyPositionRow:(NSInteger)row column:(NSInteger)column withOccupant:(BoardOccupant)occupant {
    self.rows[row][column] = @(occupant);
    NSLog(@"Board is now %@", self.rows);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Board is %@", self.rows];
}

@end
