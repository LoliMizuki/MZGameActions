#import "MZActionsSequence.h"
#import "MZGameHeader.h"

@interface MZActionsSequence (_)
- (MZAction *)_actionAtIndex:(int)index;
@end



@implementation MZActionsSequence {
    int _currentIndex;
}

@synthesize actionsSequence;

+ (instancetype)newWithActions:(NSArray *)actions {
    MZActionsSequence *actionsSequence = [self new];

    for (MZAction *a in actions) [actionsSequence addAction:a];

    return actionsSequence;
}

- (instancetype)init {
    self = [super init];
    actionsSequence = [NSMutableArray new];
    return self;
}

- (void)dealloc {
    [self removeAllActions];
}

- (bool)isActive {
    return _currentIndex < actionsSequence.count;
}

- (id)addAction:(MZAction *)action {
    [actionsSequence addObject:action];
    return action;
}

- (id)removeAction:(MZAction *)action {
    if ([actionsSequence containsObject:action]) [actionsSequence removeObject:action];
    return action;
}

- (void)removeInactiveActions {
    for (int i = 0; i < actionsSequence.count; i++) {
        MZAction *a = actionsSequence[i];
        if (a.isActive) continue;

        [a end];
        [actionsSequence removeObjectAtIndex:i];
        i--;
    }
}

- (void)removeAllActions {
    [actionsSequence removeAllObjects];
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
    return (0 <= index && index < actionsSequence.count) ? actionsSequence[index] : nil;
}

@end
