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

    // Do any additional setup after loading the view, typically from a nib.
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
    if (occupant == OccupiedByO) {
        label.text = @"O";
    } else if (occupant == OccupiedByX) {
        NSLog(@"occupant is row %@ col %@", @(row), @(column));
        label.text = @"X";
    } else {
        label.text = @"";
    }

    [label setFont:[UIFont systemFontOfSize:50]];
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
            if (!self.state.gameEnded) {
                [self.botPlayer makeAMove];
            }
            [self.collectionView reloadData];
        } else {
            NSLog(@"Can't play there");
        }
    } else {
        NSLog(@"Game is over");
    }
}


@end
