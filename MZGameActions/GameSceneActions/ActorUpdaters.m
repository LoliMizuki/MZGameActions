#import "ActorUpdaters.h"
#import "MZGameHeader.h"
#import "GameScene.h"

@interface ActorUpdaters (_)
- (void)_collideWithUpdateA:(MZActionsGroup *)updaterA andUpdaterB:(MZActionsGroup *)updaterB;
@end



@implementation ActorUpdaters

@synthesize gameScene;
@synthesize playersUpdater, playerBulletsUpdater, enemiesUpdater, enemyBulletsUpdater;

+ (instancetype)newWithGameScene:(GameScene *)gameScene {
    ActorUpdaters *u = [self new];
    return u;
}

- (instancetype)init {
    self = [super init];

    playersUpdater = [MZActionsGroup new];
    playerBulletsUpdater = [MZActionsGroup new];
    enemiesUpdater = [MZActionsGroup new];
    enemyBulletsUpdater = [MZActionsGroup new];

    return self;
}

- (void)dealloc {
    [self clear];
    gameScene = nil;
}

- (void)update {
    [playersUpdater update];
    [playerBulletsUpdater update];
    [enemiesUpdater update];
    [enemyBulletsUpdater update];

    [self _collideWithUpdateA:playerBulletsUpdater andUpdaterB:enemiesUpdater];
    [self _collideWithUpdateA:enemyBulletsUpdater andUpdaterB:playersUpdater];

    [playersUpdater removeInactives];
    [playerBulletsUpdater removeInactives];
    [enemiesUpdater removeInactives];
    [enemyBulletsUpdater removeInactives];
}

- (void)clear {
    [playersUpdater clear];
    [playerBulletsUpdater clear];
    [enemiesUpdater clear];
    [enemyBulletsUpdater clear];
}

@end

@implementation ActorUpdaters (_)

- (void)_collideWithUpdateA:(MZActionsGroup *)updaterA andUpdaterB:(MZActionsGroup *)updaterB {
    for (MZActor *actorA in updaterA.updatingAciotns) {
        MZSpriteCircleCollider *actorACollider = [actorA actionWithName:@"collider"];

        for (MZActor *actorB in updaterB.updatingAciotns) {
            MZSpriteCircleCollider *actorBCollider = [actorB actionWithName:@"collider"];

            [actorACollider collidesAnother:actorBCollider];
        }
    }
}

@end