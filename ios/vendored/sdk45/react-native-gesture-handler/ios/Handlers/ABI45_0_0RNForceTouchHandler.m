#import "ABI45_0_0RNForceTouchHandler.h"

#import <UIKit/UIGestureRecognizerSubclass.h>

#import <ABI45_0_0React/ABI45_0_0RCTConvert.h>

@interface ABI45_0_0RNForceTouchGestureRecognizer : UIGestureRecognizer

@property (nonatomic) CGFloat maxForce;
@property (nonatomic) CGFloat minForce;
@property (nonatomic) CGFloat force;
@property (nonatomic) BOOL feedbackOnActivation;

- (id)initWithGestureHandler:(ABI45_0_0RNGestureHandler*)gestureHandler;

@end

@implementation ABI45_0_0RNForceTouchGestureRecognizer {
  __weak ABI45_0_0RNGestureHandler *_gestureHandler;
  UITouch *_firstTouch;
}

static const CGFloat defaultForce = 0;
static const CGFloat defaultMinForce = 0.2;
static const CGFloat defaultMaxForce = NAN;
static const BOOL defaultFeedbackOnActivation = NO;

- (id)initWithGestureHandler:(ABI45_0_0RNGestureHandler*)gestureHandler
{
  if ((self = [super initWithTarget:gestureHandler action:@selector(handleGesture:)])) {
    _gestureHandler = gestureHandler;
    _force = defaultForce;
    _minForce = defaultMinForce;
    _maxForce = defaultMaxForce;
    _feedbackOnActivation = defaultFeedbackOnActivation;
  }
  return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  if (_firstTouch) {
    // ignore rest of fingers
    return;
  }
  [super touchesBegan:touches withEvent:event];
  [_gestureHandler.pointerTracker touchesBegan:touches withEvent:event];
  
  _firstTouch = [touches anyObject];
  [self handleForceWithTouches:touches];
  self.state = UIGestureRecognizerStatePossible;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  if (![touches containsObject:_firstTouch]) {
    // Considered only the very first touch
    return;
  }
  [super touchesMoved:touches withEvent:event];
  [_gestureHandler.pointerTracker touchesMoved:touches withEvent:event];
  
  [self handleForceWithTouches:touches];
  
  if ([self shouldFail]) {
    self.state = UIGestureRecognizerStateFailed;
    return;
  }
  
  if (self.state == UIGestureRecognizerStatePossible && [self shouldActivate]) {
    [self performFeedbackIfRequired];
    self.state = UIGestureRecognizerStateBegan;
  }
}

- (BOOL)shouldActivate {
  return (_force >= _minForce);
}

- (BOOL)shouldFail {
  return TEST_MAX_IF_NOT_NAN(_force, _maxForce);
}

- (void)performFeedbackIfRequired
{
#if !TARGET_OS_TV
  if (_feedbackOnActivation) {
    if (@available(iOS 10.0, *)) {
      [[[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyleMedium)] impactOccurred];
    }
  }
#endif
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  if (![touches containsObject:_firstTouch]) {
    // Considered only the very first touch
    return;
  }
  [super touchesEnded:touches withEvent:event];
  [_gestureHandler.pointerTracker touchesEnded:touches withEvent:event];
  if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
    self.state = UIGestureRecognizerStateEnded;
  } else {
    self.state = UIGestureRecognizerStateFailed;
  }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [super touchesCancelled:touches withEvent:event];
  [_gestureHandler.pointerTracker touchesCancelled:touches withEvent:event];
}

- (void)handleForceWithTouches:(NSSet<UITouch *> *)touches {
  _force = _firstTouch.force / _firstTouch.maximumPossibleForce;
}

- (void)reset {
  [_gestureHandler.pointerTracker reset];
  [super reset];
  _force = 0;
  _firstTouch = NULL;
}

@end

@implementation ABI45_0_0RNForceTouchHandler

- (instancetype)initWithTag:(NSNumber *)tag
{
  if ((self = [super initWithTag:tag])) {
    _recognizer = [[ABI45_0_0RNForceTouchGestureRecognizer alloc] initWithGestureHandler:self];
  }
  return self;
}

- (void)resetConfig
{
  [super resetConfig];
  ABI45_0_0RNForceTouchGestureRecognizer *recognizer = (ABI45_0_0RNForceTouchGestureRecognizer *)_recognizer;
  
  recognizer.feedbackOnActivation = defaultFeedbackOnActivation;
  recognizer.maxForce = defaultMaxForce;
  recognizer.minForce = defaultMinForce;
}

- (void)configure:(NSDictionary *)config
{
  [super configure:config];
  ABI45_0_0RNForceTouchGestureRecognizer *recognizer = (ABI45_0_0RNForceTouchGestureRecognizer *)_recognizer;

  APPLY_FLOAT_PROP(maxForce);
  APPLY_FLOAT_PROP(minForce);

  id prop = config[@"feedbackOnActivation"];
  if (prop != nil) {
    recognizer.feedbackOnActivation = [ABI45_0_0RCTConvert BOOL:prop];
  }
}

- (ABI45_0_0RNGestureHandlerEventExtraData *)eventExtraData:(ABI45_0_0RNForceTouchGestureRecognizer *)recognizer
{
  return [ABI45_0_0RNGestureHandlerEventExtraData
          forForce: recognizer.force
          forPosition:[recognizer locationInView:recognizer.view]
          withAbsolutePosition:[recognizer locationInView:recognizer.view.window]
          withNumberOfTouches:recognizer.numberOfTouches];
}

@end

