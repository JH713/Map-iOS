//
//  MapViewController.swift
//  MyMap
//
//  Created by 이지현 on 2023/11/19.
//

import UIKit
import KakaoMapsSDK

class MapViewController: KakaoMapViewController {
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        if mapController?.addView(mapviewInfo) == Result.OK {
            print("OK")
        }
    }
}


