//
//  Turn.h
//  Matchismo
//
//  Created by Iris Burmistrov on 31/07/2022.
//

#import <Foundation/Foundation.h>



@interface Turn : NSObject

- (instancetype)initWithChosenCards:(NSArray *)chosenCards
                         matchScore:(NSInteger)matchScore;

- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, readonly) NSArray* chosenCards;
@property NSInteger matchScore;

- (NSString*) createEndOfTurnDescription;

@end


