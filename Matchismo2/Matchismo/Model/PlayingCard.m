//
//  PlayingCard.m
//  Matchismo
//
//  Created by Iris Burmistrov on 19/07/2022.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSString*) contents
{
  NSArray * rankStrings = [PlayingCard rankStrings];
  return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (int) match: (NSArray*) otherCards
{
  int score = 0;
  if ([otherCards count] == 1){
    PlayingCard* otherCard = [otherCards firstObject];
    if (otherCard.rank == self.rank){
      score = 4;
    } else if ([otherCard.suit isEqualToString:self.suit]){
      score = 1;
    }
  }
  return score;
}

@synthesize suit = _suit;
 + (NSArray * ) validSuits
{
  return @[@"❤️", @"♦️", @"♠️", @"♣️"];
}

+ (NSArray * ) rankStrings
{
  return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger) maxRank { return [[self rankStrings] count] -1; }


- (void) setSuit:(NSString *)suit
{
  if ([[PlayingCard validSuits] containsObject:suit]) {
    _suit = suit;
  }
}

- (NSString*) suit
{
  return _suit ? _suit : @"?";
}

- (void)setRank:(NSInteger)rank
{
  if ( rank <= [PlayingCard maxRank])
  {
    _rank = rank;
  }
}

@end
