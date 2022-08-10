//
//  Deck.m
//  Matchismo
//
//  Created by Iris Burmistrov on 19/07/2022.
//

#import "Deck.h"

@interface Deck()
@property (strong, nonatomic) NSMutableArray * cards; // of Card

@end

@implementation Deck

- (NSMutableArray*) cards
{
  if (!_cards) _cards = [[NSMutableArray alloc] init];
  return _cards;
}

- (BOOL) isDeckEmpty {
  return [self.cards count] == 0;
}

- (void) addCard: (Card*) card atTop:(BOOL) atTop{
  if (atTop){
    [self.cards insertObject:card atIndex:0];
  }
  else{
    [self.cards addObject:card];
  }
}

- (void) addCard: (Card*) card{
  [self addCard:card atTop:NO];
}

- (Card*) drawRandomCard{
  Card* randomCard = nil;
  NSLog(@"cards in deck count: %ld", [self.cards count]);
  if ([self.cards count]){
    unsigned index = arc4random() % [self.cards count];
    randomCard = self.cards[index];
    [self.cards removeObjectAtIndex:index];
  }
  return randomCard;
}
@end
