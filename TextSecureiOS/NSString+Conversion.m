//
//  NSString+Conversion.m
//  TextSecureiOS
//
//  Created by Christine Corbett Moran on 3/27/13.
//  Copyright (c) 2013 Open Whisper Systems. All rights reserved.
//

#import "NSString+Conversion.h"

//
//  NSData+Conversion.m
//  TextSecureiOS
//
//  Created by Christine Corbett Moran on 3/26/13.
//  Copyright (c) 2013 Open Whisper Systems. All rights reserved.
//
@implementation NSString (NSString_Conversion)

#pragma mark - Base 64 Conversion
- (NSString *)base64Encoded {
  NSData *theData = [self dataUsingEncoding: NSASCIIStringEncoding];
  const uint8_t* input = (const uint8_t*)[theData bytes];
  NSInteger length = [theData length];
  
  static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
  
  NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
  uint8_t* output = (uint8_t*)data.mutableBytes;
  
  NSInteger i;
  for (i=0; i < length; i += 3) {
    NSInteger value = 0;
    NSInteger j;
    for (j = i; j < (i + 3); j++) {
      value <<= 8;
      
      if (j < length) {
        value |= (0xFF & input[j]);
      }
    }
    
    NSInteger theIndex = (i / 3) * 4;
    output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
    output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
    output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
    output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
  }
  
  return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

-(NSString *) rot13String {
	const char *_string = [self cStringUsingEncoding:NSASCIIStringEncoding];
	int stringLength = [self length];
	char newString[stringLength+1];
	
	int x;
	for( x=0; x<stringLength; x++ ) {
		unsigned int aCharacter = _string[x];
		
		if( 0x40 < aCharacter && aCharacter < 0x5B ) // A - Z
			newString[x] = (((aCharacter - 0x41) + 0x0D) % 0x1A) + 0x41;
		else if( 0x60 < aCharacter && aCharacter < 0x7B ) // a-z
			newString[x] = (((aCharacter - 0x61) + 0x0D) % 0x1A) + 0x61;
		else  // Not an alpha character
			newString[x] = aCharacter;
	}
	newString[x] = '\0';
	NSString *rotString = [NSString stringWithCString:newString encoding:NSASCIIStringEncoding];
	return( rotString );
}

- (NSString *)unformattedPhoneNumber {
  NSCharacterSet *toExclude = [NSCharacterSet characterSetWithCharactersInString:@"/.()- "];
  return [[self componentsSeparatedByCharactersInSet:toExclude] componentsJoinedByString: @""];
}


@end