//
//  GameAIBasic.h
//  TicTacToe
//
//  Created by Rohan on 7/23/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameState.h"

@interface GameAIBasic : NSObject

- (id)initWithGameState:(GameState *)game playingAs:(Player)player;
- (GameMove *)pickAMove;

@property (nonatomic, assign, readonly) Player me;

@end
