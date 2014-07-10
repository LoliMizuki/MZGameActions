#import <SpriteKit/SpriteKit.h>
#import "MZSpriteCircleCollider.h"
#import "MZGameHeader.h"

@interface MZSpriteCircleCollider (Private)
- (void)_updateDebugNode;
@end

@implementation MZSpriteCircleCollider {
    SKShapeNode *_debugNode;
}

@synthesize colliderRadius, colliderPosition;
@synthesize collidedAction;

+ (instancetype)newWithSprite:(SKSpriteNode *)sprite offset:(CGPoint)offset collisionScale:(float)collisionScale {
    MZSpriteCircleCollider *collider = [MZSpriteCircleCollider new];
    collider.sprite = sprite;
    collider.offset = offset;
    collider.collisionScale = collisionScale;

    return collider;
}

+ (bool)isColliderA:(MZSpriteCircleCollider *)colliderA collidedB:(MZSpriteCircleCollider *)colliderB {
    float distancePow2 = [MZMath distancePow2FromP1:colliderA.colliderPosition toPoint2:colliderB.colliderPosition];
    float collidedDistancePow2 = pow(colliderA.colliderRadius + colliderB.colliderRadius, 2);

    return distancePow2 <= collidedDistancePow2;
}

- (void)dealloc {
    [_debugNode removeFromParent];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"collider of %@ {pos=%@, rad=%.2f}", self.sprite.name,
                                      NSStringFromCGPoint(self.colliderPosition), self.colliderRadius];
}

- (MZFloat)colliderRadius {
    return self.collisionScale * MIN(self.sprite.xScale, self.sprite.yScale) *
           MIN(self.sprite.texture.size.width / 2, self.sprite.texture.size.height / 2);
}

- (CGPoint)colliderPosition {
    CGPoint offsetByScale = mzp(self.offset.x * self.sprite.xScale, self.offset.y * self.sprite.yScale);
    float resultRotation = self.sprite.zRotation;
    CGPoint resultOffset = [MZMath vectorFromVector:offsetByScale mapToRadians:resultRotation];

    return mzpAdd(self.sprite.position, resultOffset);
}

- (bool)isCollidesAnother:(MZSpriteCircleCollider *)another {
    return [MZSpriteCircleCollider isColliderA:self collidedB:another];
}

- (bool)collidesAnother:(MZSpriteCircleCollider *)another {
    if (![self isCollidesAnother:another]) return false;

    if (self.collidedAction != nil) self.collidedAction(self);
    if (another.collidedAction != nil) another.collidedAction(another);

    return true;
}

- (void)addDebugDrawNodeWithParent:(SKNode *)parent color:(SKColor *)color {
    if (parent == nil) return;

    if (_debugNode != nil) {
        [self removeDebugDrawNode];
    }

    _debugNode = [SKShapeNode node];
    [parent addChild:_debugNode];

    _debugNode.strokeColor = color;
    _debugNode.position = self.colliderPosition;
}

- (void)removeDebugDrawNode {
    if (_debugNode == nil) return;

    [_debugNode removeFromParent];
    _debugNode = nil;
}

- (void)update {
    [self _updateDebugNode];
}

@end

@implementation MZSpriteCircleCollider (Private)

- (void)_updateDebugNode {
    if (_debugNode == nil) return;

    _debugNode.position = self.colliderPosition;

    CGMutablePathRef path = CGPathCreateMutable();

    // frame draw
    //    CGSize halfSize = CGSizeMake(self.sprite.size.width / 2, self.sprite.size.height / 2);
    //    CGPoint pnts[] = {{-halfSize.width, -halfSize.height},
    //                      {-halfSize.width, +halfSize.height},
    //                      {-halfSize.width, -halfSize.height},
    //                      {+halfSize.width, -halfSize.height},
    //                      {+halfSize.width, +halfSize.height},
    //                      {-halfSize.width, +halfSize.height},
    //                      {+halfSize.width, +halfSize.height},
    //                      {+halfSize.width, -halfSize.height}, };
    //    CGPathAddLines(path, nil, pnts, 8);

    CGPathAddArc(path, nil, 0, 0, self.colliderRadius, 0, 2 * M_PI, false);

    _debugNode.path = path;

    CGPathRelease(path);
}

@end
