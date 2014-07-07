#import "MZMove.h"
#import "MZGameHeader.h"

@implementation MZMove

@synthesize mover;

+ (instancetype)newWithMover:(id)mover {
    MZAssertIfNilWithMessage(mover, @"mover is nil");
    MZAssert([mover conformsToProtocol:@protocol(MZTransform)], @"mover not conforms protocol mover");

    MZMove *m = [self new];
    m.mover = mover;
    return m;
}

- (void)dealloc {
    mover = nil;
}

@end
