//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Iris Burmistrov on 20/07/2022.
//


#import "Deck.h"
#import "Card.h"
#import "Turn.h"

typedef NS_ENUM(NSUInteger, GameMode) {
    cardMatchMode = 2,
    setMode= 3
};

#define NUM_CARDS_TO_MATCH 3

@interface CardMatchingGame : NSObject
// designated initializer
- (instancetype) initWithCardCount: (NSUInteger) count usingDeck:(Deck*) deck;
- (void) chooseCardAtIndex:(NSUInteger) index :(NSUInteger) mode;
- (Card*) cardAtIndex:(NSUInteger) index;
- (void) resetGame: (NSUInteger)count usingDeck:(Deck *)deck;
@property (nonatomic, readonly) Turn * currentTurnProperties; 
@property (nonatomic, readonly) NSString* gameDescription;
@property (nonatomic, readonly) NSInteger score;
@end

