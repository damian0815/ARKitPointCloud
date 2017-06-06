//
//  PlaneNode.m
//  AR_Test
//
//  Created by Damian Stewart on 06/06/2017.
//  Copyright © 2017 ds. All rights reserved.
//

#import "PlaneNode.h"

@interface PlaneNode()

@property (strong, readwrite, atomic) SCNNode* shapeNode;

@end

@implementation PlaneNode

- (id)initWithMaterial:(SCNMaterial*)mat
{
	if (self = [super init]) {
		
		CGFloat d = .001;
		UIBezierPath* path = [UIBezierPath bezierPathWithRect:CGRectMake(-0.5, -0.5, 1, 1)];
		SCNShape* anchorGeom = [SCNShape shapeWithPath:path extrusionDepth:d];
		[anchorGeom setFirstMaterial:mat];
		self.shapeNode = [SCNNode nodeWithGeometry:anchorGeom];
		
		[self addChildNode:self.shapeNode];
	}
	return self;
}

- (void)updateShapeNodeWithAnchor:(ARPlaneAnchor*)plane
{
	CGFloat w = [plane extent].x;
	CGFloat h = [plane extent].z;
	self.shapeNode.position = SCNVector3FromFloat3(plane.center);
	self.shapeNode.scale = SCNVector3Make(w, 1, h);
	self.shapeNode.rotation = SCNVector4Make(1, 0, 0, M_PI_2);
	self.transform = SCNMatrix4FromMat4(plane.transform);
}

@end
