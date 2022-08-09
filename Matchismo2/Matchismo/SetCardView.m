//
//  SetCardView.m
//  Matchismo
//
//  Created by Iris Burmistrov on 03/08/2022.
//

#import "SetCardView.h"

@interface SetCardView()

@property (nonatomic) CGFloat faceCardScaleFactor;

@end

@implementation SetCardView

#pragma mark - Properties

#define DEFAULT_FACE_CARD_SCALE_FACTOR 1

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

- (CGFloat) faceCardScaleFactor {
  if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
  return _faceCardScaleFactor;
}

- (void) setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor {
  _faceCardScaleFactor = faceCardScaleFactor;
  [self setNeedsDisplay];
}

- (void) setSuit:(NSString *)suit{
  _suit = suit;
  [self setNeedsDisplay];
}

-(void) setRank:(NSUInteger)rank {
  _rank = rank;
  [self setNeedsDisplay];
}

- (void) setColor:(NSString *) color {
  _color = color;
  [self setNeedsDisplay];
}

- (void) setChosen: (BOOL)chosen {
  _chosen = chosen;
  [self setNeedsDisplay];
}

- (void) setShading :(NSString *) shading {
  _shading = shading;
  [self setNeedsDisplay];
}

#pragma mark - Gesture Handling

- (void)pinch:(UIPinchGestureRecognizer*)gesture {
  if ((gesture.state == UIGestureRecognizerStateChanged) ||
      (gesture.state == UIGestureRecognizerStateEnded)){
    self.faceCardScaleFactor *= gesture.scale;
    gesture.scale = 1.0;
  }
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

const static float STRIPE_LINE_GAP = 0.1;
const static float CHOSEN_WIDTH_FACTOR = 5.0;

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

- (UIColor*) getStrokeColor {
  UIColor* strokeColor = nil;
  if ([self.color isEqualToString: @"red"]){
    strokeColor = [UIColor redColor];
  } else if ([self.color isEqualToString: @"green"]) {
    strokeColor = [UIColor greenColor];
  } else if ([self.color isEqualToString:@"purple"]) {
    strokeColor = [UIColor purpleColor];
  }
  return strokeColor;
}

- (UIColor*) getBackgroundColor {
  UIColor* color = [self getStrokeColor];
  UIColor* fillColor = nil;
  if ([self.shading isEqualToString: @"solid"]){
    fillColor = color;
  } else if ([self.color isEqualToString: @"striped"]) {
    fillColor =  color;
  } else if ([self.color isEqualToString:@"open"]) {
    fillColor = [UIColor whiteColor];
  }
  return fillColor;
}

- (void)addStripes:(CGRect) rect {
  if ([self.shading isEqualToString: @"striped"]){
    UIBezierPath *stripes = [UIBezierPath bezierPath];
    CGFloat lineGap = rect.size.width * STRIPE_LINE_GAP;
    for (CGFloat i = 0; i < rect.size.width; i += lineGap) {
      [stripes moveToPoint:CGPointMake(rect.origin.x + i, rect.origin.y)];
      [stripes addLineToPoint:CGPointMake(rect.origin.x + i, rect.origin.y + rect.size.height)];
    }
    stripes.lineWidth = 1;
    [stripes stroke];
  }
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
  UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:
                               [self cornerRadius]];

  [roundedRect addClip];

  [[UIColor whiteColor] setFill];
  UIRectFill(self.bounds);

  [[UIColor blackColor] setStroke];
  if (self.chosen){
    roundedRect.lineWidth *= CHOSEN_WIDTH_FACTOR;
  }
  else {
    roundedRect.lineWidth /= CHOSEN_WIDTH_FACTOR;
  }
  [roundedRect stroke];
  [self drawShapes];
}

#pragma mark - Drawing Shapes

const static float SYMBOL_WIDTH_RATIO = 0.8;
const static float SYMBOL_HEIGHT_RATIO = 0.25;

- (void) drawShapes {
  CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
  if (self.rank == 1){
    [self drawOneShape: middle];
  } else if (self.rank == 2){
    [self drawTwoShapes];
  } else if (self.rank ==3){
    [self drawThreeShapes];
  }
}

- (void) drawOneShape : (CGPoint) middle {
  CGContextRef context = UIGraphicsGetCurrentContext();
  UIBezierPath* path = nil;
  if ([self.suit isEqualToString: @"oval"]){
    path = [self drawOval : middle];
  } else if ([self.suit isEqualToString: @"diamond"]){
    path = [self drawDiamond : middle];
  } else if ([self.suit isEqualToString: @"squiggle"]){
    path = [self drawSquiggle : middle];
  }
  [[self getStrokeColor] setStroke];
  [path stroke];
  [[self getBackgroundColor] setFill];
  [path fill];
  CGContextSaveGState(context);
  [path addClip];
  [self addStripes: path.bounds];
  CGContextRestoreGState(context);
}

- (void) drawTwoShapes {
  CGPoint firstShapeCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/4);
  [self drawOneShape:firstShapeCenter];
  CGPoint secondShapeCenter = CGPointMake(self.bounds.size.width/2, 0.5*self.bounds.size.height);
  [self drawOneShape:secondShapeCenter];
}

- (void) drawThreeShapes {
  CGPoint firstShapeCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/6);
  [self drawOneShape:firstShapeCenter];
  CGPoint secondShapeCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
  [self drawOneShape: secondShapeCenter];
  CGPoint thirdShapeCenter = CGPointMake(self.bounds.size.width/2, 5*self.bounds.size.height/6);
  [self drawOneShape: thirdShapeCenter];
}


- (UIBezierPath*) drawOval:(CGPoint) middle {
  CGFloat voffset = 0.25;
  CGPoint ovalRightCenter = CGPointMake(middle.x + voffset*self.bounds.size.width,
                                        middle.y);
  CGPoint ovalLeftCenter = CGPointMake(middle.x - voffset*self.bounds.size.width,
                                        middle.y);
  CGPoint ovalOrigin = CGPointMake(middle.x + voffset*self.bounds.size.width,
                                   middle.y - [self cornerRadius]);

  CGPoint ovalLeftBottom = CGPointMake(middle.x + voffset*self.bounds.size.width,
                                   middle.y + [self cornerRadius]);
  UIBezierPath * ovalPath = [UIBezierPath bezierPathWithArcCenter:ovalRightCenter
                            radius: [self cornerRadius] startAngle: M_PI * 1.5 endAngle:
                             M_PI * 0.5 clockwise:YES];
  [ovalPath addLineToPoint:ovalLeftBottom];
  [ovalPath addArcWithCenter:ovalLeftCenter radius:[self cornerRadius] startAngle: M_PI * 0.5
                    endAngle: M_PI * 1.5 clockwise:YES];
  [ovalPath addLineToPoint:ovalOrigin];
  return ovalPath;
}

- (UIBezierPath*) drawDiamond:(CGPoint) middle {
  CGFloat hoffset = 0.1;
  CGFloat voffset = 0.1;
  CGPoint diamondOrigin = CGPointMake(middle.x, middle.y - voffset*self.bounds.size.width);
  CGPoint rightMiddle = CGPointMake(middle.x + hoffset*self.bounds.size.height, middle.y);
  CGPoint middleDown = CGPointMake(middle.x, middle.y + voffset*self.bounds.size.width);
  CGPoint leftMiddle = CGPointMake(middle.x - hoffset*self.bounds.size.height, middle.y);
  UIBezierPath* diamondPath = [UIBezierPath bezierPath];
  [diamondPath moveToPoint:diamondOrigin];
  [diamondPath addLineToPoint:rightMiddle];
  [diamondPath addLineToPoint:middleDown];
  [diamondPath addLineToPoint:leftMiddle];
  [diamondPath addLineToPoint:diamondOrigin];
  return diamondPath;
}



// method code origin:
//https://stackoverflow.com/questions/25387940/how-to-draw-a-perfect-squiggle-in-set-card-game-with-objective-c
- (UIBezierPath*) drawSquiggle :(CGPoint) point {
  CGSize size = CGSizeMake(self.bounds.size.width * SYMBOL_WIDTH_RATIO, self.bounds.size.height * SYMBOL_HEIGHT_RATIO);
  UIBezierPath *path = [[UIBezierPath alloc] init];
  [path moveToPoint:CGPointMake(104, 15)];
  [path addCurveToPoint:CGPointMake(63, 54) controlPoint1:CGPointMake(112.4, 36.9) controlPoint2:CGPointMake(89.7, 60.8)];
  [path addCurveToPoint:CGPointMake(27, 53) controlPoint1:CGPointMake(52.3, 51.3) controlPoint2:CGPointMake(42.2, 42)];
  [path addCurveToPoint:CGPointMake(5, 40) controlPoint1:CGPointMake(9.6, 65.6) controlPoint2:CGPointMake(5.4, 58.3)];
  [path addCurveToPoint:CGPointMake(36, 12) controlPoint1:CGPointMake(4.6, 22) controlPoint2:CGPointMake(19.1, 9.7)];
  [path addCurveToPoint:CGPointMake(89, 14) controlPoint1:CGPointMake(59.2, 15.2) controlPoint2:CGPointMake(61.9, 31.5)];
  [path addCurveToPoint:CGPointMake(104, 15) controlPoint1:CGPointMake(95.3, 10) controlPoint2:CGPointMake(100.9, 6.9)];
  [path applyTransform:CGAffineTransformMakeScale(0.9524*size.width/100, 0.9524*size.height/50)];
  [path applyTransform:CGAffineTransformMakeTranslation(point.x - size.width/2 - 3 * size.width /100, point.y - size.height/2 - 8 * size.height/50)];
  return path;
}

#pragma mark - Initialization

- (void)setup
{
  self.backgroundColor = nil;
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

@end
