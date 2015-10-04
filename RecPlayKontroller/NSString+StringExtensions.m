//
//  NSString+StringExtensions.m
//  Lesestudio_15
//
//  Created by Ruedi Heimlicher on 04.10.2015.
//  Copyright © 2015 Ruedi Heimlicher. All rights reserved.
//

#import "NSString+StringExtensions.h"

@implementation NSString (StringExtensions)

- (NSString*)pfadOhneExtension
{
   NSSet* extensionSet = [NSSet setWithObjects:@"m4a",@"mp3",@"txt",@"doc",nil];
   if ([extensionSet containsObject:[self pathExtension]]) // verirrte extension oder punkt im titel
   {
      return [self stringByDeletingPathExtension];
   }
   return self;
}


@end
