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


@end

@implementation ViewController

@synthesize deck = _deck;


- (CardMatchingGame*) game{
  if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]  usingDeck:[self createDeck]];
  return _game;
}

// abstract
- (IBAction)touchCardButton:(UIButton *)sender {
  int chosenButtonIndex = (int) [self.cardButtons indexOfObject:sender];
  [self.game chooseCardAtIndex:chosenButtonIndex :MATCH_MODE];
  [self updateUI];
}


- (IBAction)touchResetButton {
  [self.game resetGame:[self.cardButtons count] usingDeck:[self createDeck]];
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
  [self updateUI];
}


-(void) updateUI
{
  for (UIButton* cardButton in self.cardButtons){
    int cardButtonIndex = (int) [self.cardButtons indexOfObject:cardButton];
    Card* card = [self.game cardAtIndex:cardButtonIndex];
    [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self backgroundForCard:card] forState:UIControlStateNormal];
    cardButton.enabled = !card.isMatched;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
    self.gameDescriptionLabel.text = [NSString stringWithFormat:@"%@", self.game.gameDescription];
  }
}

// abstract
- (NSString*) titleForCard: (Card*) card;
{
  return @"";
}

// abstract
- (UIImage*) backgroundForCard: (Card*) card;
{
  return [[UIImage alloc] init];
}

// abstract
- (Deck*) createDeck; // abstract method
{
  return [[Deck alloc] init];
}


@end

