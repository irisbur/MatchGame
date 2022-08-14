//
//  ViewController.m
//  Matchismo
//
//  Created by Iris Burmistrov on 18/07/2022.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"



@interface ViewController()

@property (nonatomic) BOOL didCallLayoutSubViews;
@property (nonatomic, strong) UIPanGestureRecognizer* panGesture;


@end

@implementation ViewController

- (NSMutableArray*) cards {
  if (!_cards) _cards = [[NSMutableArray alloc] init];
  return _cards;
}

- (CardMatchingGame*) game{
  NSUInteger cardsToRender = self.minNumOfCards;
  if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount: cardsToRender usingDeck: self.deck];
  return _game;
}

- (Grid*) createGrid {
  Grid* grid = [[Grid alloc] init];
  grid.size = self.cardsView.frame.size;
  if (self.cardsView.frame.size.width / self.cardsView.frame.size.height < self.cardsView.frame.size.height / self.cardsView.frame.size.width) {
    grid.cellAspectRatio = self.cardsView.frame.size.width / self.cardsView.frame.size.height;
  } else{
    grid.cellAspectRatio = self.cardsView.frame.size.height / self.cardsView.frame.size.width;
  }
  grid.minimumNumberOfCells = self.game.numberOfCardsInGame;
  return grid;
}


- (IBAction)touchResetButton {
  [self.game resetGame: self.minNumOfCards usingDeck:[self createDeck]];
  for (UIView* cardView in self.cards) {
    [cardView removeFromSuperview];
  }
  [self.cards removeAllObjects];
  [self addCardsInGrid];
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
  [self updateUI];
}

- (IBAction)pan:(UIGestureRecognizer*) gesture {
  
  if (self.inPinch) {
    for (UIView* cardView in self.cards) {
      cardView.center = [gesture locationInView:self.cardsView];
    }
  }
}

//abstract
- (IBAction) swipe :(UISwipeGestureRecognizer *) gesture {}

- (IBAction)pinch: (UIPinchGestureRecognizer*) gesture {
  int t = 0;
  if (gesture.state == UIGestureRecognizerStateBegan) {
    if (!self.inPinch){
      self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget: self action:@selector(pan:)];
      [self.view addGestureRecognizer: self.panGesture];
    }
    self.inPinch = YES;
    for (UIView* cardView in self.cards) {
      [UIView animateWithDuration:0.5 delay:0.01 * t options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        cardView.center = cardView.superview.center;
        } completion:nil];
      t++;
    }
  }
}

- (IBAction)tapOnCardsView:(UITapGestureRecognizer*) gesture {
  int t = 0;
  self.inPinch = NO;
  [self.view removeGestureRecognizer: self.panGesture];
  for (UIView* cardView in self.cards) {
    [UIView animateWithDuration:0.5 delay:0.01 * t options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
      cardView.frame = [self.grid frameOfCellAtRow:(t/self.grid.columnCount)
                                          inColumn:(t%self.grid.columnCount)];
    } completion:nil];
    t++;
  }
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

// abstract
- (void) addCardsInGrid
{
}

// abstract
-(void) updateUI
{
}

// abstract
- (NSString*) titleForCard: (Card*) card
{
  return @"";
}

// abstract
- (UIImage*) backgroundForCard: (Card*) card
{
  return [[UIImage alloc] init];
}

// abstract
- (Deck*) createDeck
{
  return [[Deck alloc] init];
}

- (void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  if (!self.inPinch) {
    self.grid = [self createGrid];
    if (!self.didCallLayoutSubViews){
      [self updateUI];
      self.didCallLayoutSubViews = YES;
    }
  }
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  __weak __block ViewController* weakSelf = self;
  [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    weakSelf.grid = [weakSelf createGrid];
    [weakSelf.view setNeedsLayout];
  }];

}


@end

