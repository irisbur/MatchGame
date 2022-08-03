//
//  MatchGameViewController.m
//  Matchismo
//
//  Created by Iris Burmistrov on 26/07/2022.
//

#import "MatchGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@implementation MatchGameViewController

// abstract
- (IBAction)touchCardButton:(UIButton *)sender {
  int chosenButtonIndex = (int) [self.cardButtons indexOfObject:sender];
  [self.game chooseCardAtIndex:chosenButtonIndex :MATCH_MODE];
  [self updateUI];
}

-(void) updateUI {
  for (UIButton* cardButton in self.cardButtons) {
    int cardButtonIndex = (int) [self.cardButtons indexOfObject:cardButton];
    Card* card = [self.game cardAtIndex:cardButtonIndex];
    [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self backgroundForCard:card] forState:UIControlStateNormal];
    cardButton.enabled = !card.isMatched;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
  }
}

- (Deck *)createDeck {
  return [[PlayingCardDeck alloc] init];
}

- (NSString *)titleForCard:(Card *)card {
  return card.isChosen ? card.contents: @"";
}

- (UIImage*) backgroundForCard: (Card*) card {
  return [UIImage imageNamed: card.isChosen ? @"cardfront" : @"cardback"];
}

@end

