//
//  SetPlayingCard.m
//  Matchismo
//
//  Created by Iris Burmistrov on 25/07/2022.
//

#import "SetPlayingCard.h"

@implementation SetPlayingCard

@synthesize suit = _suit;
@synthesize color = _color;
@synthesize shading = _shading;


- (NSString*) suit
{
  return _suit ? _suit : @"?";
}

- (void) setSuit:(NSString *)suit
{
  if ([[SetPlayingCard validSuits] containsObject:suit]) {
    _suit = suit;
  }
}

- (NSString*) color
{
  return _color ? _color : @"?";
}

- (void) setColor:(NSString *) color
{
  if ([[SetPlayingCard validColors] containsObject:color]) {
    _color = color;
  }
}


- (NSString*) shading
{
  return _shading ? _shading : @"?";
}

- (void) setShading:(NSString *)shading
{
  if ([[SetPlayingCard validShading] containsObject:shading]) {
    _shading = shading;
  }
}

+ (NSArray *) validSuits
{
  return @[@"●", @"■", @"▲"];
}

+ (NSArray *) validColors;
{
  return @[@"red",@"green", @"purple"];
}

+ (NSArray *) validShading
{
  return @[@"solid", @"striped" ,@"open"];
}

- (NSString*) contents
{
  return nil;
}


+ (BOOL) singleAttributeMatch : (NSString*) attributeFirstCard
                     secondAtt:(NSString*) attributeSecondCard
                      thirdAtt:(NSString*) attributeThirdCard
{
  return ([attributeFirstCard isEqualToString:attributeSecondCard] &&
          [attributeSecondCard isEqualToString:attributeThirdCard] &&
          [attributeThirdCard isEqualToString:attributeFirstCard]) ||
            (![attributeFirstCard isEqualToString:attributeSecondCard] &&
             ![attributeSecondCard isEqualToString:attributeThirdCard] &&
             ![attributeThirdCard isEqualToString:attributeFirstCard]);
}

+ (BOOL) doesAttributesMatch :(SetPlayingCard*) card1
                  secondCard:(SetPlayingCard*) card2
               thirdCard:(SetPlayingCard*) card3
{
  NSString* rank1 = [NSString stringWithFormat:@"%ld", card1.rank];
  NSString* rank2 = [NSString stringWithFormat:@"%ld", card2.rank];
  NSString* rank3 = [NSString stringWithFormat:@"%ld", card3.rank];

  return [SetPlayingCard singleAttributeMatch:card1.color secondAtt:card2.color thirdAtt:card3.color] &&
  [SetPlayingCard singleAttributeMatch:card1.suit secondAtt:card2.suit thirdAtt:card3.suit] &&
  [SetPlayingCard singleAttributeMatch:card1.shading secondAtt:card2.shading thirdAtt:card3.shading] &&
  [SetPlayingCard singleAttributeMatch: rank1 secondAtt: rank2 thirdAtt: rank3];
}


- (int) match: (NSArray*) otherCards
{
  int score = 0;
  if ([otherCards count] == 2){
    NSLog(@"Ani kan");
    SetPlayingCard* card2 = [otherCards firstObject];
    SetPlayingCard* card3 = [otherCards objectAtIndex:1];
    BOOL didMatch = [SetPlayingCard doesAttributesMatch:self secondCard:card2 thirdCard:card3];
    score = didMatch ? 1 : 0;
  }
  NSLog(@"Im here");
  return score;
}

@end
