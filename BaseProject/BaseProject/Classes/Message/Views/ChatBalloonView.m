//
//  ChatBalloonView.m
//  SimpleLife
//
//  Created by angle yan on 17/4/20.
//  Copyright © 2017年 高砚祥. All rights reserved.
//

#import "ChatBalloonView.h"


@interface ChatBalloonView ()


@end


@implementation ChatBalloonView







- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.backgroundColor = ClearColor;
        self.balloonAlignment = ChatBalloonAlignmentLeft;
        self.balloonColor = WhiteColor;
        self.font = Font(13);
        self.corner = 4;
        self.balloonWidth = Width(250);
        self.textColor = TEXT_666;
        
    
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    [self setNeedsDisplay];
}

- (void)setBalloonAlignment:(ChatBalloonAlignment)balloonAlignment
{
    _balloonAlignment = balloonAlignment;
    if (balloonAlignment == ChatBalloonAlignmentLeft) {
        self.balloonColor = WhiteColor;
        self.textColor = TEXT_666;
    }else{
        self.balloonColor = Main_Color;
        self.textColor = WhiteColor;
    }
}

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context =  UIGraphicsGetCurrentContext();
    
    CGRect textRect = [self.text boundingRectWithSize:CGSizeMake(Width(250)-Width(30),0) options: (NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:self.font} context:nil];

    CGFloat minx = Width(5);      CGFloat maxx = textRect.size.width+Width(30)-self.corner;
    
    CGFloat miny = Height(0);      CGFloat maxy = textRect.size.height+Height(20)-self.corner;
    if (self.balloonAlignment == ChatBalloonAlignmentLeft) {
      
        

        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, Width(5), 0);
        CGContextAddArcToPoint(context, maxx, miny, maxx, maxy, self.corner);//画完后 current point不在minx,miny，而是在圆弧结束的地方
        CGContextAddArcToPoint(context, maxx, maxy, minx, maxy, self.corner);
        CGContextAddArcToPoint(context, minx, maxy, minx, miny, self.corner);
        CGContextAddLineToPoint(context, minx, Width(5));
        
        CGContextSetFillColorWithColor(context, self.balloonColor.CGColor);
        CGContextFillPath(context);
        
        [self.text drawInRect:CGRectMake(Width(15), Height(10), CGRectGetWidth(textRect), CGRectGetHeight(textRect)) withAttributes: @{NSFontAttributeName:self.font,NSForegroundColorAttributeName:self.textColor}];

        
    }else{
         minx = self.balloonWidth-minx;       maxx = self.balloonWidth- maxx;
        
        CGContextMoveToPoint(context, self.balloonWidth, 0);
        CGContextAddLineToPoint(context,self.balloonWidth-Width(5), 0);
        CGContextAddArcToPoint(context, maxx, miny, maxx, maxy, self.corner);//画完后 current point不在minx,miny，而是在圆弧结束的地方
        CGContextAddArcToPoint(context, maxx, maxy, minx, maxy, self.corner);
        CGContextAddArcToPoint(context, minx, maxy, minx, miny, self.corner);
        CGContextAddLineToPoint(context, minx, Width(5));
        
        CGContextSetFillColorWithColor(context, self.balloonColor.CGColor);
        CGContextFillPath(context);
        
        [self.text drawInRect:CGRectMake(maxx+Width(10), Height(10), CGRectGetWidth(textRect), CGRectGetHeight(textRect)) withAttributes: @{NSFontAttributeName:self.font,NSForegroundColorAttributeName:self.textColor}];
    }
    [self sizeToFit];

}






@end
