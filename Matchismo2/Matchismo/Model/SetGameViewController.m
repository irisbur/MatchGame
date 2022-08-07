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

-(NSUInteger) minNumOfCards{
  return 12;
}

@synthesize deck = _deck;

- (Deck *)deck
{
    if (!_deck) _deck = [[SetCardDeck alloc] init];
    return _deck;
}

- (Deck*) createDeck
{
  return [[SetCardDeck alloc] init];
}

- (void) addCardsInGrid
{
  Grid* grid = [self createGrid];
  NSUInteger rows = [grid rowCount];
  NSUInteger cols = [grid columnCount];
  for (NSUInteger i = 0 ; i < rows; i++) {
    for (NSUInteger j = 0 ; j < cols; j++ ){
      CGRect frame = [grid frameOfCellAtRow:i inColumn:j];
      SetCardView* cardView = [[SetCardView alloc] initWithFrame:frame];
      [self drawRandomPlayingCard:cardView];
      [self.cardsView addSubview:cardView];
    }
  }
}

- (IBAction)touchCardButton:(UIButton *)sender {
//  int chosenButtonIndex = (int) [self.cardViews indexOfObject:sender];
//  [self.game chooseCardAtIndex:chosenButtonIndex :SET_MODE];
  [self updateUI];
}


-(void) updateUI
{
//  for (UIButton* cardButton in self.cardViews){
//    int cardButtonIndex = (int) [self.cardViews indexOfObject:cardButton];
//    Card* card = [self.game cardAtIndex:cardButtonIndex];
//    if (card.isChosen){
//      [cardButton layer].borderColor = UIColor.grayColor.CGColor;
//      [cardButton layer].borderWidth = 1.0;
//    }
//    else{
//      [cardButton layer].borderWidth = 0.0;
//    }
//    if ([card isKindOfClass:[SetPlayingCard class]]) {
//      SetPlayingCard *setCard = (SetPlayingCard *)card;
//      [cardButton setAttributedTitle:[self createCardString:setCard] forState:UIControlStateNormal];
//    }
//    [cardButton setBackgroundImage:[self backgroundForCard:card] forState:UIControlStateNormal];
//    cardButton.enabled = !card.isMatched;
//    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
//  }
}

- (void)drawRandomPlayingCard : (SetCardView*) setCardView
{
    Card *card = [self.deck drawRandomCard];
    if ([card isKindOfClass:[SetPlayingCard class]]) {
      SetPlayingCard *setCard = (SetPlayingCard *)card;
      // todo - set card to someone in view
      setCardView.rank = setCard.rank;
      setCardView.suit = setCard.suit;
      setCardView.color = setCard.color;
      setCardView.shading = setCard.shading;
    }
}


- (NSString*) titleForCard: (Card*) card
{
  return card.contents;
}

- (UIImage*) backgroundForCard: (Card*) card
{
  return [UIImage imageNamed: @"cardfront"];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  [self createDeck];
  [self addCardsInGrid];
  for (UIView* cardView in [self.cardsView subviews]) {
    if ([cardView isKindOfClass:[SetCardView class]]){
      [cardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:cardView action:@selector(pinch:)]];
    }
  }
  [self updateUI];
}

@end
