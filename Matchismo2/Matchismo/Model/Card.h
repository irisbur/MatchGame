//
//  Card.h
//  Matchismo
//
//  Created by Iris Burmistrov on 18/07/2022.
//

#import <Foundation/Foundation.h>

@interface Card: NSObject

@property (strong, nonatomic) NSString * contents;
@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

-(int) match: (NSArray*) otherCards;
@end

