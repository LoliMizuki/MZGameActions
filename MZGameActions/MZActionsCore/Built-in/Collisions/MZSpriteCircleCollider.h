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
+ (instancetype)newWithSprite:(SKSpriteNode *)sprite;
+ (bool)isColliderA:(MZSpriteCircleCollider *)colliderA collidedB:(MZSpriteCircleCollider *)colliderB;

// setting
@property (nonatomic, readwrite, weak) SKSpriteNode *sprite;
@property (nonatomic, readwrite) CGPoint offset;
@property (nonatomic, readwrite) MZFloat collisionScale;
@property (nonatomic, readwrite, strong) void (^collidedAction)(id collider);

// collider info
@property (nonatomic, readonly) MZFloat colliderRadius;
@property (nonatomic, readonly) CGPoint colliderPosition;

- (bool)isCollidesAnother:(MZSpriteCircleCollider *)another;
- (bool)collidesAnother:(MZSpriteCircleCollider *)another;

- (void)addDebugDrawNodeWithParent:(SKNode *)parent color:(SKColor *)color;
- (void)removeDebugDrawNode;


@end
