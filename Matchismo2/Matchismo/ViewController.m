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

//@property (nonatomic, readwrite) NSUInteger cardsToRender;
@end

@implementation ViewController

- (NSMutableArray*) cards {
  if (!_cards) _cards = [[NSMutableArray alloc] init];
  return _cards;
}

- (CardMatchingGame*) game{
  NSUInteger cardsToRender = self.minNumOfCards;
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
  [self.game resetGame: self.minNumOfCards usingDeck:[self createDeck]];
  for (UIView* cardView in self.cards) {
    [cardView removeFromSuperview];
  }
  [self.cards removeAllObjects];
  [self addCardsInGrid];
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
  [self updateUI];
}

-(void) updateUI
{
}

- (void) addCardsInGrid
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

