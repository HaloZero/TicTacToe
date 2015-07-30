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
@property (nonatomic, assign) GameResult result;
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
    BoardOccupant occupant = OccupiedByPlayerO;
    if (player == PlayerX) {
        occupant = OccupiedByPlayerX;
    }
    [self.board occupyPositionRow:row column:column withOccupant:occupant];

    GameMove *move = [[GameMove alloc] initWithRow:row andColumn:column];
    [self checkGameOverWithMove:move withPlayer:player];
    self.currentPlayer = opponent(self.currentPlayer);
}

- (void)checkGameOverWithMove:(GameMove *)move withPlayer:(Player)player {
    BoardOccupant occupier = OccupiedByPlayerX;
    if (player == PlayerO) {
        occupier = OccupiedByPlayerO;
    }

    BOOL gameWon = NO;
    for (int row = 0; row < self.board.size; row++) {
        if ([self.board occupantAtPositionRow:row col:move.column] != occupier) {
            break;;
        }
        if (row == self.board.size-1) {
            gameWon = YES;
        }
    }
    for (int col = 0; col < self.board.size; col++) {
        if ([self.board occupantAtPositionRow:move.row col:col] != occupier) {
            break;
        }
        if (col == self.board.size-1) {
            gameWon = YES;
        }
    }

    if (move.row == move.column) {
        for (int row = 0; row < self.board.size; row++) {
            if ([self.board occupantAtPositionRow:row col:row] != occupier) {
                break;
            }
            if (row == self.board.size-1) {
                gameWon = YES;
            }
        }
    }

    for (int row = 0; row < self.board.size; row++) {
        if ([self.board occupantAtPositionRow:self.board.size-1-row col:row] != occupier) {
            break;
        }
        if (row == self.board.size-1) {
            gameWon = YES;
        }
    }

    if (gameWon) {
        self.gameEnded = YES;
        if (player == PlayerX) {
            self.result = GameResultWinnerX;
        } else {
            self.result = GameResultWinnerO;
        }
    }

    if (!self.gameEnded && [self gameTied]) {
        self.gameEnded = YES;
        self.result = TieGame;
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
    game.result = self.result;
    game.currentPlayer = self.currentPlayer;
    return game;
}
@end
