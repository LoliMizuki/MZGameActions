#import "MZAction.h"

@interface MZMove : MZAction

@property (nonatomic, readwrite, weak) id<MZTransform> mover;

@property (nonatomic, readonly) MZFloat currentDirection;

+ (instancetype)newWithMover:(id)mover;

@end

// 支援: 目前的 direction
