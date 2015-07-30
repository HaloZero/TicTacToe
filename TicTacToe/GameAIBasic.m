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
@property (nonatomic, strong) GameMove *choice;

@end

@implementation GameAIBasic

- (id)initWithGameState:(GameState *)game playingAs:(Player)player {
    self = [super init];
    if (self) {
        _game = game;
        _me = player;
        _myOpponent = _me == PlayerX ? PlayerO : PlayerX;
    }
    return self;
}

- (GameMove *)pickAMove {
    NSAssert(self.game.currentPlayer == self.me, @"I should be allowed to make a move");

    GameState *newGame = [self.game copy];
    [self solve:newGame withDepth:0];

    return self.choice;
}

- (NSNumber *)solve:(GameState *)game withDepth:(NSInteger)depth {
    if (game.gameEnded) {
        return [[NSNumber alloc] initWithInteger:[self scoreForGame:game atDepth:depth]];
    }
    depth = depth + 1;
    NSMutableArray *scores = [NSMutableArray array];
    NSMutableArray *moves = [NSMutableArray array];

    [[game.board availableMoves] bk_each:^(GameMove *move) {
        GameState *newGame = [game copy];
        [newGame player:newGame.currentPlayer playsAtRow:move.row column:move.column];
        [scores addObject:[self solve:newGame withDepth:depth]];
        [moves addObject:move];
    }];

    if (game.currentPlayer == self.me) {
        NSNumber *maxScore = [scores valueForKeyPath:@"@max.intValue"];
        NSInteger indexOfMaxScore = [scores indexOfObject:maxScore];
        self.choice = [moves objectAtIndex:indexOfMaxScore];
        return maxScore;
    } else {
        NSNumber *minScore = [scores valueForKeyPath:@"@min.intValue"];
        return minScore;
    }
}

- (NSInteger)scoreForGame:(GameState *)state atDepth:(NSInteger)depth {
    GameResult myWinningState = GameResultWinnerO;
    if (self.me == PlayerX) {
        myWinningState = GameResultWinnerX;
    }
    if (state.result == myWinningState) {
        return 10 - depth;
    } else if (state.result == TieGame) {
        return 0;
    } else {
        return depth - 10;
    }
}

- (void)simpleMakeAMove {
    NSInteger sizeofBoard = self.game.board.size;
    for (int row = 0; row < sizeofBoard; row++) {
        for (int column = 0; column < sizeofBoard; column++) {
            if ([self.game validMoveFor:self.me atRow:row column:column]) {
                [self.game player:self.me playsAtRow:row column:column];
                return;
            }
        }
    }
}
@end
