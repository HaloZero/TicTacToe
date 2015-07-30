//
//  TicTacToeCollectionViewCell.h
//  TicTacToe
//
//  Created by Rohan Dhaimade on 7/30/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameState.h"

@interface TicTacToeCollectionViewCell : UICollectionViewCell

- (void)updateForGame:(GameState *)game atRow:(NSInteger)row andColumn:(NSInteger)column;

@property (nonatomic, strong) UILabel *label;

@end
