#import <Foundation/Foundation.h>
#import "MZGameDefines.h"

@interface MZAction : NSObject <MZBehaviour>

@property (nonatomic, readwrite, strong) NSString *name;
@property (nonatomic, readwrite, strong) bool (^isActiveFunc)(void);
@property (nonatomic, readwrite, strong) void (^startAction)(id action);
@property (nonatomic, readwrite, strong) void (^updateAction)(id action);
@property (nonatomic, readwrite, strong) void (^endAction)(id action);
@property (nonatomic, readwrite, strong) void (^deallocAction)(id action);

- (void)start;
- (void)update;
- (void)end;

@end

// 感覺上會快就會需要 enableUpdate 這種東西了(如同 pasue 這項 Action 的意思)

// Hack Issus about passedTime: 為了要達成 passedTime 是從 0.0 開始, 所以 start 裡的 passedTime 初值為負
// 效果:
// 1st frame => passedTime = 0
// 2nd frame => passedTime = 0.033
// 3rd frame => passedTime = 0.066