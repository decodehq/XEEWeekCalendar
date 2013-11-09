//
//  XEEKit.h
//  XEEKit
//
//  Created by Marko Strizic on 10/23/12.
//  Copyright (c) 2013 XEE Tech. All rights reserved.
//

#import <Foundation/Foundation.h>




#define RASTERIZATION_SCALE [UIScreen mainScreen].scale
#define WINDOW [[[UIApplication sharedApplication] delegate] window]
#define DELEGATE (AppDelegate*)[[UIApplication sharedApplication] delegate]
#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey]
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )
#define IS_IPOD   ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )
#define IS_IPHONE_5 ( IS_IPHONE && IS_WIDESCREEN )

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define W_WIDTH [UIScreen mainScreen].bounds.size.width
#define W_HEIGHT [UIScreen mainScreen].bounds.size.height


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)





@interface XEEKit : NSObject

@end
