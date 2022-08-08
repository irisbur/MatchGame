//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Iris Burmistrov on 03/08/2022.
//

#import <UIKit/UIKit.h>


@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (nonatomic, strong) NSString* suit;
@property (nonatomic) BOOL faceUp;

- (void) pinch: (UIPinchGestureRecognizer*) gesture;

@end

