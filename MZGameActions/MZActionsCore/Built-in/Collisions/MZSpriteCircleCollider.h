// improve notes:
// add callback to handle collision events (if game need collide different part has different handle ... :D)
// radius change with real frame size(in animation, maybe changed violent)

#import <Foundation/Foundation.h>
#import "MZAction.h"

@class SKSpriteNode;
@class SKNode;
@class SKColor;

@interface MZSpriteCircleCollider : MZAction

+ (instancetype)newWithSprite:(SKSpriteNode *)sprite offset:(CGPoint)offset collisionScale:(float)collisionScale;
+ (bool)isColliderA:(MZSpriteCircleCollider *)colliderA collidedB:(MZSpriteCircleCollider *)colliderB;

// setting
@property (nonatomic, readwrite, weak) SKSpriteNode *sprite;
@property (nonatomic, readwrite) CGPoint offset;
@property (nonatomic, readwrite) float collisionScale;

// collider info
@property (nonatomic, readonly) float colliderRadius;
@property (nonatomic, readonly) CGPoint colliderPosition;

- (bool)isCollidesAnother:(MZSpriteCircleCollider *)another;

- (void)addDebugDrawNodeWithParent:(SKNode *)parent color:(SKColor *)color;
- (void)removeDebugDrawNode;


@end
