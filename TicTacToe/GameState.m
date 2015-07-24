//
//  GameState.m
//  TicTacToe
//
//  Created by Rohan on 7/23/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "GameState.h"
#import "GameBoard.h"



@interface GameState()

@property (nonatomic, strong) GameBoard *board;
@property (nonatomic, assign) Player currentPlayer;
@property (nonatomic, assign) BOOL gameEnded;

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
    if (occupant == Empty && self.currentPlayer == player) {
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
}

@end
