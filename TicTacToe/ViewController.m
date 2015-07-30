//
//  ViewController.m
//  TicTacToe
//
//  Created by Rohan on 7/23/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "ViewController.h"
#import "GameState.h"
#import "GameAIBasic.h"
#import <SVProgressHUD.h>
#import <UIAlertView+BlocksKit.h>

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) GameState *game;
@property (nonatomic, strong) GameAIBasic *botPlayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.game = [GameState new];
    self.botPlayer = [[GameAIBasic alloc] initWithGameState:self.game playingAs:PlayerO];

    // setup collection view
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.scrollEnabled = NO;

    // setup layout
    CGFloat width = floor(self.view.frame.size.width / self.game.board.size);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(width, width);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView.collectionViewLayout = layout;


    // resize collection view
    CGFloat x = ceil(([UIScreen mainScreen].bounds.size.width - (width * 3)) / 2);
    CGFloat y = self.collectionView.frame.origin.y;
    [self.collectionView setFrame:CGRectMake(x, y, width * self.game.board.size, width * self.game.board.size)];

    [self.createNewGameButton addTarget:self action:@selector(startNewGame) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startNewGame {
    self.game = [GameState new];
    self.botPlayer = [[GameAIBasic alloc] initWithGameState:self.game playingAs:PlayerO];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.game.board.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.game.board.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }

    UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.frame];

    NSInteger row = indexPath.row;
    NSInteger column = indexPath.section;

    BoardOccupant occupant = [self.game.board occupantAtPositionRow:row col:column];
    if (occupant == OccupiedByPlayerO) {
        label.text = @"O";
        label.textColor = [UIColor blueColor];
    } else if (occupant == OccupiedByPlayerX) {
        label.text = @"X";
        label.textColor = [UIColor redColor];
    } else {
        label.text = @"";
    }

    [label setFont:[UIFont fontWithName:@"Chalkboard SE" size:90]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [cell.contentView addSubview:label];
    cell.layer.borderWidth = 1.0f;

    cell.layer.borderColor = [[UIColor blackColor] CGColor];

    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger column = indexPath.section;
    if (!self.game.gameEnded) {
        if (self.game.currentPlayer != PlayerX) {
            NSLog(@"Wait your turn");
            return;
        }

        if ([self.game validMoveFor:PlayerX atRow:row column:column]) {
            [self.game player:PlayerX playsAtRow:row column:column];

            if (!self.game.gameEnded) {
                [SVProgressHUD showImage:[UIImage imageNamed:@"robot-thinking.jpg"] status:@"Bot thinking"];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    __block GameMove *botMove = [self.botPlayer pickAMove];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!self.game.gameEnded) {
                            [self.game player:self.botPlayer.me playsAtRow:botMove.row column:botMove.column];
                            [self checkGameOverWithMove:botMove];
                        }
                        [self.collectionView reloadData];
                        [SVProgressHUD dismiss];
                    });
                });
            } else {
                [self checkGameOverWithMove:[[GameMove alloc] initWithRow:row andColumn:column]];
            }

            [self.collectionView reloadData];
        } else {
            NSLog(@"Can't play there");
        }
    } else {
        NSLog(@"Game is over");
    }
}

- (void)checkGameOverWithMove:(GameMove *)move {
    if (self.game.gameEnded) {
        if (self.game.result == GameResultWinnerX) {
            [UIAlertView bk_showAlertViewWithTitle:@"Game Over" message:@"Player X has Won" cancelButtonTitle:@"Got it" otherButtonTitles:nil handler:nil];
        } else if (self.game.result == GameResultWinnerO) {
            [UIAlertView bk_showAlertViewWithTitle:@"Game Over" message:@"Player O has Won" cancelButtonTitle:@"Got it" otherButtonTitles:nil handler:nil];
        } else {
            [UIAlertView bk_showAlertViewWithTitle:@"Game Over" message:@"Tie Game" cancelButtonTitle:@"Got it" otherButtonTitles:nil handler:nil];
        }
    }
}
@end
