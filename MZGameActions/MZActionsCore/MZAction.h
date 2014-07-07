#import <Foundation/Foundation.h>
#import "MZGameDefines.h"

@interface MZAction : NSObject <MZBehaviour>

@property (nonatomic, readwrite, strong) NSString *name;
@property (nonatomic, readwrite, strong) bool (^isActiveFunc)();
@property (nonatomic, readwrite, strong) void (^startAction)(id action);
@property (nonatomic, readwrite, strong) void (^updateAction)(id action);
@property (nonatomic, readwrite, strong) void (^endAction)(id action);

- (void)start;
- (void)update;
- (void)end;

@end
