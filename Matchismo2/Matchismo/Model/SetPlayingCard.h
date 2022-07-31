//
//  SetPlayingCard.h
//  Matchismo
//
//  Created by Iris Burmistrov on 25/07/2022.
//

#import "Card.h"


@interface SetPlayingCard : Card

#define MAX_RANK 3

@property (strong, nonatomic) NSString * suit;
@property (strong, nonatomic) NSString * color;
@property (strong, nonatomic) NSString * shading;
@property (nonatomic) NSInteger  rank;

+ (NSArray *) validSuits;
+ (NSArray *) validColors;
+ (NSArray *) validShading;



@end

