//
//  MyAlertView.m
//  Temp&HumiManager
//
//  Created by terry on 2018/5/23.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MyAlertView.h"
#import "SettingCardView.h"
#import "UITextField_DIYField.h"
#import "UIButton_DIYObject.h"

@interface MyAlertView ()

@property (nonatomic,copy)void(^didConfirmTf)(MyAlertView *, UITextField *,UITextField *, UILabel *);
@property (nonatomic,copy)void(^didConfirmWarn)(MyAlertView *);

@property (nonatomic,strong,readwrite)UIView *tempView;

@end

@implementation MyAlertView

+ (MyAlertView *)shreadInstance{
    static MyAlertView *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        manager = [[MyAlertView alloc]init];
    });
    return manager;
}

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        self.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];

    CGPoint p = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.tempView.frame, p)) {
        [self dismiss];
    }
}


#pragma mark ----- outside method
- (void)dismiss{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self removeNotificationKeyBoard];
    }];
}

- (void)showTH_TFAlertWithPlaceHolder1:(NSString *)plhd1 PlaceHolder2:(NSString *)plhd2 Title:(NSString *)title DetailInfo:(NSString *)detailIfno Confirm:(NSString *)confirm ConfirmBlcok:(void (^)(MyAlertView *, UITextField *, UITextField *, UILabel *))block{

    self.didConfirmTf = block;

    //添加键盘相关通知
    [self addNoticeForKeyboard];

    SettingCardView *sc = [[SettingCardView alloc]init];
    sc.title = title;
    [self addSubview:sc];

    CGFloat w = self.frame.size.width*0.7;
    CGFloat h = sc.topHeight;

    CGFloat disY = Fit_Y(10.0);

    CGFloat w_tf = w*0.9;
    CGFloat h_tf = Fit_Y(50.0);

    UITextField_DIYField *tf = [[UITextField_DIYField alloc]initWithFrame:CGRectMake(w/2.0 - w_tf/2.0, sc.topHeight + disY, w_tf, h_tf)];
    tf.style = TextFieldStyle_BorderLine;
    tf.placeholder = plhd1;
    tf.textAlignment = NSTextAlignmentCenter;
    tf.tintsColor = [UIColor lightGrayColor];
    tf.tag = 1001;
    [sc addSubview:tf];

    UITextField_DIYField *tf1 = [[UITextField_DIYField alloc]initWithFrame:CGRectMake(w/2.0 - w_tf/2.0, tf.frame.origin.y + tf.frame.size.height + disY, w_tf, h_tf)];
    tf1.style = TextFieldStyle_BorderLine;
    tf1.placeholder = plhd2;
    tf1.textAlignment = NSTextAlignmentCenter;
    tf1.tintsColor = [UIColor lightGrayColor];
    tf1.tag = 1002;
    [sc addSubview:tf1];

    UILabel *lab;
    if (detailIfno.length > 0) {
        lab = [[UILabel alloc]initWithFrame:CGRectMake(tf1.frame.origin.x, tf1.frame.origin.y + tf1.frame.size.height + disY, 0, 0)];
        lab.text = detailIfno;
        lab.tag = 1003;
        lab.font = [UIFont fitSystemFontOfSize:14.0];
        [lab fitWidth:tf1.frame.size.width];
        [sc addSubview:lab];
    }

    UIButton_DIYObject *btn = [UIButton_DIYObject buttonWithType:UIButtonTypeCustom];
    CGFloat w_btn = tf1.frame.size.width;
    CGFloat h_btn = Fit_Y(30.0);
    btn.title = @"+";
    btn.labTitle.textColor = [UIColor whiteColor];
    btn.layer.masksToBounds = true;
    btn.layer.cornerRadius = Fit_Y(5.0);
    btn.frame = CGRectMake(tf1.frame.origin.x, tf1.frame.origin.y + tf1.frame.size.height + disY + lab.bounds.size.height + disY, w_btn, h_btn);
    btn.backgroundColor = MainColor;
    [sc addSubview:btn];
    btn.tag = 1004;
    [btn addTarget:self action:@selector(clickTfConfirmButton:) forControlEvents:UIControlEventTouchUpInside];

    h = btn.frame.origin.y + btn.frame.size.height + disY;

    sc.frame = CGRectMake(self.frame.size.width/2.0 - w/2.0, self.frame.size.height/2.0 - h/2.0, w, h);

    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    self.tempView = sc;
}

- (void)showTitle:(NSString *)title Message:(NSString *)msg DissTime:(NSTimeInterval)time{

    SettingCardView *sc = [[SettingCardView alloc]init];
    sc.title = title;
    [self addSubview:sc];

    CGFloat disY = Fit_Y(10.0);
    CGFloat w = self.frame.size.width * 0.8;

    CGFloat w_lab = w*0.9;
    UILabel *labMsg = [[UILabel alloc]init];
    labMsg.text = msg;
    labMsg.textAlignment = NSTextAlignmentCenter;
    labMsg.frame = CGRectMake(w/2.0 - w_lab/2.0, sc.topHeight + disY, w_lab, Fit_Y(50.0));
    [sc addSubview:labMsg];

    CGFloat h = labMsg.frame.origin.y + labMsg.frame.size.height + disY;
    sc.frame = CGRectMake(self.frame.size.width/2.0 - w/2.0, self.frame.size.height/2.0 - h/2.0, w, h);

    sc.alpha = 0;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        sc.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
    }];
    self.tempView = sc;
}

- (void)showTHLITitle:(NSString *)title confirm:(NSString *)confirm confirmBlock:(void (^)(MyAlertView *))block THLIViewArray:(NSArray<TH_LableImvView *> *)views{

    self.didConfirmWarn = block;
    
    SettingCardView *sc = [[SettingCardView alloc]init];
    sc.title = title;
    [self addSubview:sc];

    CGFloat disY = Fit_Y(10.0);
    CGFloat w = self.frame.size.width * 0.8;
    CGFloat disX = w * 0.05;

    CGFloat y_view = sc.topHeight + disY;

    for (int i=0; i<views.count; i++) {
        UIView *view = [views objectAtIndex:i];
        view.frame = CGRectMake(disX, y_view, w - disX*2.0, Fit_Y(50.0));
        [sc addSubview:view];
        y_view = view.frame.origin.y + view.frame.size.height + disY;
    }

    UIButton_DIYObject *btn = [UIButton_DIYObject buttonWithType:UIButtonTypeCustom];
    CGFloat w_btn = w - disX*2.0;
    CGFloat h_btn = Fit_Y(30.0);
    btn.title = confirm;
    btn.labTitle.textColor = [UIColor whiteColor];
    btn.layer.masksToBounds = true;
    btn.layer.cornerRadius = Fit_Y(5.0);
    btn.frame = CGRectMake(disX, y_view, w_btn, h_btn);
    btn.backgroundColor = MainColor;
    [sc addSubview:btn];
    btn.tag = 1004;
    [btn addTarget:self action:@selector(clickWarnConfirm:) forControlEvents:UIControlEventTouchUpInside];

    CGFloat h = btn.frame.origin.y + btn.frame.size.height + disY;
    sc.frame = CGRectMake(self.frame.size.width/2.0 - w/2.0, self.frame.size.height/2.0 - h/2.0, w, h);

    self.alpha = 0;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
    self.tempView = sc;

}

- (void)showTHLITitle:(NSString *)title confirm:(NSString *)confirm confirmBlock:(void (^)(MyAlertView *))block THLIViews:(TH_LableImvView *)firstView, ...{

    if(firstView == nil){
        LRLog(@"showTHLITitle: can`t be nil TH_LableImvView");
        return ;
    }

    SettingCardView *sc = [[SettingCardView alloc]init];
    sc.title = title;
    [self addSubview:sc];

    CGFloat disY = Fit_Y(10.0);
    CGFloat w = self.frame.size.width * 0.8;
    CGFloat disX = w * 0.05;

    CGFloat y_view = sc.topHeight + disY;

    va_list args; ///< VA_LIST 是在C语言中解决变参问题的一组宏
    // VA_START宏，获取可变参数列表的第一个参数的地址,在这里是获取firstObj的内存地址,这时argList的指针 指向firstObj
    va_start(args, firstView);
    // VA_ARG宏，获取可变参数的当前参数，返回指定类型并将指针指向下一参数
    // 首先 argList的内存地址指向的fristObj将对应储存的值取出,如果不为nil则判断为真,将取出的值房在数组中,
    //并且将指针指向下一个参数,这样每次循环argList所代表的指针偏移量就不断下移直到取出nil
    for(TH_LableImvView *view = firstView;view != nil;view = va_arg(args, TH_LableImvView *)){
        view.frame = CGRectMake(disX, y_view, w - disX*2.0, Fit_Y(50.0));
        [sc addSubview:view];
        y_view = view.frame.origin.y + view.frame.size.height + disY;
    }
    // 清空列表
    va_end(args);

    UIButton_DIYObject *btn = [UIButton_DIYObject buttonWithType:UIButtonTypeCustom];
    CGFloat w_btn = w - disX*2.0;
    CGFloat h_btn = Fit_Y(30.0);
    btn.title = confirm;
    btn.labTitle.textColor = [UIColor whiteColor];
    btn.layer.masksToBounds = true;
    btn.layer.cornerRadius = Fit_Y(5.0);
    btn.frame = CGRectMake(disX, y_view, w_btn, h_btn);
    btn.backgroundColor = MainColor;
    [sc addSubview:btn];
    btn.tag = 1004;
    [btn addTarget:self action:@selector(clickWarnConfirm:) forControlEvents:UIControlEventTouchUpInside];

    CGFloat h = btn.frame.origin.y + btn.frame.size.height + disY;
    sc.frame = CGRectMake(self.frame.size.width/2.0 - w/2.0, self.frame.size.height/2.0 - h, w, h);

    self.alpha = 0;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
}


- (void)showWarnTitle:(NSString *)title confirm:(NSString *)confirm image1s:(NSArray <UIImage *>*)image1s image2s:(NSArray <UIImage *>*)image2s text1s:(NSArray <NSString *>*)text1s text1s:(NSArray <NSString *>*)text2s confirmBlock:(void(^)(MyAlertView *))block{

    if (![NSArray isAllEqualCountArrays:image1s,image2s,text1s,text2s, nil]) {
        return ;
    }

    SettingCardView *sc = [[SettingCardView alloc]init];
    sc.title = title;
    [self addSubview:sc];

    CGFloat disY = Fit_Y(10.0);
    CGFloat w = self.frame.size.width * 0.8;
    CGFloat disX = w * 0.05;

    CGFloat y_view = sc.topHeight + disY;
    for (int i = 0; i<image1s.count; i++) {
        TH_LableImvView *liv = [[TH_LableImvView alloc]initWithFrame:CGRectMake(disX, y_view, w - disX*2.0, Fit_Y(50.0))];
        liv.imv1.image = [image1s objectAtIndex:i];
        liv.imv2.image = [image2s objectAtIndex:i];
        liv.lab1.text = [text1s objectAtIndex:i];
        [liv.lab1 sizeToFit];
        liv.lab2.text = [text2s objectAtIndex:i];
        [liv.lab2 sizeToFit];
        [sc addSubview:liv];
        y_view = liv.frame.origin.y + liv.frame.size.height + disY;
    }

    UIButton_DIYObject *btn = [UIButton_DIYObject buttonWithType:UIButtonTypeCustom];
    CGFloat w_btn = w - disX*2.0;
    CGFloat h_btn = Fit_Y(30.0);
    btn.title = confirm;
    btn.labTitle.textColor = [UIColor whiteColor];
    btn.layer.masksToBounds = true;
    btn.layer.cornerRadius = Fit_Y(5.0);
    btn.frame = CGRectMake(disX, y_view, w_btn, h_btn);
    btn.backgroundColor = MainColor;
    [sc addSubview:btn];
    btn.tag = 1004;
    [btn addTarget:self action:@selector(clickWarnConfirm:) forControlEvents:UIControlEventTouchUpInside];

    CGFloat h = btn.frame.origin.y + btn.frame.size.height + disY;
    sc.frame = CGRectMake(self.frame.size.width/2.0 - w/2.0, self.frame.size.height/2.0 - h, w, h);

    self.alpha = 0;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
}

#pragma mark ----- event
- (void)clickTfConfirmButton:(UIButton_DIYObject *)sender{

    UITextField *tf1 = [sender.superview viewWithTag:1001];
    UITextField *tf2 = [sender.superview viewWithTag:1002];
    UILabel *lab = [sender.superview viewWithTag:1003];

    [tf1 resignFirstResponder];
    [tf2 resignFirstResponder];

    if (self.didConfirmTf) {
        self.didConfirmTf(self, tf1,tf2, lab);
    }
}

- (void)clickWarnConfirm:(UIButton_DIYObject *)sender{
    [self dismiss];
    if (self.didConfirmWarn) {
        self.didConfirmWarn(self);
    }
}

/**
 * 键盘显示事件
 */
- (void)keyboardWillShow:(NSNotification *)notification {

    UITextField *tf1 = [self.tempView viewWithTag:1001];
    UITextField *tf2 = [self.tempView viewWithTag:1002];
    if (tf1.editing || tf2.editing) {
        //获取键盘高度，在不同设备上，以及中英文下是不同的
        CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

        //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
        CGFloat offset = (self.tempView.frame.origin.y + self.tempView.frame.size.height + 10.f) - (self.frame.size.height - kbHeight);

        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
        double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

        //将视图上移计算好的偏移
        if(offset > 0) {
            [UIView animateWithDuration:duration animations:^{
                self.tempView.center = CGPointMake(self.tempView.center.x, self.frame.size.height - kbHeight-self.tempView.bounds.size.height/2.0 - 5.0);
            }];
        }

    }
}

/**键盘消失事件*/
- (void) keyboardWillHide:(NSNotification *)notify {

    // 键盘动画时间
    NSTimeInterval duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.tempView.center = CGPointMake(self.frame.size.width/2.0,self.frame.size.height/2.0);
    }];

}

#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {

    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)removeNotificationKeyBoard{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



@end
