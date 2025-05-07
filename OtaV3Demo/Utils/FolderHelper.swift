import Foundation

class FolderHelper: NSObject {
    static func DocumentPath()->String{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    static func DFUFolderPath()->String{
        let document = NSString.init(string: DocumentPath())
        let dfuFolder = document.appendingPathComponent("DFUFiles")
        
        let manager = FileManager.default
        var isDir = ObjCBool.init(false)
        let existed = manager.fileExists(atPath: dfuFolder, isDirectory: &isDir)
        if existed == false || isDir.boolValue == false {
            // 创建文件夹
            try? manager.createDirectory(atPath: dfuFolder, withIntermediateDirectories: true, attributes: nil)
        }
        
        return dfuFolder
        
    }
    
    static func DialPlateFolderPath()->String{
        let document = NSString.init(string: DocumentPath())
        let dfuFolder = document.appendingPathComponent("DialPlateFiles")
        
        let manager = FileManager.default
        var isDir = ObjCBool.init(false)
        let existed = manager.fileExists(atPath: dfuFolder, isDirectory: &isDir)
        if existed == false || isDir.boolValue == false {
            // 创建文件夹
            try? manager.createDirectory(atPath: dfuFolder, withIntermediateDirectories: true, attributes: nil)
        }
        
        return dfuFolder
        
    }
    
    static func LogRootPath() -> String{
        let document = NSString.init(string: DocumentPath())
        let logFolder = document.appendingPathComponent("Logs")
        
        let manager = FileManager.default
        var isDir = ObjCBool.init(false)
        let existed = manager.fileExists(atPath: logFolder, isDirectory: &isDir)
        if existed == false || isDir.boolValue == false {
            // 创建文件夹
            try? manager.createDirectory(atPath: logFolder, withIntermediateDirectories: true, attributes: nil)
        }
        
        return logFolder
    }
    
    static func deviceLogPath() -> String{
        let document = NSString.init(string: DocumentPath())
        let logFolder = document.appendingPathComponent("DevLogs")
        
        let manager = FileManager.default
        var isDir = ObjCBool.init(false)
        let existed = manager.fileExists(atPath: logFolder, isDirectory: &isDir)
        if existed == false || isDir.boolValue == false {
            // 创建文件夹
            try? manager.createDirectory(atPath: logFolder, withIntermediateDirectories: true, attributes: nil)
        }
        
        return logFolder
    }
    
    static func deviceAssetPath() -> String{
        let document = NSString.init(string: DocumentPath())
        let logFolder = document.appendingPathComponent("DevAssets")
        
        let manager = FileManager.default
        var isDir = ObjCBool.init(false)
        let existed = manager.fileExists(atPath: logFolder, isDirectory: &isDir)
        if existed == false || isDir.boolValue == false {
            // 创建文件夹
            try? manager.createDirectory(atPath: logFolder, withIntermediateDirectories: true, attributes: nil)
        }
        
        return logFolder
    }
    
    static func deviceAudioDumpPath() -> String{
        let document = NSString.init(string: DocumentPath())
        let logFolder = document.appendingPathComponent("DevAudioDump")
        
        let manager = FileManager.default
        var isDir = ObjCBool.init(false)
        let existed = manager.fileExists(atPath: logFolder, isDirectory: &isDir)
        if existed == false || isDir.boolValue == false {
            // 创建文件夹
            try? manager.createDirectory(atPath: logFolder, withIntermediateDirectories: true, attributes: nil)
        }
        
        return logFolder
    }
    
    
    ///  构建批量测试目录
    ///  会删除后重建
    /// - Returns: l路径
    static func makeEzipMutilDirSourcePath() -> String{
        let document = NSString.init(string: DocumentPath())
        let logFolder = document.appendingPathComponent("EzipMutilSource")
        
        let manager = FileManager.default
        var isDir = ObjCBool.init(false)
        let existed = manager.fileExists(atPath: logFolder, isDirectory: &isDir)
        if existed {
            try? manager.removeItem(atPath: logFolder)
        }
        
        // 创建文件夹
        try? manager.createDirectory(atPath: logFolder, withIntermediateDirectories: true, attributes: nil)
        
        
        return logFolder
    }
    
    
    ///  生成并清空Ezip目标目录
    /// - Returns:
    static func makeEzipMutilDirTargetPath() -> String{
        let document = NSString.init(string: DocumentPath())
        let logFolder = document.appendingPathComponent("EzipMutilTarget")
        
        let manager = FileManager.default
        var isDir = ObjCBool.init(false)
        let existed = manager.fileExists(atPath: logFolder, isDirectory: &isDir)
        if existed {
            try? manager.removeItem(atPath: logFolder)
        }
        
        // 创建文件夹
        try? manager.createDirectory(atPath: logFolder, withIntermediateDirectories: true, attributes: nil)
        
        
        return logFolder
    }
    
    static func getMutilDirTarget() -> String{
        let document = NSString.init(string: DocumentPath())
        let logFolder = document.appendingPathComponent("EzipMutilTarget")
        
        let manager = FileManager.default
        var isDir = ObjCBool.init(false)
        let existed = manager.fileExists(atPath: logFolder, isDirectory: &isDir)
        if existed == false || isDir.boolValue == false {
            // 创建文件夹
            try? manager.createDirectory(atPath: logFolder, withIntermediateDirectories: true, attributes: nil)
        }
        return logFolder;
    }
    
    
    /// 自动化测试时将下发的文件下载到这个目录，可能定期删除
    /// - Returns: 目录地址
    static func AutoTestFilePath() -> String{
        let document = NSString.init(string: DocumentPath())
        let logFolder = document.appendingPathComponent("AutoTestFile")
        
        let manager = FileManager.default
        var isDir = ObjCBool.init(false)
        let existed = manager.fileExists(atPath: logFolder, isDirectory: &isDir)
        if existed == false || isDir.boolValue == false {
            // 创建文件夹
            try? manager.createDirectory(atPath: logFolder, withIntermediateDirectories: true, attributes: nil)
        }
        
        return logFolder
    }
    
    static func makeDeviceLogFilePath() -> String{
        let logDir = deviceLogPath()
//        let formatter = DateFormatter.init()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        Date.now
        let filePath = NSString.init(string: logDir).appendingPathComponent("/20230807-1.log")
    
        return filePath;
    }
    
    static func allFileInDir(rootPath:URL) -> [String]?{
       
       let fileManager = FileManager.default
       var filePathArray = Array<String>.init()
       let contents = fileManager.enumerator(atPath: rootPath.path)!
       while let content = contents.nextObject(){
           guard let s =  content as? String else{
               SFLog.e("unzip failed: could not convert '\(content)' to String")
               return nil
           }
           var isDir = ObjCBool.init(false)
           let filePath = rootPath.appendingPathComponent(s).path
           fileManager.fileExists(atPath:filePath, isDirectory: &isDir)
           if isDir.boolValue == false{
               filePathArray.append(filePath)
           }
       }
       return filePathArray
   }
    
    
    
}
