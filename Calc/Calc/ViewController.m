//
//  ViewController.m
//  Calc
//
//  Created by Константин on 29.04.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    IBOutlet UITextField *tfExpression;
    IBOutlet UILabel *lblResult;
}
@end
//-5*6+(-30/4.6)*2.2 = -44.34
@implementation ViewController

- (IBAction) didSelectEvaluateButton:(id)sender {
    NSString *str = tfExpression.text;
    NSString *pstr = @"";
    //NSArray *substring = [str componentsSeparatedByString:@" "];
    NSInteger pos = [self getPosString:str lastSymbol:@"("];
    if (pos != NSNotFound) {
        // если найден ищем закрывающую скобку и возвращаем часть выражения
        pstr = [self getPartString:str pos:pos firstSymbol:')'];
    } 
// проверяем наличие скобок
    while (pos != NSNotFound && ![pstr isEqual:@""]) {
        NSString *ch = [self calcStr:pstr];
        // выполняем замену выражения скобок числом ch
        str = [self replaceString:str start:pos replace:ch];
        pos = [self getPosString:str lastSymbol:@"("];
        if (pos != NSNotFound) {
            pstr = [self getPartString:str pos:pos firstSymbol:')'];
        }
    }
// вычисляем выражение без скобок
    str = [self calcStr:str];
    lblResult.text = str;
}
// замена выражения в скобках числом
-(NSString*) replaceString:(NSString*)str start:(NSInteger)sPos replace:(NSString*)strReplace {
    int lenStr = (int)str.length;
    NSString *nstrFirst = @"";
    NSString *nstrSecond = @"";
    BOOL b = FALSE;
    for (int i = 0; i < lenStr; i ++) {
        if (i < sPos) {
            NSString *ts = [NSString stringWithFormat:@"%c", [str characterAtIndex:i]];
            nstrFirst = [nstrFirst stringByAppendingString:ts];
        } else if (b) {
            NSString *ts = [NSString stringWithFormat:@"%c", [str characterAtIndex:i]];
            nstrSecond = [nstrSecond stringByAppendingString:ts];
        } else if ([str characterAtIndex:i] == ')') {
            b = TRUE;
        }
    }
    NSString *allStr = [nstrFirst stringByAppendingString:strReplace];
    allStr = [allStr stringByAppendingString:nstrSecond];
    return allStr;
}
// определение выражения в скобках
-(NSString*) getPartString:(NSString*)str pos:(NSInteger)pos firstSymbol:(char)symbol {
    NSInteger lenStr = str.length;
    NSString *pstr = @"";
    for (int i = (int)pos + 1; i < (int)lenStr; i ++) {
        char element = [str characterAtIndex:i];
        if (element == symbol) {
            break;
        } else {
            NSString *ts = [NSString stringWithFormat:@"%c", element];
            pstr = [pstr stringByAppendingString:ts];
        }
    }
    return pstr;
}
// вычисление позиции последней закрывающей скобки
-(NSUInteger) getPosString:(NSString*)str lastSymbol:(NSString*)symbol {
    NSRange range = [str rangeOfString:symbol options:NSBackwardsSearch];
    NSInteger pos = NSNotFound;
    if (range.location != NSNotFound) {
        pos = range.location;
    }    
    return pos;
}
// вычисление выражения
-(NSString*) calcStr: (NSString*) str {
    NSMutableArray *newsubstrings = [self explodeArray:str];
    while ([newsubstrings count] > 1) {
        NSInteger dividerPos = [newsubstrings indexOfObject:@"/"];
        NSInteger multiplierPos = [newsubstrings indexOfObject:@"*"];
        if (dividerPos == NSNotFound && multiplierPos == NSNotFound) {
            NSInteger additionPos = [newsubstrings indexOfObject:@"+"];
            NSInteger subtractionPos = [newsubstrings indexOfObject:@"-"];
            if (additionPos < subtractionPos) {
                // сложение
                [self calculationArray:newsubstrings pos:additionPos operator:'+'];
            } else {
                // вычитание
                [self calculationArray:newsubstrings pos:subtractionPos operator:'-'];
            }
        } else {
            if (dividerPos < multiplierPos) {
                // деление
                [self calculationArray:newsubstrings pos:dividerPos operator:'/'];
            } else {
                // умножение
                [self calculationArray:newsubstrings pos:multiplierPos operator:'*'];
            }
        }
    }
    return [newsubstrings objectAtIndex:0];
}
// приведение строки к массиву
-(NSMutableArray*) explodeArray:(NSString*)str {
    NSMutableArray *newarray = [[NSMutableArray alloc]init];
    NSInteger lenStr = str.length;
    NSString *curZn = @"";
    for (int i = 0; i < (int)lenStr; i ++) {
        char element = [str characterAtIndex:i];
        if (element == '+' || (element == '-' && ![curZn isEqual: @""]) || element == '*' || element == '/') {
            if (![curZn  isEqual: @""]) {
                [newarray addObject:[NSString stringWithFormat:@"%@", curZn]];
                curZn = @"";
            }
            [newarray addObject:[NSString stringWithFormat:@"%c", element]];
        } else {
            NSString *ts = [NSString stringWithFormat:@"%c", element];
            curZn = [curZn stringByAppendingString:ts];
        }
    }
    if (![curZn  isEqual: @""]) {
        [newarray addObject:curZn];
    }
    return newarray;
}
// вычисление двух операндов одним из 4-х действий
-(void) calculationArray:(NSMutableArray*)array pos:(NSUInteger)pos operator:(char)op {
    NSString *str1 = [array objectAtIndex:(pos - 1)];
    CGFloat val1 = [str1 floatValue];
    NSString *str2 = [array objectAtIndex:(pos + 1)];
    CGFloat val2 = [str2 floatValue];
    CGFloat res = 0;
    switch (op) {
        case '/':
            res = val1/val2;
            break;
        case '*':
            res = val1*val2;
            break;
        case '+':
            res = val1+val2;
            break;
        case '-':
            res = val1-val2;
            break;
    }
    NSString *resultString = [NSString stringWithFormat:@"%.2f", res];
    array[pos - 1] = resultString;
    [array removeObjectAtIndex:pos + 1];
    [array removeObjectAtIndex:pos];
}
@end
