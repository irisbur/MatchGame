//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Iris Burmistrov on 20/07/2022.
//

#import "CardMatchingGame.h"


@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray * cards; // of Card
@property (nonatomic, strong) NSMutableArray * chosenCards; // of Card
@property (nonatomic, readwrite) NSString* gameDescription;

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
  self.gameDescription = @"";
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
  self.gameDescription = @"";
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


- (void)tryMatchEasyMode:(Card *)card {
  for (Card* otherCard in self.cards) {
    if (otherCard.isChosen && !otherCard.isMatched){
      int matchScore = [card match:@[otherCard]];
      if (matchScore){
        self.gameDescription = [NSString stringWithFormat:@"matched %@ %@ for %d points.",
                                card.contents, otherCard.contents, matchScore];
        self.score += matchScore * MATCH_BONUS;
        otherCard.matched = YES;
        card.matched = YES;
      }
      else{
        self.gameDescription = [NSString stringWithFormat:@"%@ %@ don't match! %d point penalty!",
                                card.contents, otherCard.contents, MISMATCH_PENALTY];
        self.score -= MISMATCH_PENALTY;
        otherCard.chosen = NO;
      }
      break; // can only choose two cards for now
    }
  }
  self.score -= COST_TO_CHOOSE;
  card.chosen = YES;
}


+ (int) calculateScore: (NSArray *) chosenCards
{
  int matchScore = 0;
  for (int i = 0; i < [chosenCards count];i++){
    for (int j = i+1; j < [chosenCards count]; j++){
      Card* card = [chosenCards objectAtIndex:i];
      Card* otherCard = [chosenCards objectAtIndex:j];
      matchScore += [card match:@[otherCard]] * MATCH_BONUS;
      if (!matchScore){
        matchScore -= MISMATCH_PENALTY;
      }
    }
  }
  return matchScore;
}

- (void) tryMatchHardMode: (Card *)card {
  if ([self.chosenCards count] < NUM_CARDS_TO_MATCH)
  {
    [self.chosenCards addObject:card];
  }
  int matchScore = 0;
  if ([_chosenCards count] == NUM_CARDS_TO_MATCH)
  {
    matchScore = [CardMatchingGame calculateScore:self.chosenCards];
    BOOL didmatch = matchScore > 0 ? YES : NO;
    NSString* cardContents1 = ((Card*)[self.chosenCards objectAtIndex:0]).contents;
    NSString* cardContents2 = ((Card*)[self.chosenCards objectAtIndex:1]).contents;
    NSString* cardContents3 = ((Card*)[self.chosenCards objectAtIndex:2]).contents;
    if (didmatch){
      self.gameDescription = [NSString stringWithFormat:@"matched %@ %@ %@ for %d points.",
                              cardContents1,cardContents2, cardContents3, matchScore];
    }
    else {
      self.gameDescription = [NSString stringWithFormat:@"%@ %@ %@ don't match! %d point penalty!",
                              cardContents1,cardContents2, cardContents3, MISMATCH_PENALTY];
    }
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
      self.gameDescription = @"";
    }
    else if (mode == easyMode){
      self.gameDescription = [NSString stringWithFormat:@"%@", card.contents];
      [self tryMatchEasyMode:card];
    }
    else if (mode == hardMode){
      self.gameDescription = [NSString stringWithFormat:@"%@", card.contents];
      [self tryMatchHardMode:card];
    }
  }
}

@end
