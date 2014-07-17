#import "MZActionsSequence.h"
#import "MZGameHeader.h"

@interface MZActionsSequence (_)
- (MZAction *)_actionAtIndex:(int)index;
@end



@implementation MZActionsSequence {
    int _currentIndex;
}

@synthesize aciotnsSequence;

+ (instancetype)newWithActions:(NSArray *)actions {
    MZActionsSequence *actionsSequence = [self new];

    for (MZAction *a in actions) [actionsSequence addAciotn:a];

    return actionsSequence;
}

- (instancetype)init {
    self = [super init];
    aciotnsSequence = [NSMutableArray new];
    return self;
}

- (void)dealloc {
    [aciotnsSequence removeAllObjects];
}

- (void)addAciotn:(MZAction *)action {
    [aciotnsSequence addObject:action];
}

- (bool)isActive {
    return _currentIndex < aciotnsSequence.count;
}

- (void)start {
    [super start];
    _currentIndex = 0;
    [[self _actionAtIndex:_currentIndex] start];
}

- (void)update {
    [super update];

    MZAction *curr = [self _actionAtIndex:_currentIndex];

    if (curr != nil && !curr.isActive) {
        [curr end];
        _currentIndex++;
        curr = [self _actionAtIndex:_currentIndex];
    }

    if (curr != nil) [curr update];
}

- (void)end {
    [super end];
}

@end

@implementation MZActionsSequence (_)

- (MZAction *)_actionAtIndex:(int)index {
    return (0 <= index && index < aciotnsSequence.count) ? aciotnsSequence[index] : nil;
}

@end
