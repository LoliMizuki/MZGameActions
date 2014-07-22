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

    for (MZAction *a in actions) [actionsSequence addAction:a];

    return actionsSequence;
}

- (instancetype)init {
    self = [super init];
    aciotnsSequence = [NSMutableArray new];
    return self;
}

- (void)dealloc {
    [self removeAllActions];
}

- (bool)isActive {
    return _currentIndex < aciotnsSequence.count;
}

- (id)addAction:(MZAction *)action {
    [aciotnsSequence addObject:action];
    return action;
}

- (id)removeAction:(MZAction *)action {
    if ([aciotnsSequence containsObject:action]) [aciotnsSequence removeObject:action];
    return action;
}

- (void)removeInactiveActions {
    for (int i = 0; i < aciotnsSequence.count; i++) {
        MZAction *a = aciotnsSequence[i];
        if (a.isActive) continue;

        [a end];
        [aciotnsSequence removeObjectAtIndex:i];
        i--;
    }
}

- (void)removeAllActions {
    [aciotnsSequence removeAllObjects];
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
        if (curr != nil) [curr start];
    }

    if (curr != nil) [curr update];
}

@end

@implementation MZActionsSequence (_)

- (MZAction *)_actionAtIndex:(int)index {
    return (0 <= index && index < aciotnsSequence.count) ? aciotnsSequence[index] : nil;
}

@end
