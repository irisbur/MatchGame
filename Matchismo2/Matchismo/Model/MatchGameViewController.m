//
//  MatchGameViewController.m
//  Matchismo
//
//  Created by Iris Burmistrov on 26/07/2022.
//

#import "CardMatchingGame.h"
#import "MatchGameViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"



@implementation MatchGameViewController


@synthesize deck = _deck;

- (Deck *)deck
{
    if (!_deck) _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}

- (void) addCardsInGrid
{
  NSUInteger rows = [self.grid rowCount];
  NSUInteger cols = [self.grid columnCount];
  for (NSUInteger i = 0 ; i < rows; i++) {
    for (NSUInteger j = 0 ; j < cols; j++ ){
      CGRect frame = [self.grid frameOfCellAtRow:i inColumn:j];
      PlayingCardView* cardView = [[PlayingCardView alloc] initWithFrame:frame];
//      [self drawRandomPlayingCard : cardView cardIndex:(j*rows + i)];
      [self.cardsView addSubview:cardView];
      [self.cards addObject:cardView];
    }
  }
}

- (Deck *)createDeck {
  return [[PlayingCardDeck alloc] init];
}

- (NSString *)titleForCard:(Card *)card {
  return card.isChosen ? card.contents: @"";
}

- (IBAction)touchResetButton {
  [self.game resetGame:[[self.cardsView subviews] count] usingDeck:[self createDeck]];
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
  [self updateUI];
}

- (UIImage*) backgroundForCard: (Card*) card {
  return [UIImage imageNamed: card.isChosen ? @"cardfront" : @"cardback"];
}

//- (void) drawRandomPlayingCard : (PlayingCardView*) playingCardView cardIndex: (NSUInteger) cardInx {
//  Card *card = [self.game cardAtIndex: cardInx];
//  if ([card isKindOfClass:[PlayingCard class]]) {
//      PlayingCard *playingCard = (PlayingCard *)card;
////     todo - set card to someone in view
//     playingCardView.rank = playingCard.rank;
//     playingCardView.suit = playingCard.suit;
//  }
//}

-(NSUInteger) minNumOfCards{
  return 30;
}

-(void) updateUI {
  for (PlayingCardView* cardView in self.cards){
    int cardIndex = (int) [self.cards indexOfObject:cardView];
    PlayingCard* card = (PlayingCard*) [self.game cardAtIndex:cardIndex];
    cardView.rank = card.rank;
    cardView.suit = card.suit;
    cardView.faceUp = card.chosen;
    cardView.alpha = card.isMatched ? 0.5 : 1;
    }
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
}

- (IBAction) swipe :(UISwipeGestureRecognizer *) sender {
  CGPoint swipePoint = [sender locationInView:self.cardsView];
  float cardWidth = self.cardsView.bounds.size.width / self.grid.rowCount;
  float cardHieght = self.cardsView.bounds.size.height / self.grid.columnCount;
  NSUInteger i = swipePoint.x / cardWidth;
  NSUInteger j = swipePoint.y / cardHieght;
  NSUInteger chosenViewIndex = j * self.grid.rowCount + i;
  PlayingCardView* playingCardView = [self.cards objectAtIndex:chosenViewIndex];
  [self.game chooseCardAtIndex:chosenViewIndex :MATCH_MODE];
  playingCardView.faceUp = !playingCardView.faceUp;
  [self updateUI];
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.grid = [self createGrid];
  [self addCardsInGrid];
  for (UIView* cardView in [self.cardsView subviews]) {
    if ([cardView isKindOfClass:[PlayingCardView class]]){
      [cardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:cardView action:@selector(pinch:)]];
    }
  }
}

@end

