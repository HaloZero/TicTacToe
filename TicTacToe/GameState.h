//
//  GameState.h
//  TicTacToe
//
//  Created by Rohan on 7/23/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameBoard.h"

typedef NS_ENUM(NSInteger, Player) {
    PlayerX,
    PlayerO
};

@interface GameState : NSObject

@property (nonatomic, strong, readonly) GameBoard *board;
@property (nonatomic, assign, readonly) BOOL gameEnded;

- (BOOL)validMoveFor:(Player)player atRow:(NSInteger)row column:(NSInteger)column;
- (void)player:(Player)player playsAtRow:(NSInteger)row column:(NSInteger)column;

@end
