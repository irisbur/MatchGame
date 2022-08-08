//
//  SetCardView.h
//  Matchismo
//
//  Created by Iris Burmistrov on 03/08/2022.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (nonatomic, strong) NSString* suit;
@property (nonatomic, strong) NSString* color;
@property (nonatomic, strong) NSString* shading;

@property (nonatomic) BOOL chosen;

- (void) pinch: (UIPinchGestureRecognizer*) gesture;

@end


