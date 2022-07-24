//
//  ViewController.m
//  Matchismo
//
//  Created by Iris Burmistrov on 18/07/2022.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface ViewController ()

@property  (strong, nonatomic) Deck* deck;
@property  (strong, nonatomic) CardMatchingGame* game;
@property (strong, nonatomic)IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISwitch *modeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *gameDescriptionLabel;
@end

@implementation ViewController
@synthesize deck = _deck;


- (CardMatchingGame*) game{
  if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]                                                                      usingDeck:[self createDeck]];
  return _game;
}


- (Deck*) createDeck
{
  return [[PlayingCardDeck alloc] init];
}


- (IBAction)touchCardButton:(UIButton *)sender {
  int mode = _modeSwitch.isOn ? hardMode : easyMode;
  int chosenButtonIndex = (int) [self.cardButtons indexOfObject:sender];
  [self.game chooseCardAtIndex:chosenButtonIndex :mode];
  [self updateUI];
  self.modeSwitch.enabled = NO;
}


- (IBAction)touchResetButton {
  [self.game resetGame:[self.cardButtons count] usingDeck:[self createDeck]];
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
  [self updateUI];
  self.modeSwitch.enabled = YES;
}

-(void) updateUI
{
  for (UIButton* cardButton in self.cardButtons){
    int cardButtonIndex = (int) [self.cardButtons indexOfObject:cardButton];
    Card* card = [self.game cardAtIndex:cardButtonIndex];
    [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self backgroundForCard:card] forState:UIControlStateNormal];
    cardButton.enabled = !card.isMatched;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
    self.gameDescriptionLabel.text = [NSString stringWithFormat:@"%@", self.game.gameDescription];
  }
}

- (NSString*) titleForCard: (Card*) card
{
  return card.isChosen ? card.contents: @"";
}

- (UIImage*) backgroundForCard: (Card*) card
{
  return [UIImage imageNamed: card.isChosen ? @"cardfront" : @"cardback"];
}

@end
