//
//  ViewController.h
//  Matchismo
//
//  Created by Iris Burmistrov on 18/07/2022.
//

#import <UIKit/UIKit.h>

#define MATCH_MODE 2
#define SET_MODE 3

#import "CardMatchingGame.h"
#import "Grid.h"

@interface ViewController : UIViewController\

@property (nonatomic) NSUInteger minNumOfCards;
@property  (strong, nonatomic) Deck* deck;
@property  (strong, nonatomic) Grid* grid;
@property  (strong, nonatomic) CardMatchingGame* game;
@property (weak, nonatomic) IBOutlet UIView *cardsView;
@property (strong, nonatomic) NSMutableArray* cards; // of CardView
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

-(void) updateUI;
- (Grid*) createGrid;
- (void) addCardsInGrid;

@end



