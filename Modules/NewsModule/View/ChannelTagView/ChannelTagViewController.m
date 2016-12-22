/**
 * editViewController
 * @description 本文件提供拖动排序编辑界面，点击编辑按钮之后可以进行删除和长按拖动排序
 * @package
 * @author 		yinlinlin
 * @copyright 	Copyright (c) 2012-2020
 * @version 		1.0
 * @description 本文件提供拖动排序编辑界面，点击编辑按钮之后可以进行删除和长按拖动排序
 */

#import "ChannelTagViewController.h"

#define BUTTONHEIGHT 40
#define BUTTONSPACING 15
#define TAB_BAR_HIGHT   50
#define NAV_BAR_HIGHT   44
//视图背景颜色
#define  kViewBackgroundColor [UIColor colorWithRed:29.0/255.0f green:34.0/255.0f blue:40.0/255.0f alpha:1]

@interface ChannelTagViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel*                    m_tipLabelShow;
    UILabel*                    m_tipLabelHide;
    
    UITableView                 *m_tableView;
    double                      m_showItemsViewHeight;
    double                      m_hideItemsViewHeight;
}

@end

@implementation ChannelTagViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)back:(id)sender
{
    if (_sortCompleteCallBack)
    {
        _sortCompleteCallBack(m_showItemsList,m_hideItemsList);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    m_showItemsList = [[NSMutableArray alloc]initWithArray:_showItemsList];
    m_hideItemsList = [[NSMutableArray alloc] initWithArray:_hideItemsList];
    if (m_hideItemsList == nil)
        m_hideItemsList = [[NSMutableArray alloc] init];
    
    NSInteger addLine = 0;
    if (m_showItemsList.count % 4 > 0)
    {
        addLine = 1;
    }
    m_showItemsViewHeight =  (m_showItemsList.count/4 + addLine) * (BUTTONHEIGHT+BUTTONSPACING);
    NSInteger addLineHide = 0;
    if (m_hideItemsList.count % 4 > 0)
    {
        addLineHide = 1;
    }
    m_hideItemsViewHeight =  (m_hideItemsList.count/4 + addLineHide) * (BUTTONHEIGHT+BUTTONSPACING);
    
    CGRect rect = self.view.frame;
    UINavigationBar *bar = [self.navigationController navigationBar];
    bar.backgroundColor = [UIColor blackColor];
    rect.size.height = rect.size.height - bar.frame.size.height - 20 - TAB_BAR_HIGHT;
    m_tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.backgroundColor = [UIColor blackColor];
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:m_tableView];
    
    _editBu = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _editBu.frame=CGRectMake(0.0, 0.0, 47, 24);
    [_editBu setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_editBu setTitle:@"完成" forState:UIControlStateSelected];
    [_editBu setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_editBu addTarget:self action:@selector(editBuPressed:) forControlEvents:UIControlEventTouchDown];
    
    [self.navigationItem setTitle:@"新闻栏目配置"];
    
    UIBarButtonItem* setBuItem=[[UIBarButtonItem alloc]initWithCustomView:_editBu];
    self.navigationItem.rightBarButtonItem = setBuItem;
//    self.view.backgroundColor = [UIColor blackColor];
//    UIButton* lButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    lButton.frame = CGRectMake(0.0, 0.0, 20.0, 20.0);
//    [lButton setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
//    [lButton setImage:[UIImage imageNamed:@"navbar_back_p"] forState:UIControlStateSelected];
//    lButton.backgroundColor = [UIColor blackColor];
//    [lButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:lButton];
//    temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
//    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
//    m_tipLabelShow = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 32)];
//    m_tipLabelShow.text = @"  长按拖动调整排序";
//    m_tipLabelShow.textColor = m_ColourInfo.table_Detail_TextColor;
//    [self.view addSubview:m_tipLabelShow];
//    
//
//    m_showItemsList = [[NSMutableArray alloc]initWithArray:_showItemsList];
//    m_showItemsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, m_tipLabelShow.frame.size.height, self.view.frame.size.width, (m_showItemsList.count/4 + addLine+1) * (BUTTONHEIGHT+BUTTONSPACING))];
//    [self.view addSubview:m_showItemsView];
//    
//    m_tipLabelHide = [[UILabel alloc] initWithFrame:CGRectMake(0, m_showItemsView.frame.origin.y+m_showItemsView.frame.size.height, self.view.frame.size.width, 32)];
//    m_tipLabelHide.text = @"  点击添加更多栏目";
//    m_tipLabelHide.textColor = m_ColourInfo.table_Detail_TextColor;
//    [self.view addSubview:m_tipLabelHide];
//    //判断是否需要添加一行，当数量刚好是4的倍数时不需要添加
//    m_showItemsView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, (m_showItemsList.count/4 + addLine+1) * (BUTTONHEIGHT+BUTTONSPACING));
//    
//    double hideItemsHeight = self.view.frame.size.height-m_showItemsView.frame.size.height-m_tipLabelHide.frame.size.height*2;
//    m_hideItemsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, m_tipLabelHide.frame.origin.y+m_tipLabelHide.frame.size.height, self.view.frame.size.width, hideItemsHeight)];
//    [self.view addSubview:m_hideItemsView];
//    
//    if (m_hideItemsList == nil || m_hideItemsList.count == 0)
//    {
//        m_hideItemsList = [[NSMutableArray alloc] init];
//        m_hideItemsView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, hideItemsHeight);
//    }
//    else
//    {
//        m_hideItemsView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, (m_hideItemsList.count/4 + addLine) * (BUTTONHEIGHT+BUTTONSPACING));
//    }
//    
//    [self updateShowItemsScroll];
//    [self updateHideItemsScroll];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return m_showItemsViewHeight;
    else if (indexPath.section == 1)
        return m_hideItemsViewHeight;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor = kViewBackgroundColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 40)];
    if (section == 0)
    {
        label.text = @"长按拖动调整排序";
        label.textColor = [UIColor grayColor];
    }
    else if (section == 1)
    {
        label.text = @"点击添加更多栏目";
        label.textColor = [UIColor grayColor];
    }
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"LoginCell%d",(int)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0)
            {
                m_showItemsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, m_showItemsViewHeight)];
                [cell.contentView addSubview:m_showItemsView];
                
                [self updateShowItemsScroll];
            }
        }
        else if (indexPath.section == 1)
        {
            if (indexPath.row == 0)
            {
                m_hideItemsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, m_hideItemsViewHeight)];
                [cell.contentView addSubview:m_hideItemsView];
                
                [self updateHideItemsScroll];
            }
        }
    }
    
    cell.backgroundColor = [UIColor blackColor];
    
    return cell;
}


#pragma mark - 点击navigation右侧编辑按钮
- (void)editBuPressed:(id)sender
{
    if ([_editBu isSelected])
    {
        //处理排序完成的事件
        [_editBu setSelected:NO];
        NSLog(@"输出交换之后的数组:%@",m_showItemsList);
//        if (_sortCompleteCallBack)
//        {
//            _sortCompleteCallBack(m_showItemsList,m_hideItemsView);
//        }
        //[self.navigationController popViewControllerAnimated:YES];
        [_editBu setSelected:NO];
        for (UIButton * dragBu in m_showItemsView.subviews)
        {
            UIButton * deleteBu = (UIButton *)[dragBu viewWithTag:1000];
            [deleteBu setHidden:YES];
        }
    }
    else
    {
        //可以编辑相册
        [_editBu setSelected:YES];
        for (UIButton * dragBu in m_showItemsView.subviews)
        {
            UIButton * deleteBu = (UIButton *)[dragBu viewWithTag:1000];
            [deleteBu setHidden:NO];
        }
        
    }
}

#pragma mark - 拖动晃动
- (void)startShake:(UIView* )imageV
{
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    shakeAnimation.duration = 0.08;
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = MAXFLOAT;
    shakeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(imageV.layer.transform, -0.06, 0, 0, 1)];
    shakeAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(imageV.layer.transform, 0.06, 0, 0, 1)];
    [imageV.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
}

- (void)stopShake:(UIView* )imageV
{
    [imageV.layer removeAnimationForKey:@"shakeAnimation"];
}

#pragma mark - 根据相册数量进行排版
/**
 * @函数名称：updateShowItemsScroll
 * @函数描述：根据上一界面获取到的具体的相册数据进行排版
 * @输入参数：void
 * @输出参数：void
 * @返回值：void
 */
- (void)updateShowItemsScroll
{
    double width = ([UIScreen mainScreen].bounds.size.width - 50)/4;
    for (int i = 0; i < m_showItemsList.count; i ++)
    {
        CGFloat x = i % 4 * (width+10) + 10;
        CGFloat y = i/4 * (BUTTONHEIGHT + BUTTONSPACING)+10;
        UIButton * dragBu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [dragBu setFrame:CGRectMake(x, y, width, BUTTONHEIGHT)];
        [dragBu setTitle:[m_showItemsList objectAtIndex:i] forState:UIControlStateNormal];
        [m_showItemsView addSubview:dragBu];
        dragBu.tag = 100 + i;
        UILongPressGestureRecognizer * panTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
        //dragBu.layer.borderWidth = 0.5;
        dragBu.layer.cornerRadius = 10;
        dragBu.backgroundColor = [UIColor colorWithRed:60.0f/255 green:92.0f/255 blue:132.0f/255 alpha:1];
        [dragBu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [dragBu addGestureRecognizer:panTap];
        UIButton * deleteBu = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBu.tag = 1000;
        [deleteBu setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [deleteBu setFrame:CGRectMake(-4, -4, 20, 20)];
        [dragBu addSubview:deleteBu];
        [dragBu bringSubviewToFront:deleteBu];
        [deleteBu addTarget:self action:@selector(deleteAlbum:) forControlEvents:UIControlEventTouchUpInside];
        [deleteBu setHidden:YES];
    }
}

- (void)updateHideItemsScroll
{
    double width = ([UIScreen mainScreen].bounds.size.width - 50)/4;
    for (int i = 0; i < m_hideItemsList.count; i ++)
    {
        CGFloat x = i % 4 * (width+10) + 10;
        CGFloat y = i/4 * (BUTTONHEIGHT + BUTTONSPACING)+10;
        UIButton * dragBu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [dragBu setFrame:CGRectMake(x, y, width, BUTTONHEIGHT)];
        [dragBu setTitle:[m_hideItemsList objectAtIndex:i] forState:UIControlStateNormal];
        [m_hideItemsView addSubview:dragBu];
        dragBu.tag = 200 + i;
        dragBu.layer.cornerRadius = 10;
        dragBu.backgroundColor = [UIColor colorWithRed:60.0f/255 green:92.0f/255 blue:132.0f/255 alpha:1];
        [dragBu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [dragBu addTarget:self action:@selector(btnHideItemsClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}


#pragma mark - 删除相册方法
/**
 * @函数名称：deleteAlbum:
 * @函数描述：用户点击删除相册的按钮，重新排版，并把要删除的相册的id传到后台处理
 * @输入参数：(id)sender
 * @输出参数：void
 * @返回值：void
 */
- (IBAction)deleteAlbum:(UIButton*)sender
{
    
    _deleteIndex = sender.superview.tag - 100;
    NSLog(@"删除按钮:%@",[m_showItemsList objectAtIndex:_deleteIndex]);
    //局部变量是不能在闭包中发生改变的，所以需要把_dragToPoint，_dragFromPoint定义成全局变量
    //记录删除按钮的位置
    _dragToPoint = sender.superview.center;
    
    [sender.superview removeFromSuperview];
    
    __block NSMutableArray * bnewShowItemslist = m_showItemsList;
    __block NSMutableArray * bnewHideItemslist = m_hideItemsList;
    __block UIScrollView * bphotoScrol = m_showItemsView;
    //把删除按钮的下一个按钮移动到记录的删除按钮的位置，并把下一按钮的位置记为新的_toFrame，并把view的tag值-1,依次处理
    [UIView animateWithDuration:0.3 animations:^
    {
        NSLog(@"%ld %ld",sender.superview.tag - 100 + 1,bnewShowItemslist.count);
        for (NSInteger i = _deleteIndex + 1; i < bnewShowItemslist.count; i ++)
        {
            UIButton * dragBu = (UIButton *)[bphotoScrol viewWithTag:i + 100];
            _dragFromPoint = dragBu.center;
            dragBu.center = _dragToPoint;
            _dragToPoint = _dragFromPoint;
            dragBu.tag --;
        }
        
    } completion:^(BOOL finished) {
        //移动完成之后,才能从m_showItemsList列表中移除要删除按钮的数据
        [bnewHideItemslist addObject:[bnewShowItemslist objectAtIndex:_deleteIndex]];
        [bnewShowItemslist removeObjectAtIndex:_deleteIndex];
        
        [UIView animateWithDuration:0.3 animations:^
        {
            NSInteger addLine = 0;
            if (m_showItemsList.count % 4 > 0)
            {
                addLine = 1;
            }
            m_showItemsViewHeight =  (m_showItemsList.count/4 + addLine) * (BUTTONHEIGHT+BUTTONSPACING);
            m_showItemsView.frame = CGRectMake(0, 0, self.view.frame.size.width, m_showItemsViewHeight);
            m_showItemsView.contentSize = CGSizeMake(self.view.frame.size.width, m_showItemsViewHeight);
            NSInteger addLineHide = 0;
            if (m_hideItemsList.count % 4 > 0)
            {
                addLineHide = 1;
            }
            m_hideItemsViewHeight =  (m_hideItemsList.count/4 + addLineHide) * (BUTTONHEIGHT+BUTTONSPACING);
            m_hideItemsView.frame = CGRectMake(0, 0, self.view.frame.size.width, m_hideItemsViewHeight);
            m_hideItemsView.contentSize = CGSizeMake(self.view.frame.size.width, m_hideItemsViewHeight);
            
            //add hide items
            double width = ([UIScreen mainScreen].bounds.size.width - 50)/4;
            long index = m_hideItemsList.count-1;
            CGFloat x = index % 4 * (width+10) + 10;
            CGFloat y = index/4 * (BUTTONHEIGHT + BUTTONSPACING)+10;
            UIButton * dragBu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [dragBu setFrame:CGRectMake(x, y, width, BUTTONHEIGHT)];
            [dragBu setTitle:[m_hideItemsList objectAtIndex:index] forState:UIControlStateNormal];
            [m_hideItemsView addSubview:dragBu];
            dragBu.tag = 200 + index;
            dragBu.layer.cornerRadius = 10;
            dragBu.backgroundColor = [UIColor colorWithRed:60.0f/255 green:92.0f/255 blue:132.0f/255 alpha:1];
            [dragBu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [dragBu addTarget:self action:@selector(btnHideItemsClick:) forControlEvents:UIControlEventTouchUpInside];
            }completion:^(BOOL finished) {
                [m_tableView reloadData];
            }];
    }];
}

- (IBAction)btnHideItemsClick:(UIButton*)sender
{
    NSInteger btnIndex = sender.tag - 200;
    NSLog(@"删除按钮:%@",[m_hideItemsList objectAtIndex:btnIndex]);
    //局部变量是不能在闭包中发生改变的，所以需要把_dragToPoint，_dragFromPoint定义成全局变量
    //记录删除按钮的位置
    _dragToPoint = sender.center;
    
    [sender removeFromSuperview];
    
    __block NSMutableArray * bnewShowItemslist = m_showItemsList;
    __block NSMutableArray * bnewHideItemslist = m_hideItemsList;
    __block UIScrollView * bphotoScrol = m_hideItemsView;
    //把删除按钮的下一个按钮移动到记录的删除按钮的位置，并把下一按钮的位置记为新的_toFrame，并把view的tag值-1,依次处理
    [UIView animateWithDuration:0.3 animations:^
     {
         //NSLog(@"%d %d",sender.superview.tag - 100 + 1,bnewShowItemslist.count);
         for (NSInteger i = btnIndex + 1; i < bnewHideItemslist.count; i ++)
         {
             UIButton * dragBu = (UIButton *)[bphotoScrol viewWithTag:i + 200];
             _dragFromPoint = dragBu.center;
             dragBu.center = _dragToPoint;
             _dragToPoint = _dragFromPoint;
             dragBu.tag --;
         }
         
     } completion:^(BOOL finished) {
         //移动完成之后,才能从m_showItemsList列表中移除要删除按钮的数据
         [bnewShowItemslist addObject:[bnewHideItemslist objectAtIndex:btnIndex]];
         [bnewHideItemslist removeObjectAtIndex:btnIndex];
         
         [UIView animateWithDuration:0.3 animations:^
          {
              NSInteger addLine = 0;
              if (m_showItemsList.count % 4 > 0)
              {
                  addLine = 1;
              }
              m_showItemsViewHeight =  (m_showItemsList.count/4 + addLine) * (BUTTONHEIGHT+BUTTONSPACING);
              m_showItemsView.frame = CGRectMake(0, 0, self.view.frame.size.width, m_showItemsViewHeight);
              m_showItemsView.contentSize = CGSizeMake(self.view.frame.size.width, m_showItemsViewHeight);
              NSInteger addLineHide = 0;
              if (m_hideItemsList.count % 4 > 0)
              {
                  addLineHide = 1;
              }
              m_hideItemsViewHeight =  (m_hideItemsList.count/4 + addLineHide) * (BUTTONHEIGHT+BUTTONSPACING);
              m_hideItemsView.frame = CGRectMake(0, 0, self.view.frame.size.width, m_hideItemsViewHeight);
              m_hideItemsView.contentSize = CGSizeMake(self.view.frame.size.width, m_hideItemsViewHeight);
              
              //add hide items
              double width = ([UIScreen mainScreen].bounds.size.width - 50)/4;
              long index = m_showItemsList.count-1;
              CGFloat x = index % 4 * (width+10) + 10;
              CGFloat y = index/4 * (BUTTONHEIGHT + BUTTONSPACING)+10;
              UIButton * dragBu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
              [dragBu setFrame:CGRectMake(x, y, width, BUTTONHEIGHT)];
              [dragBu setTitle:[m_showItemsList objectAtIndex:index] forState:UIControlStateNormal];
              [m_showItemsView addSubview:dragBu];
              dragBu.tag = 100 + index;
              UILongPressGestureRecognizer * panTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
              //dragBu.layer.borderWidth = 0.5;
              dragBu.layer.cornerRadius = 10;
              dragBu.backgroundColor = [UIColor colorWithRed:60.0f/255 green:92.0f/255 blue:132.0f/255 alpha:1];
              [dragBu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
              [dragBu addGestureRecognizer:panTap];
              UIButton * deleteBu = [UIButton buttonWithType:UIButtonTypeCustom];
              deleteBu.tag = 1000;
              [deleteBu setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
              [deleteBu setFrame:CGRectMake(-4, -4, 20, 20)];
              [dragBu addSubview:deleteBu];
              [dragBu bringSubviewToFront:deleteBu];
              [deleteBu addTarget:self action:@selector(deleteAlbum:) forControlEvents:UIControlEventTouchUpInside];
              if ([_editBu isSelected])
                  [deleteBu setHidden:NO];
              else
                  [deleteBu setHidden:YES];
          }completion:^(BOOL finished) {
              [m_tableView reloadData];
          }];
     }];
}

#pragma mark - 拖动排序处理方法
/**
 * @函数名称：handlePanGesture:
 * @函数描述：处理相册上面的拖动手势，判断手势的state，并做处理
 * @输入参数：(UIPanGestureRecognizer *)recognizer
 * @输出参数：void
 * @返回值：void
 */
- (void)handlePanGesture:(UIGestureRecognizer *)recognizer
{
    if (![_editBu isSelected]) {
        //可以编辑相册
        [_editBu setSelected:YES];
        for (UIButton * dragBu in m_showItemsView.subviews)
        {
            UIButton * deleteBu = (UIButton *)[dragBu viewWithTag:1000];
            [deleteBu setHidden:NO];
        }
    }
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [self dragTileBegan:recognizer];
            [self startShake:recognizer.view];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self dragTileMoved:recognizer];
            break;//开始时忘记加break，一直执行结束方法
        }
        case UIGestureRecognizerStateEnded:
        {
            [self dragTileEnded:recognizer];
            [self stopShake:recognizer.view];
            break;
        }
            
        default:
            break;
    }
    
}

/**
 * @函数名称：dragTileBegan:
 * @函数描述：拖动手势开始，记录拖动的起始位置，并把拖动的view做放大处理
 * @输入参数：(UIPanGestureRecognizer *)recognizer
 * @输出参数：void
 * @返回值：void
 */
- (void)dragTileBegan:(UIGestureRecognizer *)recognizer
{
    //把要移动的视图放在顶层
    [m_showItemsView bringSubviewToFront:recognizer.view];
    
    _dragFromPoint = recognizer.view.center;
}

/**
 * @函数名称：dragTileMoved:
 * @函数描述：拖动手势进行中，获取手势在界面的位置（location），把拖动的view的center设为location
 * @输入参数：(UIPanGestureRecognizer *)recognizer
 * @输出参数：void
 * @返回值：void
 */
- (void)dragTileMoved:(UIGestureRecognizer *)recognizer
{
    CGPoint locationPoint = [recognizer locationInView:m_showItemsView];
    recognizer.view.center = locationPoint;
    [self pushedTileMoveToDragFromPointIfNecessaryWithTileView:(UIImageView *)recognizer.view];
}

/**
 * @函数名称：pushedTileMoveToDragFromPointIfNecessaryWithTileView:
 * @函数描述：拖动手势进行中，判断被拖动的界面是否移动到另一界面所在frame
 * @输入参数：(UIPanGestureRecognizer *)recognizer
 * @输出参数：void
 * @返回值：void
 */
- (void)pushedTileMoveToDragFromPointIfNecessaryWithTileView:(UIView *)tileView
{
    for (UIButton *item in m_showItemsView.subviews)
    {
        //移动到另一个按钮的区域，判断需要移动按钮的位置
        if (CGRectContainsPoint(item.frame, tileView.center) && item != tileView )
        {
            
            //开始的位置
            NSInteger fromIndex = tileView.tag - 100;
            //需要移动到的位置
            NSInteger toIndex = (item.tag - 100)>0?(item.tag - 100):0;
            NSLog(@"从位置%ld移动到位置%ld",fromIndex, (long)toIndex);
            [self dragMoveFromIndex:fromIndex ToIndex:toIndex withView:tileView];
        }
    }
}

/**
 * @函数名称：dragMoveFromIndex:ToIndex:withView:
 * @函数描述：拖动view交换位置
 * @输入参数：(NSInteger)fromIndex：被移动view的位置在第几个
 (NSInteger)toIndex：移动到的位置
 (UIImageView *)tileView：被移动的view
 * @输出参数：void
 * @返回值：void
 */
- (void)dragMoveFromIndex:(NSInteger)fromIndex ToIndex:(NSInteger)toIndex withView:(UIView *)tileView
{
    //局部变量是不能在闭包中发生改变的，所以需要把_dragFromPoint，_dragToPoint定义成全局变量
    __block NSMutableArray * bnewAlbumlist = m_showItemsList;
    __block UIScrollView * bphotoScrol = m_showItemsView;
    NSDictionary * moveDict = [bnewAlbumlist objectAtIndex:fromIndex];
    [bnewAlbumlist removeObjectAtIndex:fromIndex];
    [bnewAlbumlist insertObject:moveDict atIndex:toIndex];
    //向前移动
    if (fromIndex > toIndex)
    {
        //把移动相册的上一个相册移动到记录的移动相册的位置，并把上一相册的位置记为新的_dragFromPoint，并把view的tag值+1,依次处理
        [UIView animateWithDuration:0.3 animations:^{
            
            for (NSInteger i = fromIndex - 1; i >= toIndex; i--)
            {
                UIButton * dragBu = (UIButton *)[bphotoScrol viewWithTag:i + 100];
                _dragToPoint = dragBu.center;
                dragBu.center = _dragFromPoint;
                _dragFromPoint = _dragToPoint;
                dragBu.tag ++;
            }
            tileView.tag = 100 + toIndex;
            
        }];
        
    }
    //向后移动
    else
    {
        //把移动相册的下一个相册移动到记录的移动相册的位置，并把下一相册的位置记为新的_dragFromPoint，并把view的tag值-1,依次处理
        [UIView animateWithDuration:0.3 animations:^{
            for (NSInteger i = fromIndex + 1; i <= toIndex; i++)
            {
                UIButton * dragBu = (UIButton *)[bphotoScrol viewWithTag:i + 100];
                _dragToPoint = dragBu.center;
                dragBu.center = _dragFromPoint;
                _dragFromPoint = _dragToPoint;
                dragBu.tag --;
            }
            tileView.tag = 100 + toIndex;
            
        }];
    }
    
}

/**
 * @函数名称：dragTileEnded:
 * @函数描述：拖动手势完成，把拖动的界面放到最后记录的位置
 * @输入参数：(UIPanGestureRecognizer *)recognizer
 * @输出参数：void
 * @返回值：void
 */
- (void)dragTileEnded:(UIGestureRecognizer *)recognizer
{
    //    [UIView animateWithDuration:0.2f animations:^{
    //        recognizer.view.transform = CGAffineTransformMakeScale(1.f, 1.f);
    //        recognizer.view.alpha = 1.f;
    //    }];
    
    [UIView animateWithDuration:0.2f animations:^{
        if (_isDragTileContainedInOtherTile)
            recognizer.view.center = _dragToPoint;
        else
            recognizer.view.center = _dragFromPoint;
    }];
    _isDragTileContainedInOtherTile = NO;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
