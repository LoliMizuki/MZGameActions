#import "MZAction.h"
#import "MZBoundTesterHeader.h"

@class MZBoundTest;

typedef void (^MZBoundTestAction)(MZBoundTest *boundTest);



@interface MZBoundTest : MZAction

@property (nonatomic, readwrite, weak) id<MZTransform> boundTester;
@property (nonatomic, readwrite) CGRect bound;
@property (nonatomic, readwrite) CGSize testerSize;
@property (nonatomic, readwrite, strong) CGSize (^testerSizeFunc)(void);
@property (nonatomic, readwrite, strong) void (^outOfBoundAction)(MZBoundTest *boundTest);

+ (instancetype)newWithTester:(id<MZTransform>)tester bound:(CGRect)bound;

@end