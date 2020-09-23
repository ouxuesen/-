//
//  DZMMainController.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class DZMMainUnitl:NSObject {
   
    @objc func show(){
    print("我呗点击了")
    }
    // 全本解析阅读
    @objc public func fullRead(_ viewController:UIViewController?,_ path:String!) {
        
        print("缓存文件地址:", DZM_READ_DOCUMENT_DIRECTORY_PATH)
        
        MBProgressHUD.showLoading("全本解析(第一次进入)速度慢", to: viewController?.view)
      
        let url = URL.init(fileURLWithPath: path)
        
        print("全本解析开始时间:",TimerString("YYYY-MM-dd-HH-mm-ss"), Date().timeIntervalSince1970)
        
        DZMReadTextParser.parser(url: url ) { [weak self] (readModel) in
            
            print("全本解析结束时间:",TimerString("YYYY-MM-dd-HH-mm-ss"), Date().timeIntervalSince1970)
            
            MBProgressHUD.hide(viewController?.view)
            
            if readModel == nil {
                
                MBProgressHUD.showMessage("全本解析失败")
                
                return
            }
            
            let vc  = DZMReadController()
            
            vc.readModel = readModel
            
            viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc class func quiteRead(bookId:String,viewcontroller:UIViewController?) -> Void {
        let vc  = DZMReadController()
        
        vc.readModel = DZMReadModel.model(bookID: bookId)
        viewcontroller?.hidesBottomBarWhenPushed = true
        viewcontroller?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
//    // 跳转网络小说初次进入使用例子(按照这样进入阅读页之后,只需要全局搜索 "搜索网络小说" 的地方加入请求章节就好了)
//    @objc private func readNetwork() {
//
//        MBProgressHUD.showLoading(view)
//
//        // 获得阅读模型
//        // 网络小说的话, readModel 里面有个 chapterListModels 字段,这个是章节列表,我里面有数据是因为我是全本解析本地需要有个地方存储,网络小说可能一开始没有
//        // 运行会在章节列表UI定位的地方崩溃,直接注释就可以了,网络小说的章节列表可以直接在章节列表UI里面单独请求在定位处理。
//        let readModel = DZMReadModel.model(bookID: bookID)
//
//        // 检查是否当前将要阅读的章节是否等于阅读记录
//        if chapterID != readModel.recordModel.chapterModel?.id { // 如果不一致则需要检查本地是否有没有,没有则下载,并修改阅读记录为该章节。
//
//            // 检查马上要阅读章节是否本地存在
//            if DZMReadChapterModel.isExist(bookID: bookID, chapterID: chapterID) { // 存在
//
//                MBProgressHUD.hide(view)
//
//                // 如果存在则修改阅读记录
//                readModel.recordModel.modify(chapterID: chapterID, location: 0)
//
//                let vc  = DZMReadController()
//
//                vc.readModel = readModel
//
//                navigationController?.pushViewController(vc, animated: true)
//
//            }else{ // 如果不存在则需要加载网络数据
//
//                // 获取当前需要阅读的章节
//                NJHTTPTool.request_novel_read(bookID, chapterID) { [weak self] (type, response, error) in
//
//                    MBProgressHUD.hide(self?.view)
//
//                    if type == .success {
//
//                        // 获取章节数据
//                        let data = HTTP_RESPONSE_DATA_DICT(response)
//
//                        // 解析章节数据
//                        let chapterModel = DZMReadChapterModel(data)
//
//                        // 章节类容需要进行排版一篇
//                        chapterModel.content = DZMReadParser.contentTypesetting(content: chapterModel.content)
//
//                        // 保存
//                        chapterModel.save()
//
//                        // 如果存在则修改阅读记录
//                        readModel.recordModel.modify(chapterID: chapterModel.chapterID, location: 0)
//
//                        let vc  = DZMReadController()
//
//                        vc.readModel = readModel
//
//                        self?.navigationController?.pushViewController(vc, animated: true)
//
//                    }else{
//
//                        // 加载失败
//                    }
//                }
//            }
//
//        }else{ // 如果是一致的就继续阅读。也可以在下面使用 readModel.recordModel.modify(xxx) 进行修改更新阅读页面或者位置
//
//            MBProgressHUD.hide(view)
//
//            let vc  = DZMReadController()
//
//            vc.readModel = readModel
//
//            navigationController?.pushViewController(vc, animated: true)
//        }
//    }
}
