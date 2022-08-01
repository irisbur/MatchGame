//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Iris Burmistrov on 31/07/2022.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@property (weak, nonatomic) IBOutlet UITextView *gameHistory;
@end


@implementation HistoryViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}


- (void)setGameHistoryAttributedString:(NSMutableAttributedString *)gameHistoryAttributedString
{
    _gameHistoryAttributedString = gameHistoryAttributedString;
    if (self.view.window) [self updateUI];
}


- (void)updateUI
{
  _gameHistory.attributedText = self.gameHistoryAttributedString;
}

@end
