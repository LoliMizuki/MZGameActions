#import "ActorUpdaters.h"
#import "MZGameHeader.h"
#import "GameScene.h"

@interface ActorUpdaters (_)
- (void)_collideWithUpdateA:(MZActionsGroup *)updaterA andUpdaterB:(MZActionsGroup *)updaterB;
- (void)_actionWithCollidersA:(NSArray *)a andB:(NSArray *)b;
@end



@implementation ActorUpdaters

@synthesize gameScene;
@synthesize players, playerBullets, enemies, enemyBullets;

+ (instancetype)newWithGameScene:(GameScene *)gameScene {
    ActorUpdaters *u = [self new];
    return u;
}

- (instancetype)init {
    self = [super init];

    players = [MZActionsGroup new];
    playerBullets = [MZActionsGroup new];
    enemies = [MZActionsGroup new];
    enemyBullets = [MZActionsGroup new];

    return self;
}

- (void)dealloc {
    [self clear];
    gameScene = nil;
}

- (void)update {
    [players update];
    [playerBullets update];
    [enemies update];
    [enemyBullets update];

    [self _collideWithUpdateA:playerBullets andUpdaterB:enemies];
    [self _collideWithUpdateA:enemyBullets andUpdaterB:players];

    [players removeInactives];
    [playerBullets removeInactives];
    [enemies removeInactives];
    [enemyBullets removeInactives];
}

- (void)clear {
    [players clear];
    [playerBullets clear];
    [enemies clear];
    [enemyBullets clear];
}

@end

@implementation ActorUpdaters (_)

- (void)_collideWithUpdateA:(MZActionsGroup *)updaterA andUpdaterB:(MZActionsGroup *)updaterB {
    for (MZActor *actorA in updaterA.updatingAciotns) {
        NSArray *collidersA = [actorA actionsWithClass:[MZSpriteCircleCollider class]];

        for (MZActor *actorB in updaterB.updatingAciotns) {
            NSArray *collidersB = [actorB actionsWithClass:[MZSpriteCircleCollider class]];
            [self _actionWithCollidersA:collidersA andB:collidersB];
        }
    }
}

- (void)_actionWithCollidersA:(NSArray *)a andB:(NSArray *)b {
    for (MZSpriteCircleCollider *ca in a) {
        for (MZSpriteCircleCollider *cb in b) {
            [ca collidesAnother:cb];
        }
    }
}

@end