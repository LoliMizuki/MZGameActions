#import "MZTouchRelativeMove.h"
#import "MZGameHeader.h"

@interface MZTouchRelativeMove (_)
- (bool)_checkNils;
@end

@implementation MZTouchRelativeMove {
    CGPoint _moverPositionAtBegan;
    CGPoint _touchPositionAtBegan;
}

@synthesize mover, bound, touchNotifier;

+ (instancetype)newWithMover:(id<MZTransform>)mover touchNotifier:(id<MZTouchNotifier>)touchNotifier {
    MZAssertIfNilWithMessage(mover, @"mover is nil");
    MZAssertIfNilWithMessage(touchNotifier, @"touchNotifier is nil");

    MZTouchRelativeMove *t = [MZTouchRelativeMove new];
    t.mover = mover;
    t.touchNotifier = touchNotifier;
    [t.touchNotifier addTouchResponder:t];

    return t;
}

- (instancetype)init {
    self = [super init];
    bound = CGRectNull;
    return self;
}

- (void)dealloc {
    [self removeFromNotifier];
    mover = nil;
}

- (void)touchesBegan:(NSSet *)touches {
    if ([self _checkNils]) return;

    _moverPositionAtBegan = mover.position;
    _touchPositionAtBegan = [touchNotifier positionWithTouch:[touches anyObject]];
}

- (void)touchesMoved:(NSSet *)touches {
    if ([self _checkNils]) return;

    CGPoint currTouchPos = [touchNotifier positionWithTouch:[touches anyObject]];
    CGPoint diff = mzpSub(currTouchPos, _touchPositionAtBegan);
    CGPoint nextPos = mzpAdd(_moverPositionAtBegan, diff);

    if (!CGRectIsNull(bound)) {
        float nextX = fmaxf(fminf(nextPos.x, CGRectGetMaxX(bound)), CGRectGetMinX(bound));
        float nextY = fmaxf(fminf(nextPos.y, CGRectGetMaxY(bound)), CGRectGetMinY(bound));

        nextPos = mzp(nextX, nextY);
    }

    mover.position = nextPos;
}

- (void)touchesEnded:(NSSet *)touches {
}

- (void)removeFromNotifier {
    if (touchNotifier == nil) return;

    [touchNotifier removeTouchResponder:self];
    touchNotifier = nil;
}

@end

@implementation MZTouchRelativeMove (_)

- (bool)_checkNils {
    return (mover == nil || touchNotifier == nil);
}

@end
