//
//  main.m
//  WakeupChecker
//
//  Created by kamigaki on 2013/07/22.
//  Copyright (c) 2013年 sandwitchman. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <AppleScriptObjC/AppleScriptObjC.h>

int main(int argc, char *argv[])
{
    [[NSBundle mainBundle] loadAppleScriptObjectiveCScripts];
    return NSApplicationMain(argc, (const char **)argv);
}
