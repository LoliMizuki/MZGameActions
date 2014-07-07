#import "MZAction.h"

@interface MZTouchRelativeMove : MZAction <MZTouchResponder>

@property (nonatomic, readwrite, weak) id<MZTransform> mover;

@end
