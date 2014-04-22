/*
 The MIT License
 
 Copyright (c) 2009 Free Time Studios and Nathan Eror
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

/**
 A collection of macros used throughout the FTUtils set of tools.
 
 This file need not be included directly since it's included by the other 
 pieces of the library. The macros are useful throughout a project, and 
 it's recommended that you just include the file in your prefix header.
*/

#pragma mark - Version

static const NSUInteger FTUtilsVersion = 010100;
static NSString *const FTUtilsVersionString = @"1.1.0";

#pragma mark - Logging
///---------------------------------------------------------------------------
/// @name Logging Messages to the Console
///---------------------------------------------------------------------------

// FTLOGEXT logging macro from: http://iphoneincubator.com/blog/debugging/the-evolution-of-a-replacement-for-nslog
#ifdef DEBUG

/**
 A simple wrapper for `NSLog()` that is automatically removed from release builds.
*/
#define FTLOG(...) NSLog(__VA_ARGS__)

/**
 More detailed loogging. Logs the function name and line number after the log message.
*/
#define FTLOGEXT(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

/**
 Logs a method call's class and selector.
*/
#define FTLOGCALL FTLOG(@"[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd))

#else
#define FTLOG(...) /* */
#define FTLOGEXT(...) /* */
#define FTLOGCALL /* */
#endif

#pragma mark - Memory Management
///---------------------------------------------------------------------------
/// @name Memory Management
///---------------------------------------------------------------------------

/**
 Safely release an objective-c object and set its variable to `nil`.
*/
#define FTRELEASE(_obj) [_obj release], _obj = nil

/**
 Safely free a pointer and set its variable to `NULL`.
*/
#define FTFREE(_ptr) if(_ptr != NULL) { free(_ptr); _ptr = NULL; }

#pragma mark - Math
///---------------------------------------------------------------------------
/// @name Math Helpers
///---------------------------------------------------------------------------

/** Convert from degrees to radians */
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)

/** Convert from radians to degrees */
#define RADIANS_TO_DEGREES(r) (r * 180 / M_PI)

#pragma mark - Colors
///---------------------------------------------------------------------------
/// @name Creating colors
///---------------------------------------------------------------------------

/**
 Create a UIColor with r,g,b values between 0.0 and 1.0.
*/
#define RGBCOLOR(r,g,b) \
[UIColor colorWithRed:r/256.f green:g/256.f blue:b/256.f alpha:1.f]

/**
 Create a UIColor with r,g,b,a values between 0.0 and 1.0.
*/
#define RGBACOLOR(r,g,b,a) \
[UIColor colorWithRed:r/256.f green:g/256.f blue:b/256.f alpha:a]

/**
 Create a UIColor from a hex value.
 
 For example, `UIColorFromRGB(0xFF0000)` creates a `UIColor` object representing
 the color red.
*/
#define UIColorFromRGB(rgbValue) \
[UIColor \
  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
         green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
          blue:((float)(rgbValue & 0x0000FF))/255.0 \
         alpha:1.0]

/**
 Create a UIColor with an alpha value from a hex value.
 
 For example, `UIColorFromRGBA(0xFF0000, .5)` creates a `UIColor` object 
 representing a half-transparent red. 
*/
#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor \
  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
         green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
          blue:((float)(rgbValue & 0x0000FF))/255.0 \
         alpha:alphaValue]

#pragma mark - Delegates
///---------------------------------------------------------------------------
/// @name Calling Delegates
///---------------------------------------------------------------------------

/**
 Call a delegate method if the selector exists.
*/
#define FT_CALL_DELEGATE(_delegate, _selector) \
do { \
  id _theDelegate = _delegate; \
  if(_theDelegate != nil && [_theDelegate respondsToSelector:_selector]) { \
    [_theDelegate performSelector:_selector]; \
  } \
} while(0);

/**
 Call a delegate method that accepts one argument if the selector exists.
*/
#define FT_CALL_DELEGATE_WITH_ARG(_delegate, _selector, _argument) \
do { \
  id _theDelegate = _delegate; \
  if(_theDelegate != nil && [_theDelegate respondsToSelector:_selector]) { \
    [_theDelegate performSelector:_selector withObject:_argument]; \
  } \
} while(0);

/**
 Call a delegate method that accepts two arguments if the selector exists.
*/
#define FT_CALL_DELEGATE_WITH_ARGS(_delegate, _selector, _arg1, _arg2) \
do { \
  id _theDelegate = _delegate; \
  if(_theDelegate != nil && [_theDelegate respondsToSelector:_selector]) { \
    [_theDelegate performSelector:_selector withObject:_arg1 withObject:_arg2]; \
  } \
} while(0);

#pragma mark - File System
///---------------------------------------------------------------------------
/// @name Working with the filesystem
///---------------------------------------------------------------------------

/**
 Get the full path for a file name in the documents directory.

 @param filename the name of the file _(the file need not exist yet)_.
 @return The full path to the filename.
*/
static inline NSString *FTPathForFileInDocumentsDirectory(NSString *filename) {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
  return path;
}

#pragma mark - Core Data
///---------------------------------------------------------------------------
/// @name Working with the Core Data
///---------------------------------------------------------------------------

/**
 Save a Core Data `NSManagedObjectContext` and pretty print any errors.
*/
#define FT_SAVE_MOC(_ft_moc) \
do { \
  NSError* _ft_save_error; \
  if(![_ft_moc save:&_ft_save_error]) { \
    FTLOG(@"Failed to save to data store: %@", [_ft_save_error localizedDescription]); \
    NSArray* _ft_detailedErrors = [[_ft_save_error userInfo] objectForKey:NSDetailedErrorsKey]; \
    if(_ft_detailedErrors != nil && [_ft_detailedErrors count] > 0) { \
      for(NSError* _ft_detailedError in _ft_detailedErrors) { \
        FTLOG(@"DetailedError: %@", [_ft_detailedError userInfo]); \
      } \
    } \
    else { \
      FTLOG(@"%@", [_ft_save_error userInfo]); \
    } \
  } \
} while(0);
