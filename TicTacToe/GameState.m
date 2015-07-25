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
@property (nonatomic, assign) Player currentPlayer;

@end

@implementation GameState

- (id)init {
    self = [super init];
    if (self) {
        _board = [[GameBoard alloc] initWithSize:3];
        // TODO: Should I assume we start with X?
        _currentPlayer = PlayerX;
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

    self.currentPlayer = opponent(self.currentPlayer);
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

- (id)copyWithZone:(NSZone *)zone {
    GameState *game = [[GameState allocWithZone:zone] init];
    game.board = [self.board copy];
    game.gameEnded = self.gameEnded;
    game.winner = self.winner;
    game.currentPlayer = self.currentPlayer;
    return game;
}
@end
