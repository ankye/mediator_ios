//
//  LoggerModule.h
//  Project
//
//  Created by ankye on 2016/12/6.
//  Copyright © 2016年 ankye. All rights reserved.
//

#ifndef LoggerModule_h
#define LoggerModule_h

// Disable legacy macros
#ifndef DD_LEGACY_MACROS
#define DD_LEGACY_MACROS 1
#endif

// Core
#import "DDLog.h"

// Main macros
#import "DDLogMacros.h"
#import "DDAssertMacros.h"

// Capture ASL
#import "DDASLLogCapture.h"

// Loggers
#import "DDTTYLogger.h"
#import "DDASLLogger.h"
#import "DDFileLogger.h"


#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


#import "AKFileLogger.h"

#endif /* LoggerModule_h */
