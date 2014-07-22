#import <Foundation/Foundation.h>

@class SKSpriteNode;
@class GameScene;
@class MZActor;

typedef MZActor * (^ActorGenFunc)(void);



@interface EnemyCreateFuncs : NSObject

@property (nonatomic, readwrite, weak) GameScene *gameScene;

+ (instancetype)newWithScene:(GameScene *)gameScene;

- (ActorGenFunc)funcWithName:(NSString *)name;
- (MZActor *)newEnemyWithHP:(int)hp bodySprite:(SKSpriteNode *)bodySprite;

@end