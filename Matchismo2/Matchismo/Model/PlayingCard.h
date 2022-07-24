//
//  PlayingCard.h
//  Matchismo
//
//  Created by Iris Burmistrov on 19/07/2022.
//

#import "Card.h"


@interface PlayingCard : Card

@property (strong, nonatomic) NSString * suit;
@property (nonatomic) NSInteger  rank;
+ (NSArray *) validSuits;
+ (NSUInteger) maxRank;
@end


