//
//  SFLog.swift
//  SFIntegration
//
//  Created by Sean on 2023/8/4.
//

import Foundation
enum SFDemoLogLevel:Int {
    case info = 0 // 信息
    case warn = 1 // 警告
    case debug = 2 // 调试信息
    case error = 3 // 错误
}
final class SFLog{
    static func msg(_ msg:String!,level lvl:SFDemoLogLevel){
        let args: [CVarArg] = [msg]
//        withVaList(args){SFLog.inerMsg(format: "%@",withArgs: $0,level: lvl)}
//        #if DEBUG
        NSLog("%@",msg);
//        #else
//        #endif
    }
    
//   private static func inerMsg(format:String!,withArgs args:CVaListPointer,level lvl:SFDemoLogLevel){
////       if lvl == .info{
////           BLYLogv(.info, format, args)
////       }else if lvl == .error{
////           BLYLogv(.error, format, args)
////       }else if lvl == .warn{
////           BLYLogv(.warn, format, args)
////       }else if lvl == .debug{
////           BLYLogv(.debug, format, args)
////       }
//    }
    
    static func i<T>(_ message:T,file:String = #file,funcName:String = #function,lineNum:Int = #line){
        let msgDes = NSString.init(string: "\(message)")
        let fileDes = NSString.init(string: "\(file)")
        let funcDes = NSString.init(string: "\(funcName)")
        let lineDes = NSString.init(string: "\(lineNum)")
        let msg = String.init(format: "[SFDemo][%@ %@][%@]%@\n", fileDes.lastPathComponent,funcDes,lineDes,msgDes)
        SFLog.msg(msg, level: .info)
    }
    
    static func e<T>(_ message:T,file:String = #file,funcName:String = #function,lineNum:Int = #line){
        let msgDes = NSString.init(string: "\(message)")
        let fileDes = NSString.init(string: "\(file)")
        let funcDes = NSString.init(string: "\(funcName)")
        let lineDes = NSString.init(string: "\(lineNum)")
        let msg = String.init(format: "[SFDemo][%@ %@][%@]%@\n", fileDes.lastPathComponent,funcDes,lineDes,msgDes)
        SFLog.msg(msg, level: .error)
    }
    
    static func w<T>(m_ message:T,file:String = #file,funcName:String = #function,lineNum:Int = #line){
        let msgDes = NSString.init(string: "\(message)")
        let fileDes = NSString.init(string: "\(file)")
        let funcDes = NSString.init(string: "\(funcName)")
        let lineDes = NSString.init(string: "\(lineNum)")
        let msg = String.init(format: "[SFDemo][%@ %@][%@]%@\n", fileDes.lastPathComponent,funcDes,lineDes,msgDes)
        SFLog.msg(msg, level: .warn)
    }
    
    static func d<T>(m_ message:T,file:String = #file,funcName:String = #function,lineNum:Int = #line){
        let msgDes = NSString.init(string: "\(message)")
        let fileDes = NSString.init(string: "\(file)")
        let funcDes = NSString.init(string: "\(funcName)")
        let lineDes = NSString.init(string: "\(lineNum)")
        let msg = String.init(format: "[SFDemo][%@ %@][%@]%@\n", fileDes.lastPathComponent,funcDes,lineDes,msgDes)
        SFLog.msg(msg, level: .debug)
    }
}
