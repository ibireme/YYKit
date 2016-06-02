//  Copyright (c) 2013 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

CF_EXTERN_C_BEGIN

/*!
 \brief         The Reveal Log level bit flags.
 \discussion    These flags are additive.  i.e. you should bitwise OR them together.  

 \seealso       IBARevealLoggerSetLevelMask
 \seealso       IBARevealLoggerGetLevelMask
 
    Example:
 
    // Enable Error, Warning and Info logger levels.
    IBARevealLoggerSetLevelMask(IBARevealLogLevelError|IBARevealLogLevelWarn|IBARevealLogLevelInfo);
 
 */
typedef NS_OPTIONS(int32_t, IBARevealLogLevel)
{
    IBARevealLogLevelNone  = 0,
    IBARevealLogLevelDebug = (1 << 0),
    IBARevealLogLevelInfo  = (1 << 1),
    IBARevealLogLevelWarn  = (1 << 2),
    IBARevealLogLevelError = (1 << 3)
};

/*!
 \brief         Set the Reveal logger level mask.
 \param         mask    A bit mask which is a combination of the IBARevealLogLevel enum options.
 
 \discussion    If you do not wish to see log messages from Reveal you should call this function with an appropriate level mask as early in your application's lifecycle as possible. For example in your application's main() function.
 
        Example:
 
        // Enable Error, Warning and Info logger levels.
        IBARevealLoggerSetLevelMask(IBARevealLogLevelError|IBARevealLogLevelWarn|IBARevealLogLevelInfo);
 
 */
CF_EXPORT void IBARevealLoggerSetLevelMask(int32_t mask);

/*!
 \brief         Get the current Reveal logger level mask.
 \return        A bit mask representing the levels at which Reveal is currently logging.
 \discussion    The default Reveal Logger level mask is IBARevealLogLevelError|IBARevealLogLevelWarn|IBARevealLogLevelInfo.
 
        Example:
 
        // Turn off the Info log level.
        IBARevealLoggerSetLevelMask(IBARevealLoggerGetLevelMask() & ~IBARevealLogLevelInfo);
 
 */
CF_EXPORT int32_t IBARevealLoggerGetLevelMask(void);

CF_EXTERN_C_END
