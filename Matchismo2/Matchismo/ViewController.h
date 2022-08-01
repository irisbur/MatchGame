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

@interface ViewController : UIViewController

@property  (strong, nonatomic) Deck* deck;
@property  (strong, nonatomic) CardMatchingGame* game;
@property  (strong, nonatomic) NSMutableAttributedString* gameHistoryAttributedText;
@property  (strong, nonatomic) NSMutableAttributedString* prevTurnDescription;
@property (strong, nonatomic)IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameDescriptionLabel;
- (IBAction)touchResetButton;
-(void) updateUI;
@end



