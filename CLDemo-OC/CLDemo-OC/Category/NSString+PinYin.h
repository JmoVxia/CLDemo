#import <Foundation/Foundation.h>

@interface NSString (PinYin)


/**
 获取首字母

 @return 首字母
 */
- (NSString *)getFirstLetter;

//MARK:JmoVxia---新增加方法

/*
 *  获取字符串排序的首字母  如 史蒂夫 -> sdf
 *                         曾国藩 -> zgf
 *                         史蒂夫·乔布斯 -> sdfqbs
 *                         沈从wen -> scwen
 *                         Jobs  -> Jobs
 *                         D.J   -> D.J(不作姓名的转换结果)
 *                         I'm  -> I'm
 *
 *  @param isForSurname 标记字符串是否为姓氏，如果为姓氏将使用姓氏对应的拼音首字母且将去掉姓名中的“·”符号（部分姓氏为多音字，发音独特，如曾、单等）
 *
 *  @return 返回字符串的未处理大小写，汉字系统转拼音默认小写，取每个汉字的拼音首字母，如果字符串本身非汉字则保持不变，如英文字母或字符等
 */
- (NSString*)firstLettersForSort:(BOOL)isForSurname;

/*
 *  获取字符串排序的无音调拼音    如 史蒂夫 -> shi di fu
 *                              曾国藩 -> zeng guo fan
 *                              史蒂夫·乔布斯 -> shi di fu qiao bu si
 *                              沈从wen -> shen congwen
 *                              Jobs  -> Jobs
 *                              D.J   -> D.J(不作姓名的转换结果)
 *                              I'm  -> I'm
 *
 *  @param isForSurname 标记字符串是否为姓氏，如果为姓氏将使用姓氏对应的拼音且将替换掉姓名中的“·”符号为“ ”（部分姓氏为多音字，发音独特，如曾、单等）
 *
 *  @return 返回字符串的未处理大小写，汉字系统转拼音默认小写，取每个汉字的拼音，如果字符串本身非汉字则保持不变，如英文字母或字符等
 */
- (NSString*)pinyinForSort:(BOOL)isForSurname;

/*
 *  获取字符串排序的有音调拼音    如 史蒂夫 -> shǐ dì fu
 *                              曾国藩 -> zēng guó fān
 *                              史蒂夫·乔布斯 -> shǐ dì fu qiáo bù sī
 *                              沈从wen -> shěn cóngwen
 *                              Jobs  -> Jobs
 *                              D.J   -> D.J(不作姓名的转换结果)
 *                              I'm  -> I'm
 *
 *  @param isForSurname 标记字符串是否为姓氏，如果为姓氏将使用姓氏对应的拼音且将替换掉姓名中的“·”符号为“ ”（部分姓氏为多音字，发音独特，如曾、单等）
 *
 *  @return 返回字符串的未处理大小写，汉字系统转拼音默认小写，取每个汉字的拼音，如果字符串本身非汉字则保持不变，如英文字母或字符等
 */
- (NSString*)pinyinWithToneForSort:(BOOL)isForSurname;


/*
 *   【效率比较】
 *        iPhone6s firstLettersForSort/pinyinForSort/pinyinWithToneForSort几乎没有差别
 *        iPhone5s及iPhone4 firstLettersForSort处理汉字字符串时较快；pinyinForSort/pinyinWithToneForSort处理非汉字字符串时较快
 */


@end

@interface NSArray (PinYin)

- (NSArray *)arrayWithPinYinFirstLetterFormat;

@end
