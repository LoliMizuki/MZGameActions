#import "MZAction.h"

@interface MZTouchRelativeMove : MZAction <MZTouchResponder>

@property (nonatomic, readwrite, weak) id<MZTransform> mover;

+ (instancetype)newWithMover:(id<MZTransform>)mover touchNotifier:(id<MZTouchNotifier>)touchNotifier;

@end
