#import "MZPool.h"

@implementation MZPool {
    int _currentIndex;

    NSMutableArray *_poolElementsStates;
    NSMutableArray *_poolElements;

    MZPoolElementAction _onGetAction;
    MZPoolElementAction _onReturnAction;
}

+ (instancetype)newWithNumber:(NSUInteger)number
               elementGenFunc:(id (^)(void))elementGenFunc
                  onGetAction:(MZPoolElementAction)onGetAction
               onReturnAction:(MZPoolElementAction)onReturnAction {
    return [[self alloc] initWithNumber:number
                         elementGenFunc:elementGenFunc
                            onGetAction:onGetAction
                         onReturnAction:onReturnAction];
}

- (instancetype)initWithNumber:(NSUInteger)number
                elementGenFunc:(id (^)(void))elementGenFunc
                   onGetAction:(MZPoolElementAction)onGetAction
                onReturnAction:(MZPoolElementAction)onReturnAction {
    self = [super init];

    _onGetAction = onGetAction;
    _onReturnAction = onReturnAction;

    _poolElements = [NSMutableArray arrayWithCapacity:1];
    _poolElementsStates = [NSMutableArray arrayWithCapacity:1];

    for (int i = 0; i < number; i++) {
        id idElement = elementGenFunc();
        // TOOD: need check ...
        id<MZPoolElement> asPoolElement = idElement;

        asPoolElement.pool = self;
        asPoolElement.poolElementIndex = i;

        [_poolElements addObject:idElement];
        [_poolElementsStates addObject:@(false)];
    }

    return self;
}

- (NSUInteger)numberOfElements {
    return _poolElements.count;
}

- (NSUInteger)numberOfAvailable {
    int count = 0;
    for (NSNumber *v in _poolElementsStates) {
        if (![v boolValue]) count++;
    }

    return count;
}

- (NSArray *)elements {
    return _poolElements;
}

- (id)getElement {
    if (_poolElements == nil) return nil;

    for (int i = 0; i < _poolElements.count; i++) {
        int index = _currentIndex % _poolElements.count;
        _currentIndex++;

        if ([_poolElementsStates[index] boolValue] == false) {
            _poolElementsStates[index] = @(true);
            id e = _poolElements[index];
            if (_onGetAction != nil) _onGetAction(e);

            return e;
        }
    }

    // reach here: your pool is to low :]
    return nil;
}

- (void)returnElement:(id)element {
    id<MZPoolElement> asPoolElement = element;

    _poolElementsStates[asPoolElement.poolElementIndex] = @(false);

    if (_onReturnAction != nil) _onReturnAction(element);
}

- (bool)containsElement:(id)element {
    return [_poolElements containsObject:element];
}

- (void)removeElement:(id)element {
    id<MZPoolElement> asPoolElement = element;
    [_poolElementsStates removeObjectAtIndex:asPoolElement.poolElementIndex];
    [_poolElements removeObjectAtIndex:asPoolElement.poolElementIndex];
}

- (void)removeAllElements {
    [_poolElementsStates removeAllObjects];
    [_poolElements removeAllObjects];
}

- (void)clearPool {
    [self removeAllElements];
    _currentIndex = 0;

    // real releae the block?
    _onGetAction = nil;
    _onReturnAction = nil;
}

@end