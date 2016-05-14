//
//  defines.h
//  Lesestudio_15
//
//  Created by Ruedi Heimlicher on 14.05.2016.
//  Copyright © 2016 Ruedi Heimlicher. All rights reserved.
//

#ifndef defines_h
#define defines_h
#ifdef DEBUG
#    define DLog(...) NSLog(__VA_ARGS__)
#else
#    define DLog(...) /* */
#endif
#define ALog(...) NSLog(__VA_ARGS__)


#define SHOWLOG 1


#endif /* defines_h */
