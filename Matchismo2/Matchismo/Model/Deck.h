//
//  Deck.h
//  Matchismo
//
//  Created by Iris Burmistrov on 19/07/2022.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void) addCard: (Card*) card atTop:(BOOL) atTop;
- (void) addCard: (Card*) card;
- (Card*) drawRandomCard;
@end


