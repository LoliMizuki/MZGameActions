#import <Foundation/Foundation.h>

@class GameScene;
@class PlayerBulletCreateFuncs;
@class EnemyCreateFuncs;
@class EnemyBulletCreateFuncs;



@interface ActorCreateFuncs : NSObject

@property (nonatomic, readwrite, weak) GameScene *gameScene;
@property (nonatomic, readonly) PlayerBulletCreateFuncs *playerBullet;
@property (nonatomic, readonly) EnemyCreateFuncs *enemy;
@property (nonatomic, readonly) EnemyBulletCreateFuncs *enemyBullet;

+ (instancetype)newWithScene:(GameScene *)gameScene;

@end