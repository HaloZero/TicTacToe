//
//  GameAIBasic.m
//  TicTacToe
//
//  Created by Rohan on 7/23/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "GameAIBasic.h"

@interface GameAIBasic ()

@property (nonatomic, assign) GameState *game;
@property (nonatomic, assign) Player me;

@end

@implementation GameAIBasic

- (id)initWithGameState:(GameState *)game playingAs:(Player)player {
    self = [super init];
    if (self) {
        _game = game;
        _me = PlayerO;
    }
    return self;
}

- (void)makeAMove {
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