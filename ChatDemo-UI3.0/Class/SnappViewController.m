//
//  SnappViewController.m
//  ChatDemo-UI3.0
//
//  Created by fuzheng on 9/12/15.
//  Copyright © 2015年 fuzheng. All rights reserved.
//

#import "SnappViewController.h"

@interface SnappViewController (){
    NSString* _snappQuery;
    UIWebView* _snappWebView;
    NSString* _originHtml;
    NSURLConnection* _snappConnection;
    BOOL _isOrign;
    BOOL _isThirdPageClick;
    NSMutableArray* _urlArray;
    UIActivityIndicatorView* _activityView;
}

@end

@implementation SnappViewController

- (instancetype)initWithSnappQuery:(NSString *)SnappQuery
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _snappQuery = SnappQuery;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.title = _snappQuery;
    _urlArray = [NSMutableArray array];
    _isOrign = YES;
    _isThirdPageClick = NO;
    _snappWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    //    snappWebView.layer.masksToBounds = YES;
    //    snappWebView.layer.cornerRadius = 8.0;
    _snappWebView.scalesPageToFit = YES;
    _snappWebView.backgroundColor = [UIColor whiteColor];
    _snappWebView.delegate = self;
    //    [snappWebView.layer setBorderColor:[[UIColor blackColor] CGColor]];
    //    [snappWebView.layer setBorderWidth:2.0f];
    [self.view addSubview:_snappWebView];
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5);
    [self.view addSubview:_activityView];
    _activityView.hidesWhenStopped = YES;
    [_activityView startAnimating];
    [self requestSnappData];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBarButtonItem];
}

-(void)requestSnappData{
    NSURL *url = [NSURL URLWithString:@"https://www.bing.com/widget/snapp?mkt=en-us"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:1000];
    [request setHTTPMethod:@"POST"];
     NSString* str = [NSString stringWithFormat: @"{\"content\":\"%@\",\"location\":{\"latitude\":39.97913,\"longitude\":116.304672},\"modelVersion\":-1,\"packageName\":\"com.sec.android.app.sbrowser\",\"packageVersionName\":\"3.2.38.64-1_100601_540226\",\"title\":\"\"}",_snappQuery];
    
    str = [NSString stringWithFormat:@"%@%@%@",@"context=",[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"&language=en-US&market=US"];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    if (_snappConnection) {
        [_snappConnection cancel];
    }
    _snappConnection = [[NSURLConnection alloc]initWithRequest:request
                                                      delegate:self];
}

//First response
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _originHtml = [NSString string];
}
//receive
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    _originHtml = [_originHtml stringByAppendingString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
}
//finish
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_snappWebView loadHTMLString:_originHtml baseURL:[NSURL URLWithString:@""]];
    
}
//error
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error");
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(navigationType == UIWebViewNavigationTypeLinkClicked){
        NSString* linkUrl = [[request URL] absoluteString];
        NSRange range = [linkUrl rangeOfString:@"file://"];
        if(_isOrign){
            _isOrign = NO;
            if (range.length > 0) {
                
                linkUrl = [linkUrl stringByReplacingCharactersInRange:range withString:@"http://www.bing.com"];
                
            }
            NSMutableURLRequest *newRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:linkUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:1000];
            [_snappWebView loadRequest:newRequest];
        }
        else{
            _isThirdPageClick = YES;
        }
    }
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [_activityView startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [_activityView stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)back
{
    if (_isOrign) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(_isThirdPageClick && _snappWebView.canGoBack){
        [_snappWebView goBack];
        _isThirdPageClick = NO;
    }else{
         [_snappWebView loadHTMLString:_originHtml baseURL:[NSURL URLWithString:@""]];
           _isOrign = YES;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
