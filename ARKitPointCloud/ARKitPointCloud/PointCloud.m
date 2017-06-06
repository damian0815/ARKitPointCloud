//
//  ARPointCloud.m
//  AR_Test
//
//  Created by Damian Stewart on 06/06/2017.
//  Copyright © 2017 ds. All rights reserved.
//

#import "PointCloud.h"
#import <SceneKit/SceneKit.h>

@interface PointCloud()

@property (strong, readwrite, atomic) SCNMaterial* pointMaterial;
@property (strong, readwrite, atomic) NSMutableArray* points;
@property (strong, readwrite, atomic) NSMutableArray* sleepingPoints;

@end

@implementation PointCloud

- (id)initWithPointMaterial:(SCNMaterial *)mat
{
	if (self = [super init]) {
		self.pointMaterial = mat;
		self.points = [NSMutableArray array];
		self.sleepingPoints = [NSMutableArray array];
	}
	return self;
}

- (void)updateWithPointCloud:(ARPointCloud*)pc
{
	//NSLog(@"Updating with %i points...", pc.count);
	[self putPointsToSleep:[self.points copy]];
	
	for (int i=0; i<pc.count; i++) {
		vector_float3 v = pc.points[i];
		SCNNode* n = [self wakePoint];
		n.position = SCNVector3FromFloat3(v);
	}
}

- (void)putPointsToSleep:(NSArray*)points
{
	[points enumerateObjectsUsingBlock:^(SCNNode* obj, NSUInteger idx, BOOL * _Nonnull stop) {
		obj.hidden = YES;
	}];
	[self.sleepingPoints addObjectsFromArray:points];
	[self.points removeObjectsInArray:points];
	
}

SCNNode* createPoint(SCNMaterial* mat)
{
	SCNGeometry* sphere = [SCNSphere sphereWithRadius:0.003];
	sphere.firstMaterial = mat;
	SCNNode* pt = [SCNNode nodeWithGeometry:sphere];
	return pt;
}

- (SCNNode*)wakePoint
{
	if ([self.sleepingPoints count] == 0) {
		SCNNode* pt = createPoint(self.pointMaterial);
		pt.hidden = YES;
		[self addChildNode:pt];
		[self.sleepingPoints addObject:pt];
	}
	
	SCNNode* point = [self.sleepingPoints lastObject];
	[self.sleepingPoints removeLastObject];
	[self.points addObject:point];
	point.hidden = NO;
	return point;
	
	
}

@end
