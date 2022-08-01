//
//  Turn.m
//  Matchismo
//
//  Created by Iris Burmistrov on 31/07/2022.
//

#import "Turn.h"

@implementation Turn

- (instancetype)initWithChosenCards:(NSArray *)chosenCards
                         matchScore:(NSInteger)matchScore {
  if (self = [super init]) {
    _chosenCards = [chosenCards copy];
    _matchScore = matchScore;
  }
  return self;
}

const static int MISMATCH_PENALTY = 2;

- (NSString*) createEndOfTurnDescription
{
  if (self.matchScore > 0)
  {
    return [NSString stringWithFormat: @"is a match for %ld points", self.matchScore];
  }
  else
  {
    return [NSString stringWithFormat:@"don't match! %d point penalty!", MISMATCH_PENALTY];
  }
}

@end
