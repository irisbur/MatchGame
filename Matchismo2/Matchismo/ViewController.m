//
//  ViewController.m
//  Matchismo
//
//  Created by Iris Burmistrov on 18/07/2022.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"


@interface ViewController ()

@property (nonatomic, readwrite) NSUInteger cardsToRender;
@end

@implementation ViewController

- (NSMutableArray*) cards {
  if (!_cards) _cards = [[NSMutableArray alloc] init];
  return _cards;
}

- (CardMatchingGame*) game{
  NSUInteger cardsToRender = self.grid.rowCount * self.grid.columnCount ;
  if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount: cardsToRender usingDeck:[self createDeck]];
  return _game;
}

- (Grid*) createGrid {
  Grid* grid = [[Grid alloc] init];
  grid.size = self.cardsView.frame.size;
  grid.cellAspectRatio = self.cardsView.frame.size.width / self.cardsView.frame.size.height;
  grid.minimumNumberOfCells = self.minNumOfCards;
  return grid;
}


- (IBAction)touchResetButton {
  [self.game resetGame:[[self.cardsView subviews] count] usingDeck:[self createDeck]];
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
  [self updateUI];
}

-(void) updateUI
{
}

// abstract
- (NSString*) titleForCard: (Card*) card
{
  return @"";
}

// abstract
- (UIImage*) backgroundForCard: (Card*) card
{
  return [[UIImage alloc] init];
}

// abstract
- (Deck*) createDeck
{
  return [[Deck alloc] init];
}


@end

