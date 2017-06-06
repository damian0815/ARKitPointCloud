//
//  PointCloud.h
//  AR_Test
//
//  Created by Damian Stewart on 06/06/2017.
//  Copyright © 2017 ds. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

@interface PointCloud : SCNNode

- (id)init UNAVAILABLE_ATTRIBUTE;
- (id)initWithPointMaterial:(SCNMaterial*)mat;
- (void)updateWithPointCloud:(ARPointCloud*)pc;

@end
