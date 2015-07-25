//
//  GameAIBasic.m
//  TicTacToe
//
//  Created by Rohan on 7/23/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "GameAIBasic.h"
#import <BlocksKit.h>

@interface GameAIBasic ()

@property (nonatomic, assign) GameState *game;
@property (nonatomic, assign) Player me;
@property (nonatomic, assign) Player myOpponent;

@property (nonatomic, strong) GameBoardPosition *choice;

@end

@implementation GameAIBasic

- (id)initWithGameState:(GameState *)game playingAs:(Player)player {
    self = [super init];
    if (self) {
        _game = game;
        _me = player;
        _myOpponent = opponent(player);
    }
    return self;
}

- (void)makeAMove {
    NSAssert(self.game.currentPlayer == self.me, @"I should be allowed to make a move");

    GameState *newGame = [self.game copy];
    [self solve:newGame withDepth:0];

    [self.game player:self.me playsAtRow:self.choice.row column:self.choice.column];
}

- (NSNumber *)solve:(GameState *)game withDepth:(NSInteger)depth {
    if (game.gameEnded) {
        return [[NSNumber alloc] initWithInteger:[self scoreForGame:game atDepth:depth]];
    }
    depth = depth + 1;
    NSMutableArray *scores = [NSMutableArray array];
    NSMutableArray *moves = [NSMutableArray array];

    [[game.board availableMoves] bk_each:^(GameBoardPosition *move) {
        GameState *newGame = [game copy];
        [newGame player:newGame.currentPlayer playsAtRow:move.row column:move.column];
        [scores addObject:[self solve:newGame withDepth:depth]];
        [moves addObject:move];
    }];

    if (game.currentPlayer == self.me) {
        NSNumber *maxScore = [scores valueForKeyPath:@"@max.intValue"];
        NSInteger indexOfMaxScore = [scores indexOfObject:maxScore];
        if (depth == 1) {
            self.choice = [moves objectAtIndex:indexOfMaxScore];
        }
        return maxScore;
    } else {
        NSNumber *minScore = [scores valueForKeyPath:@"@min.intValue"];
        NSInteger indexOfMinScore = [scores indexOfObject:minScore];
        return minScore;
    }
}

- (NSInteger)scoreForGame:(GameState *)state atDepth:(NSInteger)depth {
    if (state.winner == self.me) {
        return 10 - depth;
    } else if (state.winner == self.myOpponent) {
        return depth - 10;
    } else {
        return 0;
    }
}

- (void)simpleMakeAMove {
    NSInteger sizeofBoard = self.game.board.size;
    for (int row = 0; row < sizeofBoard; row++) {
        for (int column = 0; column < sizeofBoard; column++) {
            if([self.game validMoveFor:self.me atRow:row column:column]) {
                [self.game player:self.me playsAtRow:row column:column];
                return;
            }
        }
    }
}
@end
