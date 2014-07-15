#import "MZBoundTest.h"
#import "MZGameHeader.h"

@interface MZBoundTest (_)
- (bool)_isOutOfBound;
@end



@implementation MZBoundTest

@synthesize boundTester, bound, testerSizeFunc, outOfBoundAction;

+ (instancetype)newWithTester:(id<MZTransform>)tester bound:(CGRect)bound {
    MZBoundTest *boundTest = [self new];
    boundTest.boundTester = tester;
    boundTest.bound = bound;

    return boundTest;
}

- (void)setTesterSize:(CGSize)aTesterSize {
    testerSizeFunc = nil;
    testerSizeFunc = ^{ return aTesterSize; };
}

- (CGSize)testerSize {
    return (testerSizeFunc != nil) ? testerSizeFunc() : CGSizeZero;
}

- (void)update {
    [super update];
    if ([self _isOutOfBound]) outOfBoundAction(self);
}

@end

@implementation MZBoundTest (_)

- (bool)_isOutOfBound {
    CGSize halfSize = CGSizeMake(self.testerSize.width / 2, self.testerSize.height / 2);

    return boundTester.position.x + halfSize.width < CGRectGetMinX(bound) ||
           boundTester.position.x - halfSize.width > CGRectGetMaxX(bound) ||
           boundTester.position.y + halfSize.height < CGRectGetMinY(bound) ||
           boundTester.position.y - halfSize.height > CGRectGetMaxY(bound);
}

@end
