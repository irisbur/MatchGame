//
//  SetCardView.m
//  Matchismo
//
//  Created by Iris Burmistrov on 03/08/2022.
//

#import "SetCardView.h"

@implementation SetCardView 

#pragma mark - Properties

- (void) setSymbol:(NSString *) symbol {
  _symbol = symbol;
  [self setNeedsDisplay];
}

- (void) setShading :(NSString *) shading {
  _shading = shading;
  [self setNeedsDisplay];
}

#pragma mark - Drawing



@end
