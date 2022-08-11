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

@end

@implementation SetGameViewController 

const static int kNUM_CARDS_TO_ADD = 3;
const static float kINITIAL_ANIMATION_POINT = 500.0;

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
  return  [[SetCardDeck alloc] init];
}

- (void)addCardToGridIn:(SetPlayingCard*) card i:(NSUInteger)i j:(NSUInteger)j animate: (BOOL) doAnimate
                  t:(NSUInteger) t {
  __block CGRect frame = [self.grid frameOfCellAtRow:i inColumn:j];
  CGPoint originalOrigin = frame.origin;
  __block SetCardView* cardView = [[SetCardView alloc] initWithFrame:frame];
  [self initViewWithCard:card cardView:cardView];
  if (doAnimate) {
  frame.origin.x = kINITIAL_ANIMATION_POINT;
  frame.origin.y = kINITIAL_ANIMATION_POINT;
  cardView.frame = frame;
  [UIView animateWithDuration:0.5 delay:0.1 * t options:UIViewAnimationOptionBeginFromCurrentState animations:^{
      frame.origin = originalOrigin;
      cardView.frame = frame;
    } completion:nil];
  }
  [self.cardsView addSubview:cardView];
  [self.cards addObject:cardView];
}

- (void) addCardsInGrid : (BOOL) animate
{
  [self removeSubViewsFromCardsView];
  NSUInteger rows = [self.grid rowCount];
  NSUInteger cols = [self.grid columnCount];
  NSUInteger k = 0;
  for (NSUInteger i = 0 ; i < rows; i++) {
    for (NSUInteger j = 0 ; j < cols; j++ ){
      if (k < self.game.numberOfCardsInGame){
        SetPlayingCard* card = (SetPlayingCard*) [self.game cardAtIndex:i*rows+j];
        [self addCardToGridIn: card i:i j:j animate: animate t:k];
      }
      else {
        break;
      }
      k++;
    }
  }
}


- (void) initViewWithCard:(SetPlayingCard *)card cardView:(SetCardView *)cardView {
  cardView.rank = card.rank;
  cardView.suit = card.suit;
  cardView.color = card.color;
  cardView.shading = card.shading;
  cardView.chosen = card.isChosen;
}

-(void) updateUI
{
  self.grid.minimumNumberOfCells = self.game.numberOfCardsInGame;
  [self addCardsInGrid : NO];
  NSMutableArray * removedCards = [[NSMutableArray alloc] init];
  for (SetCardView* cardView in self.cards){
    int cardIndex = (int) [self.cards indexOfObject:cardView];
    SetPlayingCard* card = (SetPlayingCard*) [self.game cardAtIndex:cardIndex];
    [self  initViewWithCard:card cardView:cardView];
    if (!card) {
      // animate removal from superview..
      [cardView removeFromSuperview];
      [removedCards addObject:cardView];
    }
  }
  for (SetCardView* cardView in removedCards) {
    [self.cards removeObject:cardView];
  }
  [removedCards removeAllObjects];
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
}

- (void)reDarwCardsInGrid {
  [self removeSubViewsFromCardsView];
  self.grid.minimumNumberOfCells = self.game.numberOfCardsInGame + kNUM_CARDS_TO_ADD;
  [self addCardsInGrid : NO];
}

- (void)addCardsToGrid {
  for (int t = 0; t < kNUM_CARDS_TO_ADD ; t++){
    SetPlayingCard* card = (SetPlayingCard*) [self.deck drawRandomCard];
    if (card) {
      NSUInteger cardNumberInGrid = self.game.numberOfCardsInGame;
      NSUInteger i = cardNumberInGrid / self.grid.columnCount;
      NSUInteger j = cardNumberInGrid % self.grid.columnCount;
      [self.game addCardInGame:card];
      [self addCardToGridIn: card i:i j:j animate:YES t:t];
    }
  }
}

- (BOOL) checkNeedToReDrawGrid {
  return (self.game.numberOfCardsInGame + kNUM_CARDS_TO_ADD) >
  (self.grid.rowCount * self.grid.columnCount);
}

- (IBAction)touchAddCardsButton {
  if ([self.deck isDeckEmpty]){
    self.DeckEmptyLabel.text = @"No more cards in the deck";
  } else {
    if ([self checkNeedToReDrawGrid]) {
      [self reDarwCardsInGrid];
    }
    [self addCardsToGrid];
  }
}

- (BOOL) checkNeedToChangeGridSize {
  return self.game.numberOfCardsInGame >= self.grid.rowCount * self.grid.columnCount;
}

- (void) removeSubViewsFromCardsView {
  for (UIView* cardView in self.cards) {
    [cardView removeFromSuperview];
  }
  [self.cards removeAllObjects];
}

- (IBAction)touchResetButton {
  self.deck = [self createDeck];
  [self.game resetGame: self.minNumOfCards usingDeck: self.deck];
  self.grid.minimumNumberOfCells = self.game.numberOfCardsInGame;
  self.DeckEmptyLabel.text = @"";
//  self.in
  [self addCardsInGrid : YES]; // with animation
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
}


- (IBAction)swipe: (UIGestureRecognizer*)sender {
  CGPoint tapPoint = [sender locationInView:self.cardsView];
  NSUInteger i = tapPoint.x / self.grid.cellSize.width;
  NSUInteger j = tapPoint.y / self.grid.cellSize.height;
  NSUInteger chosenViewIndex = (j * self.grid.columnCount + i);
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
  self.deck = [self createDeck];
  [self addCardsInGrid: NO];
  for (UIView* cardView in [self.cardsView subviews]) {
    if ([cardView isKindOfClass:[SetCardView class]]) {
      [cardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:cardView
                                                                            action:@selector(pinch:)]];
    }
  }
//  for (UIGestureRecognizer* gesture in [self.view gestureRecognizers]) {
//    gesture.delegate = self;
//  }
}

@end
