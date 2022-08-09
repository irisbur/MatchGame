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

@interface SetGameViewController()

//@property (nonatomic) NSUInteger numberOfSubViewsRemoved;

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
  NSUInteger rows = [self.grid rowCount];
  NSUInteger cols = [self.grid columnCount];
  NSUInteger k = 0;
  for (NSUInteger i = 0 ; i < rows; i++) {
    for (NSUInteger j = 0 ; j < cols; j++ ){
      if (k < self.minNumOfCards){
        CGRect frame = [self.grid frameOfCellAtRow:i inColumn:j];
        SetCardView* cardView = [[SetCardView alloc] initWithFrame:frame];
        [self.cardsView addSubview:cardView];
        [self.cards addObject:cardView];
      }
      else {
        break;
      }
      k++;
    }
  }
  NSLog(@"subviews count: %ld", [[self.cardsView subviews] count]);
}


-(void) updateUI
{
  NSMutableArray * removedCards = [[NSMutableArray alloc] init];
  for (SetCardView* cardView in self.cards){
    int cardIndex = (int) [self.cards indexOfObject:cardView];
    SetPlayingCard* card = (SetPlayingCard*) [self.game cardAtIndex:cardIndex];
    cardView.rank = card.rank;
    cardView.suit = card.suit;
    cardView.color = card.color;
    cardView.shading = card.shading;
    cardView.chosen = card.isChosen;
    if (!card) {
      [cardView removeFromSuperview]; // todo - fix bug in UI caused from this
      [removedCards addObject:cardView];
    }
  }
  for (SetCardView* cardView in removedCards) {
    [self.cards removeObject:cardView];
  }
  [removedCards removeAllObjects];
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
  
}

- (IBAction)touchAddCardsButton {

}

- (IBAction)tapOnCard:(UITapGestureRecognizer* )sender { // equive to swipe - todo: implement
  CGPoint tapPoint = [sender locationInView:self.cardsView];
  float cardWidth = self.cardsView.bounds.size.width / self.grid.rowCount;
  float cardHieght = self.cardsView.bounds.size.height / self.grid.columnCount;
  NSUInteger i = tapPoint.x / cardWidth;
  NSUInteger j = tapPoint.y / cardHieght;
  NSUInteger chosenViewIndex = (j * self.grid.rowCount + i);
  if (chosenViewIndex < [self.cards count]){
    [self.game chooseCardAtIndex:chosenViewIndex :SET_MODE];
  }
  [self updateUI];
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
//  self.numberOfSubViewsRemoved = 0;
  [self createDeck];
  self.grid = [self createGrid];
  [self addCardsInGrid];
  for (UIView* cardView in [self.cardsView subviews]) {
    if ([cardView isKindOfClass:[SetCardView class]]) {
      [cardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:cardView action:@selector(pinch:)]];
    }
  }
  [self updateUI];
}

@end
