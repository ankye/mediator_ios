

#import "NSString+Tools.h"


@implementation NSString (Tools)

- (BOOL)startWithSubString:(NSString *)subString{
    if (!subString) {
        return NO;
    }
    
    NSRange range = [self rangeOfString:subString];
    if (range.location != NSNotFound && range.length > 0) {
        return YES;
    }
    
    return NO;
}



- (NSString *)uppercaseCapitalString{
    if (self) {
        NSString *string = [NSString stringWithFormat:@"%@%@", [[self substringWithRange:NSMakeRange(0, 1)] uppercaseString], [self substringWithRange:NSMakeRange(1, self.length - 1)]];
        return string;
    }
    
    return self;
}

@end
