#import <SpriteKit/SpriteKit.h>
#import "MZSpriteCircleCollider.h"
#import "MZGameHeader.h"

@interface MZSpriteCircleCollider (Private)
- (void)_updateDebugNode;
@end

#pragma mark -

@implementation MZSpriteCircleCollider {
    SKShapeNode *_debugNode;
}

#pragma mark - init and dealloc

+ (instancetype)newWithSprite:(SKSpriteNode *)sprite offset:(CGPoint)offset collisionScale:(float)collisionScale {
    MZSpriteCircleCollider *collider = [MZSpriteCircleCollider new];
    collider.sprite = sprite;
    collider.offset = offset;
    collider.collisionScale = collisionScale;

    return collider;
}

- (void)dealloc {
    [_debugNode removeFromParent];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"collider of %@ {pos=%@, rad=%.2f}", self.sprite.name,
                                      NSStringFromCGPoint(self.colliderPosition), self.colliderRadius];
}

#pragma mark - properties

@synthesize colliderRadius;
@synthesize colliderPosition;

- (float)colliderRadius {
    return self.collisionScale * MIN(self.sprite.xScale, self.sprite.yScale) *
           MIN(self.sprite.texture.size.width / 2, self.sprite.texture.size.height / 2);
}

- (CGPoint)colliderPosition {
    CGPoint offsetByScale = mzp(self.offset.x * self.sprite.xScale, self.offset.y * self.sprite.yScale);
    float resultRotation = self.sprite.zRotation;
    CGPoint resultOffset = [MZMath vectorFromVector:offsetByScale mapToRadians:resultRotation];

    return mzpAdd(self.sprite.position, resultOffset);
}

#pragma mark - methods

+ (bool)isColliderA:(MZSpriteCircleCollider *)colliderA collidedB:(MZSpriteCircleCollider *)colliderB {
    float distancePow2 = [MZMath distancePow2FromP1:colliderA.colliderPosition toPoint2:colliderB.colliderPosition];
    float collidedDistancePow2 = pow(colliderA.colliderRadius + colliderB.colliderRadius, 2);

    return distancePow2 <= collidedDistancePow2;
}

- (bool)isCollidesAnother:(MZSpriteCircleCollider *)another {
    return [MZSpriteCircleCollider isColliderA:self collidedB:another];
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

#pragma mark -

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
