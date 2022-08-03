//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Iris Burmistrov on 25/07/2022.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetPlayingCard.h"
#import "CardMatchingGame.h"

#define SET_MODE 3


@interface SetGameViewController ()

@end

@implementation SetGameViewController

const static NSDictionary* shadeToAlpha = @{@"solid": @1, @"striped" : @0.2 ,@"open":@1};

- (Deck*) createDeck
{
  return [[SetCardDeck alloc] init];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self updateUI];
}

- (IBAction)touchCardButton:(UIButton *)sender {
  int chosenButtonIndex = (int) [self.cardViews indexOfObject:sender];
  [self.game chooseCardAtIndex:chosenButtonIndex :SET_MODE];
  [self updateUI];
}

+ (UIColor* ) stringToUIColor: (SetPlayingCard*) card
{
  NSString* colorString = card.color;
  UIColor* color = nil;
  if ([colorString isEqualToString: @"red"])
  {
    color =[UIColor redColor];
  }
  else if ([colorString isEqualToString: @"green"]){
    color = [UIColor greenColor];
  }
  else if ([colorString isEqualToString:@"purple"]){
    color = [UIColor purpleColor];
  }
  return [color colorWithAlphaComponent: [shadeToAlpha[card.shading] floatValue]];
}


-(void) updateUI
{
  for (UIButton* cardButton in self.cardViews){
    int cardButtonIndex = (int) [self.cardViews indexOfObject:cardButton];
    Card* card = [self.game cardAtIndex:cardButtonIndex];
    if (card.isChosen){
      [cardButton layer].borderColor = UIColor.grayColor.CGColor;
      [cardButton layer].borderWidth = 1.0;
    }
    else{
      [cardButton layer].borderWidth = 0.0;
    }
    [cardButton setAttributedTitle:[self createCardString:card] forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self backgroundForCard:card] forState:UIControlStateNormal];
    cardButton.enabled = !card.isMatched;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
  }
}

- (NSMutableAttributedString*) createCardString : (SetPlayingCard*) card
{
  NSString* initialString = card.suit;
  for (int i = 1; i < card.rank; i++){
    initialString = [initialString stringByAppendingString:card.suit];
  }
  NSMutableDictionary *attributesDictionary = [NSMutableDictionary dictionary];
  UIColor * cardTextColor = [SetGameViewController stringToUIColor:card];
  [attributesDictionary setObject:cardTextColor forKey:NSForegroundColorAttributeName];
  if ([card.shading isEqualToString: @"open" ] ){
    [attributesDictionary setObject: @2 forKey:NSStrokeWidthAttributeName];
  }
  NSMutableAttributedString* CardContent = [[NSMutableAttributedString alloc]
                                            initWithString:initialString
                                            attributes:attributesDictionary];
  return CardContent;
}

- (NSString*) titleForCard: (Card*) card
{
  return card.contents;
}

- (UIImage*) backgroundForCard: (Card*) card
{
  return [UIImage imageNamed: @"cardfront"];
}

@end
