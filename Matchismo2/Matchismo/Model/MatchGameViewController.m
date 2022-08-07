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


@interface ViewController()

@property (strong, nonatomic) NSArray* playingCards; // todo - check if of Card?

@end

@implementation MatchGameViewController

const static NSUInteger numberOfCards = 30;

@synthesize deck = _deck;

- (Deck *)deck
{
    if (!_deck) _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}

- (void) addCardsInGrid
{
  Grid* grid = [self createGrid];
  NSUInteger rows = [grid rowCount];
  NSUInteger cols = [grid columnCount];
  for (NSUInteger i = 0 ; i < rows; i++) {
    for (NSUInteger j = 0 ; j < cols; j++ ){
      CGRect frame = [grid frameOfCellAtRow:i inColumn:j];
      PlayingCardView* cardView = [[PlayingCardView alloc] initWithFrame:frame];
      [self drawRandomPlayingCard:cardView];
      [self.cardsView addSubview:cardView];
    }
  }
}

- (Deck *)createDeck {
  return [[PlayingCardDeck alloc] init];
}

- (NSString *)titleForCard:(Card *)card {
  return card.isChosen ? card.contents: @"";
}

- (UIImage*) backgroundForCard: (Card*) card {
  return [UIImage imageNamed: card.isChosen ? @"cardfront" : @"cardback"];
}

- (void)drawRandomPlayingCard : (PlayingCardView*) playingCardView
{
  Card *card = [self.deck drawRandomCard];
  if ([card isKindOfClass:[PlayingCard class]]) {
      PlayingCard *playingCard = (PlayingCard *)card;
//     todo - set card to someone in view
     playingCardView.rank = playingCard.rank;
     playingCardView.suit = playingCard.suit;
  }
}

-(NSUInteger) minNumOfCards{
  return 30;
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender
{
  //playingCardView.faceUp = !playingCardView.faceUp;
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  [self addCardsInGrid];
  for (UIView* cardView in [self.cardsView subviews]) {
    if ([cardView isKindOfClass:[PlayingCardView class]]){
      [cardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:cardView action:@selector(pinch:)]];
    }
  }
}

@end

