//
//  BaseModel.h
//  ZhiYou
//


#import <Foundation/Foundation.h>

@interface BaseModel : NSObject <NSCoding>


@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *nextFirstRow;


-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData *)getArchivedData;

- (NSString *)cleanString:(NSString *)str;    //清除\n和\r的字符串

@end
