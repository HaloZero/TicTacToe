//
//  GameState.m
//  TicTacToe
//
//  Created by Rohan on 7/23/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "GameState.h"
#import "GameBoard.h"
#import <BlocksKit.h>



@interface GameState()

@property (nonatomic, strong) GameBoard *board;
@property (nonatomic, assign) BOOL gameEnded;
@property (nonatomic, assign) Player winner;

@end

@implementation GameState

- (id)init {
    self = [super init];
    if (self) {
        _board = [[GameBoard alloc] initWithSize:3];
    }
    return self;
}

- (BOOL)validMoveFor:(Player)player atRow:(NSInteger)row column:(NSInteger)column {
    BoardOccupant occupant = [self.board occupantAtPositionRow:row col:column];
    if (occupant == Empty) {
        return YES;
    } else {
        return NO;
    }
}

- (void)player:(Player)player playsAtRow:(NSInteger)row column:(NSInteger)column {
    NSAssert([self validMoveFor:player atRow:row column:column], @"Don't call move player without validation");
    BoardOccupant occupant = OccupiedByO;
    if (player == PlayerX) {
        occupant = OccupiedByX;
    }
    [self.board occupyPositionRow:row column:column withOccupant:occupant];
    [self checkGameOver];
}

- (void)checkGameOver {
    for (NSArray *iteration in [self.board iterations]) {
        GameBoardPosition *position = iteration[0];
        BoardOccupant firstOccupant = [self.board occupantAtPositionRow:position.row col:position.column];
        self.gameEnded = [iteration bk_all:^BOOL(GameBoardPosition *position) {
            return [self.board occupantAtPositionRow:position.row col:position.column] == firstOccupant && firstOccupant != Empty;
        }];
        if (self.gameEnded) {
            if (firstOccupant == OccupiedByX) {
                self.winner = PlayerX;
            } else {
                self.winner = PlayerO;
            }
            break;
        }
    }

    if ([self gameTied]) {
        self.gameEnded = YES;
    }
}

- (BOOL)gameTied {
    NSInteger sizeofBoard = self.board.size;
    for (int row = 0; row < sizeofBoard; row++) {
        for (int column = 0; column < sizeofBoard; column++) {
            if ([self.board occupantAtPositionRow:row col:column] == Empty) {
                return NO;
            }
        }
    }
    return YES;
}

@end