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
@property (nonatomic, strong) NSString* symbol;
@property (nonatomic, strong) NSString* shading;

- (void) pinch: (UIPinchGestureRecognizer*) gesture;

@end


