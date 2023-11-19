//
//  MapViewController.swift
//  MyMap
//
//  Created by 이지현 on 2023/11/19.
//

import UIKit
import CoreLocation
import KakaoMapsSDK


class MapViewController: KakaoMapViewController {
    
    var locationManager = CLLocationManager()
    var currentPosition: MapPoint?
    
    private lazy var searchController = {
        let controller = UISearchController(searchResultsController: ResultsTableViewController())
        controller.searchBar.placeholder = "가고 싶은 장소를 검색해보세요"
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Map"
        navigationItem.searchController = searchController
        
        setLocationManager()
    }
    
    override func addViews() {
        var defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        if let currentPosition {
            defaultPosition = currentPosition
        }
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        if mapController?.addView(mapviewInfo) == Result.OK {
            print("OK")
        }
    }
    
    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentPosition = MapPoint(longitude: locations[0].coordinate.longitude, latitude: locations[0].coordinate.latitude)
    }
    
}


