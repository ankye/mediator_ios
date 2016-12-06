

#import <Foundation/Foundation.h>
#import "AKLoggerFormatter.h"

@interface AKFileLogger : NSObject

@property (nonatomic, strong, readwrite) DDFileLogger *fileLogger;

SINGLETON_INTR(AKFileLogger)

- (void)configureLogging;

@end
