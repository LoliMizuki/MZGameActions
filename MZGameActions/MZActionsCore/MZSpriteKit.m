#import <SpriteKit/SpriteKit.h>
#import "MZSpriteKit.h"
#import "MZPool.h"

#pragma mark - SKNode (MZPool)

@implementation SKNode (MZPoolElement)

- (void)setPool:(MZPool *)pool {
    if (self.userData == nil) self.userData = [NSMutableDictionary new];
    self.userData[@"pool"] = pool;
}

- (MZPool *)pool {
    return self.userData[@"pool"];
}

- (void)setPoolElementIndex:(NSUInteger)poolElementIndex {
    if (self.userData == nil) self.userData = [NSMutableDictionary new];
    self.userData[@"poolElementIndex"] = @(poolElementIndex);
}

- (NSUInteger)poolElementIndex {
    return [self.userData[@"poolElementIndex"] unsignedIntegerValue];
}

- (void)returnPool {
    MZPool *pool = self.userData[@"pool"];
    if (pool == nil) return;

    [pool returnElement:self];
}

- (void)removeFomrPool {
    MZPool *pool = self.userData[@"pool"];
    if (pool == nil) return;

    [pool removeElement:self];

    [self.userData removeObjectForKey:@"pool"];
    [self.userData removeObjectForKey:@"poolElementIndex"];
}

@end



#pragma mark - SKNode (MZTouch_Private)

@interface SKNode (MZTouch_Private)
- (void)_runActionWithTouchType:(MZTouchType)touchType touches:(NSSet *)touches event:(UIEvent *)event;
@end

@implementation SKNode (MZTouch)

- (void)addTouchType:(MZTouchType)type touchAction:(MZTouchAction)touchAction {
    if (self.userData == nil) self.userData = [NSMutableDictionary dictionaryWithCapacity:1];
    [self.userData setObject:touchAction forKey:@(type)];
    self.userInteractionEnabled = true;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self _runActionWithTouchType:kMZTouchType_Began touches:touches event:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self _runActionWithTouchType:kMZTouchType_Moved touches:touches event:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self _runActionWithTouchType:kMZTouchType_Ended touches:touches event:event];
}

@end

@implementation SKNode (MZTouch_Private)

- (void)_runActionWithTouchType:(MZTouchType)touchType touches:(NSSet *)touches event:(UIEvent *)event {
    if (self.userData == nil || [self.userData objectForKey:@(touchType)] == nil) return;

    MZTouchAction action = self.userData[@(touchType)];
    action(touches, event);
}

@end



#pragma mark - SKAction(Improve_Sequence)

@implementation SKAction (Improve_Sequence)

+ (SKAction *)sequencePara:(SKAction *)actions, ... {

    NSMutableArray *array = [NSMutableArray new];
    va_list argumentList;
    if (actions) {
        va_start(argumentList, actions);

        id eachObject;
        while ((eachObject = va_arg(argumentList, id))) {
            [array addObject:eachObject];
        }

        va_end(argumentList);
    }

    return [SKAction sequence:array];
}

@end
