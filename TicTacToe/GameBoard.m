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
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Board is %@", self.rows];
}

- (NSArray *)iterations {
    NSMutableArray *iterations = [NSMutableArray array];
    // check all horizontal
    for (int row = 0; row < self.size; row++) {
        NSMutableArray *iteration = [NSMutableArray array];
        for (int column = 0; column < self.size; column++) {
            [iteration addObject:[[GameBoardPosition alloc] initWithRow:row andColumn:column]];
        }

        [iterations addObject:[iteration copy]];
    }

    // check all verical lines
    for (int column = 0; column < self.size; column++) {
        NSMutableArray *iteration = [NSMutableArray array];
        for (int row = 0; row < self.size; row++) {
            [iteration addObject:[[GameBoardPosition alloc] initWithRow:row andColumn:column]];
        }

        [iterations addObject:[iteration copy]];
    }

    // diagonal
    NSMutableArray *iteration = [NSMutableArray array];
    for (int row = 0; row < self.size; row++) {
        [iteration addObject:[[GameBoardPosition alloc] initWithRow:row andColumn:row]];
    }
    [iterations addObject:[iteration copy]];

    iteration = [NSMutableArray array];
    for (int row = 0; row < self.size; row++) {
        NSInteger column = self.size-row-1;
        [iteration addObject:[[GameBoardPosition alloc] initWithRow:row andColumn:column]];
    }
    [iterations addObject:[iteration copy]];

    return [iterations copy];
}

- (NSArray *)availableMoves {
    NSMutableArray *moves = [NSMutableArray array];
    for (int row = 0; row < self.size; row++) {
        for (int column = 0; column < self.size; column++) {
            if ([self occupantAtPositionRow:row col:column] == Empty) {
                [moves addObject:[[GameBoardPosition alloc] initWithRow:row andColumn:column]];
            }
        }
    }
    return [moves copy];
}


@end

@implementation GameBoardPosition

- (id)initWithRow:(NSInteger)row andColumn:(NSInteger)column {
    self = [super init];
    if (self) {
        _row = row;
        _column = column;
    }

    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Row: %ld, Col: %ld", self.row, self.column];
}

@end
