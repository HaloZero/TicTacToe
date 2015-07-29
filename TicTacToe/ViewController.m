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

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) GameState *state;
@property (nonatomic, strong) GameAIBasic *botPlayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.state = [GameState new];
    self.botPlayer = [[GameAIBasic alloc] initWithGameState:self.state playingAs:PlayerO];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.scrollEnabled = NO;

    CGFloat width = floor(self.view.frame.size.width / self.state.board.size);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(width, width);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView.collectionViewLayout = layout;
    CGFloat x = ceil(([UIScreen mainScreen].bounds.size.width - (width * 3)) / 2);
    CGFloat y = self.collectionView.frame.origin.y;
    [self.collectionView setFrame:CGRectMake(x, y, width * self.state.board.size, width * self.state.board.size)];

    [self.createNewGameButton addTarget:self action:@selector(startNewGame) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startNewGame {
    self.state = [GameState new];
    self.botPlayer = [[GameAIBasic alloc] initWithGameState:self.state playingAs:PlayerO];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView Delegate

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.state.board.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.state.board.size;
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

    BoardOccupant occupant = [self.state.board occupantAtPositionRow:row col:column];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger column = indexPath.section;
    if (!self.state.gameEnded) {
        if ([self.state validMoveFor:PlayerX atRow:row column:column]) {
            [self.state player:PlayerX playsAtRow:row column:column];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                __block GameMove *botMove = [self.botPlayer pickAMove];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!self.state.gameEnded) {
                        [self.state player:self.botPlayer.me playsAtRow:botMove.row column:botMove.column];
                    }
                    [self.collectionView reloadData];
                });
            });
            [self.collectionView reloadData];
        } else {
            NSLog(@"Can't play there");
        }
    } else {
        NSLog(@"Game is over");
    }
}


@end
