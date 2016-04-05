//
//  DownloadManagerDelegate.swift
//  FileDownloaderSwift
//
//  Created by Purohit, Gaurav C on 4/4/16.
//  Copyright © 2016 Purohit, Gaurav C on 4/4/16. All rights reserved.
//

import UIKit

protocol DownloadManagerProtocol {
    //Called when the file has been download and saved on Documents directory
    func downloadedFileAtPath(path: NSURL)
    //Called during the downlod to manage UI information
    func downloadedMbytesFromTotal(downloaded: Int64, total: Int64)
}