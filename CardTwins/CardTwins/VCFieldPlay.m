//
//  VCFieldPlay.m
//  CardTwins
//
//  Created by asp on 6/19/15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import "VCFieldPlay.h"
#import "CardView.h"
#import "VCCongraulations.h"

@interface VCFieldPlay() <protocolCard> {
    NSUInteger cntCard;
    NSUInteger step;
    NSMutableArray *mTexture;
    NSUInteger cntX;
    NSUInteger cntY;
    VCCongraulations *vccobCongratuations;
    NSTimer *timerPlay;
    //NSDate *dateStart;
}
@property (nonatomic, copy) NSDate *dateStart;
@property (nonatomic, copy) CardView *openCard;
@property (nonatomic, copy) CardView *sendCard;
@property (nonatomic, assign) BOOL clickCard;
@property (nonatomic, copy) NSMutableArray *createCard;
@property (retain, nonatomic) IBOutlet UIButton *toWin;
@property (retain, nonatomic) IBOutlet UILabel *lbTimePlay;

//@property (nonatomic, retain) UITapGestureRecognizer *tap;

@end

@implementation VCFieldPlay

- (void) viewDidLoad {
    [super viewDidLoad];
    _createCard = [[NSMutableArray alloc]init];
    cntX = [_pcntX integerValue];
    cntY = [_pcntY integerValue];
    
    cntCard = cntX * cntY;
    step = (NSUInteger)(256 * 256 * 256 / (cntCard / 2 + 1));
    mTexture = [[NSMutableArray alloc] init];
    for (NSUInteger i = 1; i <= cntCard / 2; i ++) {
//        UIColor *color = [self getColor: [NSNumber numberWithInteger:i]];
        UIImage *image = [self getImage: [NSNumber numberWithInteger:i]];
        [mTexture addObject:image];
        [mTexture addObject:image];
    }
    
//    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelector:)];
//    self.tap.numberOfTapsRequired = 2;
//    self.tap.numberOfTouchesRequired = 1;
    
    
    for (NSUInteger y = 0; y < cntY; y ++) {
        for (NSUInteger x = 0; x < cntX; x ++) {
            CGRect frame = [self getX:x getY:y];
            CardView *newCard = [[CardView alloc] initWithFrame:frame];
            
            CGRect frameForIV = CGRectMake(0, 0, frame.size.width, frame.size.height);
            
            UIImageView *ivTexture = [[UIImageView alloc] initWithFrame:frameForIV];
            
            NSUInteger cntmColor = mTexture.count;
            NSUInteger elem = arc4random_uniform((int)cntmColor);

            //NSUInteger elem = 0;
            //newCard.userInteractionEnabled = NO;
            //newCard.imageCard = [mTexture objectAtIndex:elem];
            newCard.imageCard = [mTexture objectAtIndex:elem];
            [mTexture removeObjectAtIndex:elem];
            //newCard.backgroundColor = [UIColor blackColor];
            ivTexture.backgroundColor = [UIColor blackColor];
            ivTexture.image = newCard.imageCard;
            //newCard.backgroundColor = newCard.imageCard;
            //newCard.image = newCard.imageCard;
            newCard.imViewCard = ivTexture;
            //newCard.rect = frame;
//            self.dateStart = [NSDate date];
            newCard.delegCard = self;
            
            [newCard addSubview:ivTexture];
            
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelector:)];
            tap.numberOfTapsRequired = 2;
            tap.numberOfTouchesRequired = 1;
            
            [newCard addGestureRecognizer:tap];
            [tap release];
            [self.view addSubview:newCard];
            [_createCard addObject:newCard];
            
            [ivTexture release];
            [newCard release];
        }
    }
    [mTexture release];
    _clickCard = NO;
    self.title = @"Запомни расположение";
    __unused NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(prepareCard) userInfo:nil repeats:NO];
}

-(void)tapSelector:(UITapGestureRecognizer*)gesture {
    [self changeSost:(CardView*)gesture.view];
}

- (void) prepareCard {
    for (CardView *card in _createCard) {
        //card.backgroundColor = [UIColor blackColor];
        card.imViewCard.image = nil;
    }
    _clickCard = YES;
    self.title = @"Игра";
    self.dateStart = [NSDate date];
    timerPlay = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(tForPlay) userInfo:nil repeats:YES];
    
}
- (void) tForPlay {
    CGFloat t = [_lbTimePlay.text floatValue] + 0.01;
    _lbTimePlay.text = [NSString stringWithFormat:@"%.2f", t];
}

- (UIColor*)getColor:(NSNumber*)index {
    NSUInteger colorNum = step * [index integerValue];
    CGFloat red = (CGFloat)( (int)(colorNum / (256 * 256)) ) / 256;
    CGFloat green = (CGFloat)(((int)(colorNum / 256)) % 256) / 256;
    CGFloat blue = (CGFloat)((int)(colorNum % 256)) / 256;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

- (UIImage*) getImage:(NSNumber*)index {
    //http://wooi.ru/dock/bakk/image/128/floral_background/floral1.jpg
    NSString *beginUrl = @"http://wooi.ru/dock/bakk/image/128/floral_background/floral";
    NSString *endUrl = @".jpg";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingString:[[@"texture" stringByAppendingString:[NSString stringWithFormat:@"%@", index]]stringByAppendingString:endUrl]];
    //NSData *readfile;
    NSData *rdata = [NSData dataWithContentsOfFile:filePath];
    
    if (rdata) {
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        UIImage *image = [UIImage imageWithData:imageData];
        return image;
    } else {
        NSError *dataError = nil;
        NSURL *url = [NSURL URLWithString:[[beginUrl stringByAppendingString: [NSString stringWithFormat:@"%@", index]] stringByAppendingString:endUrl]];
        NSData *data =[NSData dataWithContentsOfURL:url options:kNilOptions error:&dataError];
        if (dataError) {
            NSLog(@"%@", [dataError localizedDescription]);
            return nil;
        } else {
            UIImage *image;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingString:[[@"texture" stringByAppendingString:[NSString stringWithFormat:@"%@", index]]stringByAppendingString:endUrl]];
            //NSError *saveError = nil;
            BOOL writeWasSuccessful = [data writeToFile:filePath atomically:YES];
            if (writeWasSuccessful) {
                NSData *imageData = [NSData dataWithContentsOfFile:filePath];
                image = [UIImage imageWithData:imageData];
            }
            return image;
        }
    }
}

- (CGRect)getX:(NSUInteger)x getY:(NSUInteger)y {
    NSUInteger maxX = 180;
    NSUInteger maxY = 340;
    NSUInteger nx = (maxX / (cntX - 1)) * x + 50;
    NSUInteger ny = (maxY / (cntY - 1)) * y + 130;
    return CGRectMake(nx, ny, maxX / cntX, maxY / cntY);
}

- (void) changeSost:(CardView *)card {
    if (card.imViewCard.image == nil) {
        //card.backgroundColor = card.imageCard;
        card.imViewCard.image = card.imageCard;
        if (_openCard == nil) {
            _openCard = card;
        } else {
            _sendCard = card;
            _clickCard = NO;
            __unused NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAct) userInfo:nil repeats:NO];
        }
    } else {
        //card.backgroundColor = [UIColor blackColor];
        card = nil;
        _openCard = nil;
    }
}
- (void) timerAct {
    CardView *card = _sendCard;
    if ([_openCard.imageCard isEqual:card.imageCard] && !([_openCard isEqual:card])) {
        [_openCard removeFromSuperview];
        [card removeFromSuperview];
        [_createCard removeObject:_openCard];
        [_createCard removeObject:card];
        if (!_createCard.count) {
            [_createCard release];
            //[self.navigationController pushViewController:vccobCongratuations animated:YES];
            //_lbConratulations.hidden = NO;
            //_vPanel.hidden = NO;
            _toWin.hidden = NO;
            [timerPlay invalidate];
//            NSDate *tdateStart = [NSDate date];
//            NSLog(@"%@", _dateStart);
//            NSTimeInterval inter = [_dateStart timeIntervalSince1970];
            NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.dateStart];
            [self.delegateSave saveUserResult:[_lbTimePlay.text floatValue] time:interval];
//            [self.delegateSave saveUserResult:[_lbTimePlay.text floatValue]];
            self.title = @"Игра окончена";
        }
    } else {
        _openCard.imViewCard.image = nil;
        card.imViewCard.image = nil;
    }
    _openCard = nil;
    //_sendCard = nil;
    _clickCard = YES;
}

/*- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toCongratuationsSegue"]) {
        //[_toWin release];
        //[self.view release];
        //[self release];
    }
}*/

- (BOOL) checkClickCard {
    return _clickCard;
}
- (IBAction)returnToStart:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void) dealloc {
    [super dealloc];
    //[_tap release];
}
@end
