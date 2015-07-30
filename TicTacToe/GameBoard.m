//
//  GameBoard.m
//  TicTacToe
//
//  Created by Rohan on 7/23/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "GameBoard.h"

@interface GameBoard ()

@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, assign) NSInteger size;

@end

@implementation GameBoard

- (id)initWithSize:(NSInteger)size {
    self = [super init];
    if (self) {
        _size = size;

        NSMutableArray *rows = [NSMutableArray arrayWithCapacity:size * size];
        for (int i = 0; i < size * size; i++) {
            [rows addObject:@(Empty)];
        }

        _rows = rows;
    }
    return self;
}

- (NSInteger)positionForRow:(NSInteger)row andColumn:(NSInteger)column {
    return row * self.size + column;
}

- (BoardOccupant)occupantAtPositionRow:(NSInteger)row col:(NSInteger)column {
    NSInteger index = [self positionForRow:row andColumn:column];
    return [self.rows[index] integerValue];
}

- (void)occupyPositionRow:(NSInteger)row column:(NSInteger)column withOccupant:(BoardOccupant)occupant {
    NSInteger index = [self positionForRow:row andColumn:column];
    self.rows[index] = @(occupant);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ Board is %@", [super description], self.rows];
}

- (NSArray *)availableMoves {
    NSMutableArray *moves = [NSMutableArray array];

    for (int row = 0; row < self.size; row++) {
        for (int column = 0; column < self.size; column++) {
            if ([self occupantAtPositionRow:row col:column] == Empty) {
                [moves addObject:[[GameMove alloc] initWithRow:row andColumn:column]];
            }
        }
    }

    return [moves copy];
}

- (id)copyWithZone:(NSZone *)zone {
    GameBoard *board = [[GameBoard allocWithZone:zone] initWithSize:self.size];
    board.rows = [[NSMutableArray alloc] initWithArray:self.rows copyItems:NO];
    return board;
}

@end

@implementation GameMove

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
