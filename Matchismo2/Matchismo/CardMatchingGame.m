//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Iris Burmistrov on 20/07/2022.
//

#import "CardMatchingGame.h"



//@end
@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray * cards; // of Card
@property (nonatomic, readwrite) NSMutableArray * chosenCards; // of Card

@end


@implementation CardMatchingGame

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (NSMutableArray*) cards
{
  if (!_cards) _cards = [[NSMutableArray alloc] init];
  return _cards;
}

- (NSMutableArray*) chosenCards
{
  if (!_chosenCards) _chosenCards = [[NSMutableArray alloc] init];
  return _chosenCards;
}


- (instancetype) initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
  self = [super init];
  if (self)
  {
    for (int i = 0; i < count; i++){
      Card *card = [deck drawRandomCard];
      if (card){
        [self.cards addObject:card];
      }
      else {
        self = nil;
        break;
      }
    }
  }
  return self;
}

- (void) resetGame: (NSUInteger)count usingDeck:(Deck *)deck
{
  [self.cards removeAllObjects];
  [self.chosenCards removeAllObjects];
  for (int i = 0; i < count; i++){
    Card *card = [deck drawRandomCard];
    if (card){
      [self.cards addObject:card];
    }
    else {
      break;
    }
    self.score = 0;
  }
}

- (Card*) cardAtIndex:(NSUInteger)index
{
  return (index < [self.cards count]) ? self.cards[index] : nil;
}


- (void)tryMatchMode:(Card *)card {
  for (Card* otherCard in self.cards) {
    if (otherCard.isChosen && !otherCard.isMatched){
      int matchScore = [card match:@[otherCard]];
      if (matchScore){
        self.score += matchScore * MATCH_BONUS;
        otherCard.matched = YES;
        card.matched = YES;
      }
      else{
        self.score -= MISMATCH_PENALTY;
        otherCard.chosen = NO;
      }
      break; // can only choose two cards for now
    }
  }
  self.score -= COST_TO_CHOOSE;
  card.chosen = YES;
}


- (void) tryMatchSetMode: (Card *)card {
  int matchScore = 0;
  [self.chosenCards addObject:card];
  if ([self.chosenCards count] == NUM_CARDS_TO_MATCH)
  {
    [self.chosenCards removeObject:card];
    matchScore = [card match: self.chosenCards] * MATCH_BONUS;
    BOOL didmatch = matchScore > 0 ? YES : NO;
    matchScore = didmatch ? matchScore : (matchScore - MISMATCH_PENALTY);
    [self.chosenCards addObject:card];
    for (Card* otherCard in self.chosenCards)
    {
      otherCard.matched = didmatch;
      otherCard.chosen = didmatch;
    }
    self.score += matchScore;
    [self.chosenCards removeAllObjects];
    if (!didmatch){
      [self.chosenCards addObject:card];
    }
  }
  card.chosen = YES;
  self.score -= COST_TO_CHOOSE;
}


- (void) chooseCardAtIndex:(NSUInteger)index :(NSUInteger) mode
{
  Card* card = [self cardAtIndex:index];
  if (!card.isMatched)
  {
    if (card.isChosen)
    {
      card.chosen = NO;
      [self.chosenCards removeObject:card];
    }
    else if (mode == cardMatchMode){
      [self tryMatchMode:card];
    }
    else if (mode == setMode){
      [self tryMatchSetMode:card];
    }
  }
}

@end
