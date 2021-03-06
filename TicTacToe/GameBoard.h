//
//  GameBoard.h
//  TicTacToe
//
//  Created by Rohan on 7/23/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import <Foundation/Foundation.h>

// This could be named better, :(
typedef NS_ENUM(NSInteger, BoardOccupant) { Empty, OccupiedByPlayerX, OccupiedByPlayerO };

@interface GameBoard : NSObject

@property (nonatomic, assign, readonly) NSInteger size;

- (id)initWithSize:(NSInteger)size;
- (BoardOccupant)occupantAtPositionRow:(NSInteger)row col:(NSInteger)column;
- (void)occupyPositionRow:(NSInteger)row column:(NSInteger)column withOccupant:(BoardOccupant)occupant;

/**
 *  All possible available moves to be played by any player.
 *
 *  @return array of GameMoves
 */
- (NSArray *)availableMoves;

@end

@interface GameMove : NSObject

- (id)initWithRow:(NSInteger)row andColumn:(NSInteger)column;

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger column;

@end
