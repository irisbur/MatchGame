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

- (Deck*) createDeck
{
  return [[PlayingCardDeck alloc] init];
}


- (NSString*) titleForCard: (Card*) card;
{
  return card.isChosen ? card.contents: @"";
}


- (UIImage*) backgroundForCard: (Card*) card;
{
  return [UIImage imageNamed: card.isChosen ? @"cardfront" : @"cardback"];
}

@end

