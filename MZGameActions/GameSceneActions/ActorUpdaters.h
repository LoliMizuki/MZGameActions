#import <Foundation/Foundation.h>

@class MZActionsGroup;
@class GameScene;



@interface ActorUpdaters : NSObject

@property (nonatomic, readwrite, weak) GameScene *gameScene;
@property (nonatomic, readonly) MZActionsGroup *players;
@property (nonatomic, readonly) MZActionsGroup *playerBullets;
@property (nonatomic, readonly) MZActionsGroup *enemies;
@property (nonatomic, readonly) MZActionsGroup *enemyBullets;

+ (instancetype)newWithGameScene:(GameScene *)gameScene;
- (void)update;
- (void)removeInactiveActors;
- (void)removeAllActors;

@end
