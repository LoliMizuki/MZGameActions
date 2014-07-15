#import "MZAction.h"

@class MZActor;

@interface MZFormation : MZAction

@property (nonatomic, readwrite, weak) MZActor * (^createFunc)(void);
@property (nonatomic, readwrite) NSUInteger maxSpawnCount;
@property (nonatomic, readwrite) MZFloat interval;
@property (nonatomic, readwrite) MZFloat delay;
@property (nonatomic, readwrite, strong) void (^setActionToActorWhenSpawn)(id formation, MZActor *actor);

@property (nonatomic, readonly) NSUInteger currentSpawnCount;

- (void)addSpawnPositions:(NSArray *)spawnPositions;

- (void)setActionToActorWhenSpawn:(MZActor *)actor; // if setActionToActorWhenSpawn not nil, do this.

@end
