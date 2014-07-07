#import "MZAction.h"
#import "MZMovesHeader.h"

@interface MZMove : MZAction

@property (nonatomic, readwrite, weak) id<MZTransform> mover;

+ (instancetype)newWithMover:(id)mover;

@end
