//
//  TicTacToeCollectionViewCell.m
//  TicTacToe
//
//  Created by Rohan Dhaimade on 7/30/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "TicTacToeCollectionViewCell.h"
#import "GameBoard.h"

@implementation TicTacToeCollectionViewCell

- (void)updateForGame:(GameState *)game atRow:(NSInteger)row andColumn:(NSInteger)column {
    if (!self.label) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.contentView.frame];

        [label setFont:[UIFont fontWithName:@"Chalkboard SE" size:90]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:label];
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        self.label = label;
    }

    BoardOccupant occupant = [game.board occupantAtPositionRow:row col:column];
    if (occupant == OccupiedByPlayerO) {
        self.label.text = @"O";
        self.label.textColor = [UIColor blueColor];
    } else if (occupant == OccupiedByPlayerX) {
        self.label.text = @"X";
        self.label.textColor = [UIColor redColor];
    } else {
        self.label.text = @"";
    }
}

- (void)prepareForReuse {
    self.label.text = @"";
}

@end
