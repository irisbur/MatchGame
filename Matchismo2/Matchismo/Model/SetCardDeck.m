//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Iris Burmistrov on 25/07/2022.
//

#import "SetCardDeck.h"
#import "SetPlayingCard.h"

@implementation SetCardDeck

- (instancetype) init
{
  self = [super init];
  if (self)
  {
    for (NSString* suit in [SetPlayingCard validSuits]) {
      for (NSUInteger rank = 1; rank <= MAX_RANK; rank++) {
        for ( NSString* shading in [SetPlayingCard validShading]) {
          for (NSString* color in [SetPlayingCard validColors]) {
            SetPlayingCard *card = [[SetPlayingCard alloc] init];
            card.rank = rank;
            card.suit = suit;
            card.color = color;
            card.shading= shading;
            [self addCard:card];
          }
        }
      }
    }
  }
  return self;
}

@end
