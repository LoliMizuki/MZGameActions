#import <Foundation/Foundation.h>
#import "MZGameDefines.h"

@interface MZAction : NSObject <MZBehaviour>

@property (nonatomic, readwrite, strong) NSString *name;
@property (nonatomic, readwrite, strong) bool (^isActiveFunc)(void);
@property (nonatomic, readwrite, strong) void (^startAction)(id action);
@property (nonatomic, readwrite, strong) void (^updateAction)(id action);
@property (nonatomic, readwrite, strong) void (^endAction)(id action);

- (void)start;
- (void)update;
- (void)end;

@end

// 感覺上會快就會需要 enableUpdate 這種東西了(如同 pasue 這項 Action 的意思)