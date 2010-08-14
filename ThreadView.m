//
//  ThreadView.m
//  view test
//
//  Created by Marc Liyanage on 8/11/10.
//

#import "ThreadView.h"


@implementation ThreadView

- (void)awakeFromNib
{
	dispatch_queue_t queue = dispatch_queue_create("drawing", NULL);
	dispatch_async(queue, ^{
		[self drawInBackground];
	});
	[self setCanDrawConcurrently:YES];
}


- (void)drawRect:(NSRect)dirtyRect {
	NSColor *color = rand() % 2 ? [NSColor redColor] : [NSColor blueColor];
	[color set];
	NSRectFill([self bounds]);
	NSThread *thread = [NSThread currentThread];
	NSLog(@"thread %@ main thread %d, concurrently %d", thread, [thread isMainThread], [self canDrawConcurrently]);
}


- (void)drawInBackground
{
	while (1) {
//		[NSThread sleepForTimeInterval:0.1];
		if (![self lockFocusIfCanDraw]) {
			NSLog(@"no can draw");
			continue;
		}
		NSColor *color = rand() % 2 ? [NSColor greenColor] : [NSColor yellowColor];
		[color set];
		NSRect bounds = [self bounds];
		CGFloat x = rand() % (int)NSWidth(bounds);
		CGFloat y = rand() % (int)NSHeight(bounds);
		CGFloat w = rand() % (int)NSWidth(bounds) - x;
		CGFloat h = rand() % (int)NSHeight(bounds) - y;
		NSRectFill(NSMakeRect(x, y, w, h));
		[self unlockFocus];
		[[[self window] graphicsContext] flushGraphics];
	}
}

@end
