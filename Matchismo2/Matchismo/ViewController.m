//
//  ViewController.m
//  Matchismo
//
//  Created by Iris Burmistrov on 18/07/2022.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "HistoryViewController.h"




@interface ViewController ()


@end

@implementation ViewController

@synthesize deck = _deck;

- (NSMutableAttributedString *)gameHistoryAttributedText
{
  if (!_gameHistoryAttributedText) _gameHistoryAttributedText = [[NSMutableAttributedString alloc] init];

  return _gameHistoryAttributedText;
}

- (NSMutableAttributedString *) prevTurnDescription
{
  if (!_prevTurnDescription) _prevTurnDescription = [[NSMutableAttributedString alloc] init];
  return _prevTurnDescription;
}


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
  self.gameHistoryAttributedText = [[NSMutableAttributedString alloc] init];
  [self updateUI];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show History"]) {
        if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
          HistoryViewController *hvc = (HistoryViewController *)segue.destinationViewController;
            hvc.gameHistoryAttributedString = self.gameHistoryAttributedText;
        }
    }
}

-(void) updateUI
{
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
- (Deck*) createDeck;
{
  return [[Deck alloc] init];
}


@end

