#import "TestScenario.h"
#import "GameScene.h"
#import "PlayerBulletCreateFuncs.h"
#import "EnemyCreateFuncs.h"
#import "EnemyBulletCreateFuncs.h"
#import "ActorUpdaters.h"
#import "ActorCreateFuncs.h"
#import "MZGameHeader.h"

@interface TestScenario (_)
- (void)_addAtTime:(MZFloat)time formation:(MZFormation *)formation;
- (void)_addF1AtTime:(MZFloat)time;
- (void)_addCannonAtTime:(MZFloat)time;
- (void)_addSimpleAt:(double)time;
- (void)_addMotherShipAtTime:(MZFloat)time;
- (void)_addRepeaterAtTime:(MZFloat)time;
@end



@implementation TestScenario

@synthesize gameScene;

+ (instancetype)newWithGameScene:(GameScene *)gameScene {
    TestScenario *p = [TestScenario new];
    p.gameScene = gameScene;

    return p;
}

- (void)setScenario {
    [self _addF1AtTime:2];
    [self _addCannonAtTime:5];
    [self _addSimpleAt:8];
    [self _addMotherShipAtTime:15];
    [self _addRepeaterAtTime:20];
}

@end

@implementation TestScenario (_)

- (void)_addAtTime:(MZFloat)time formation:(MZFormation *)formation {
    [gameScene.eventsExecutor
        addActionLate:[MZActionsSequence newWithActions:@[ [MZWait newWithDuration:time], formation ]]];
}

- (void)_addF1AtTime:(MZFloat)time {
    MZFormation *f1 = [MZFormation new];
    f1.newActorFunc = [gameScene.actorCreateFuncs.enemy funcWithName:@"the-one"];
    [f1 addSpawnPositions:@[
                             NSValueFromCGPoint(mzpAdd(gameScene.center, mzp(100, 200))),
                             NSValueFromCGPoint(mzpAdd(gameScene.center, mzp(-100, 200))),
                          ]];
    f1.maxSpawnCount = 10;
    f1.interval = 0.5;

    f1.setActionToActorWhenSpawn = ^(MZFormation *f, MZActor *actor) {
        if (f.currentSpawnCount % 2 == 0) return;
        MZMoveTurnFromTo *m = [actor actionWithName:@"move"];
        m.fromDirection = 0;
    };

    [self _addAtTime:time formation:f1];
}

- (void)_addCannonAtTime:(MZFloat)time {
    MZFormation *cannonFormation = [MZFormation new];
    cannonFormation.newActorFunc = [gameScene.actorCreateFuncs.enemy funcWithName:@"the-cannons"];
    [cannonFormation addSpawnPositions:@[ NSValueFromCGPoint(gameScene.center) ]];
    cannonFormation.maxSpawnCount = 1;

    [self _addAtTime:time formation:cannonFormation];
}

- (void)_addSimpleAt:(double)time {
    MZFormation *fs = [MZFormation new];
    fs.newActorFunc = [gameScene.actorCreateFuncs.enemy funcWithName:@"the-simple"];
    [fs addSpawnPositions:@[ NSValueFromCGPoint(mzpAdd(gameScene.center, mzp(0, 200))) ]];
    fs.maxSpawnCount = 1;
    [self _addAtTime:6 formation:fs];
}

- (void)_addMotherShipAtTime:(MZFloat)time {
    MZFormation *motherShipFormation = [MZFormation new];
    motherShipFormation.newActorFunc = [gameScene.actorCreateFuncs.enemy funcWithName:@"the-mother"];
    [motherShipFormation addSpawnPositions:@[ NSValueFromCGPoint(gameScene.center) ]];
    motherShipFormation.maxSpawnCount = 1;

    [self _addAtTime:time formation:motherShipFormation];
}

- (void)_addRepeaterAtTime:(MZFloat)time {
    MZFormation *repeatFormation = [MZFormation new];
    repeatFormation.newActorFunc = [gameScene.actorCreateFuncs.enemy funcWithName:@"the-repeater"];
    [repeatFormation addSpawnPositions:@[ NSValueFromCGPoint(gameScene.center) ]];
    repeatFormation.maxSpawnCount = 1;

    [self _addAtTime:time formation:repeatFormation];
}

@end
