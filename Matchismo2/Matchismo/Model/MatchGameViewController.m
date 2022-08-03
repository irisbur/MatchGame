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


@property (strong, nonatomic) NSArray*playingCardsView;

@end

@implementation MatchGameViewController



- (Deck *)createDeck {
  return [[PlayingCardDeck alloc] init];
}

- (NSString *)titleForCard:(Card *)card {
  return card.isChosen ? card.contents: @"";
}

- (UIImage*) backgroundForCard: (Card*) card {
  return [UIImage imageNamed: card.isChosen ? @"cardfront" : @"cardback"];
}

- (void)drawRandomPlayingCard
{
  Card *card = [self.deck drawRandomCard];
  NSLog(@"%@", card.contents);
  if ([card isKindOfClass:[PlayingCard class]]) {
      PlayingCard *playingCard = (PlayingCard *)card;
      self.playingCardView.rank = playingCard.rank;
      self.playingCardView.suit = playingCard.suit;
  }
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender
{

    if (!self.playingCardView.faceUp) [self drawRandomPlayingCard];
    self.playingCardView.faceUp = !self.playingCardView.faceUp;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
    [self.playingCardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.playingCardView action:@selector(pinch:)]];
}

@end

