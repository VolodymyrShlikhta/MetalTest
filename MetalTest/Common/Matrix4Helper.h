//
//  Matrix4Helper.h
//  MetalTest
//
//  Created by Volodymyr Shlikhta on 24/4/18.
//  Copyright © 2018 Volodymyr Shlikhta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GLKit/GLKMath.h>

// Wraper around GLKMath's GLKMatrix4, because we can't use it directly from Swift code

@interface Matrix4Helper : NSObject{
@public
    GLKMatrix4 glkMatrix;
}

+ (Matrix4Helper * _Nonnull)makePerspectiveViewAngle:(float)angleRad
                                   aspectRatio:(float)aspect
                                         nearZ:(float)nearZ
                                          farZ:(float)farZ;

- (_Nonnull instancetype)init;
- (_Nonnull instancetype)copy;


- (void)scale:(float)x y:(float)y z:(float)z;
- (void)rotateAroundX:(float)xAngleRad y:(float)yAngleRad z:(float)zAngleRad;
- (void)translate:(float)x y:(float)y z:(float)z;
- (void)multiplyLeft:(Matrix4Helper * _Nonnull)matrix;


- (void * _Nonnull)raw;
- (void)transpose;

+ (float)degreesToRad:(float)degrees;
+ (NSInteger)numberOfElements;

@end
