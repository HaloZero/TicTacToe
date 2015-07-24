//
//  GameBoard.h
//  TicTacToe
//
//  Created by Rohan on 7/23/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import <Foundation/Foundation.h>

//TODO: Rename?
typedef NS_ENUM(NSInteger, BoardOccupant) {
    Empty,
    OccupiedByX,
    OccupiedByO
};

@interface GameBoard : NSObject

- (id)initWithSize:(NSInteger)size;
- (BoardOccupant)occupantAtPositionRow:(NSInteger)row col:(NSInteger)column;
- (void)occupyPositionRow:(NSInteger)row column:(NSInteger)column withOccupant:(BoardOccupant)occupant;

@property (nonatomic, assign) NSInteger size;

@end
