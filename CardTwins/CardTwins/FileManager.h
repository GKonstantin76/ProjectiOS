//
//  FileManager.h
//  CardTwins
//
//  Created by Константин on 08.07.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileManager : NSObject
- (void) saveToFile:(id)object;
- (id) readFromFile;
- (void) removeFile;
@end
