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

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *cardsView;
@property  (strong, nonatomic) Deck* deck;
@property  (strong, nonatomic) CardMatchingGame* game;
@property (nonatomic) NSUInteger minNumOfCards;
//@property (strong, nonatomic) NSArray* cards; // of Cards?
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
//- (IBAction)touchResetButton;
-(void) updateUI;
- (Grid*) createGrid;

@end



