#import <Foundation/Foundation.h>

@interface Person : NSObject
{
    NSString *name;
    float weight;
}

-(Person *)initWithWeight:(float)weight;
@property (retain,readwrite) NSString* name;
@property (readonly) float weight;
@property float height;
-(void)print;
@end
