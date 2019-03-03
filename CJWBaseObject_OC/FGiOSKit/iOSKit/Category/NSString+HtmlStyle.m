//
//  NSString+HtmlStyle.m
//  HomeHealth
//
//  Created by 陈经纬 on 16/12/1.
//  Copyright © 2016年 陈经纬. All rights reserved.
//

#import "NSString+HtmlStyle.h"

@implementation NSString (HtmlStyle)

- (NSString *)disposeHtml
{
    NSString *topString =  @"<!DOCTYPE html>\n"
    "<html>\n"
    "<head>\n"
    "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1\">\n" 
    "    <title></title>\n"
    "    <style type=\"text/css\">\n"
    "        body{\n"
    "        margin:0px;"
    ""
    "     padding:12px;}\n"
    "        img{\n"
    "        height:auto;\n"
    "        text-align:center;\n"
    "        width:100%;\n"
    "        margin:10px 0px 10px 0px\n"
    
    "        }\n"
    "        video{\n"
    "        text-align:center;\n"
    "        width:100%;\n"
    "        margin:0px\n"
    "        max-width:100%;\n"
    "        }\n"
    "\n"
    "    </style>\n"
    "</head>\n"
    "<body>";
    return [NSString stringWithFormat:@"%@%@</body>\n</html>", topString, self];
}

- (NSString *)fitSizeHtml
{
    NSString *topString =
    @"<!DOCTYPE html>\n"
    "<html>\n"
    "<head>\n"
    "    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />\n"
    "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1\">\n"
    "    <title></title>\n"
    "    <style type=\"text/css\">\n"
    "        body{\n"
    "        margin:12px}\n"
    "       font-family:\"PingFangSC-Regula\";"
    "        img{\n"
    "        height:auto;\n"
    "        text-align:center;\n"
    "        width:100%;\n"
    "        max-width:100%;\n"
    "        margin:0px\n"
    "        }\n"
    "        video{\n"
    "        text-align:center;\n"
    "        width:100%;\n"
    "        margin:0px\n"
    "        max-width:100%;\n"
    "        }\n"
    "\n"
    "    </style>\n"
    "<script type=\"text/javascript\">\n"
    "window.onload =function(){\n"
    "    var list =  document.getElementsByTagName(\"p\");\n"
    "       \n"
    "      for (var i = 0; i < list.length; i++) {\n"
    "           var  item = list[i];\n"
    "            var has_img = item.getElementsByTagName('img');\n"
    "            var has_iframe = item.getElementsByTagName('iframe');\n"
    "            var has_video = item.getElementsByTagName('video');\n"
    "            if(has_img.length>0||has_iframe.length>0||has_video.length>0){\n"
    "               \n"
    "            }else{\n"
    "                 item.style.paddingLeft=\"12px\";\n"
    "                  item.style.paddingRight=\"12px\";\n"
    "            }\n"
    "      }\n"
    "       var list =  document.getElementsByTagName(\"h\");\n"
    "           for (var i = 0; i < list.length; i++) {\n"
    "             var  item = list[i];\n"
    "               item.style.paddingLeft=\"12px\";\n"
    "                  item.style.paddingRight=\"12px\";\n"
    "           }\n"
    "}\n"
    "     \n"
    "</script>\n"
    "</head>\n"
    "<body>";
    return [NSString stringWithFormat:@"%@%@</body>\n</html>", topString, self];
}

@end
