//
//  KakaoMapViewController.swift
//  MyMap
//
//  Created by 이지현 on 2023/11/20.
//

import UIKit
import SnapKit
import KakaoMapsSDK

class KakaoMapViewController: UIViewController, MapControllerDelegate {
    
    var mapContainer: KMViewContainer?
    var mapController: KMController?
    var _observerAdded: Bool
    
    private lazy var mapView: KMViewContainer = {
        let view = KMViewContainer()
        return view
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        _observerAdded = false
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        mapController?.stopRendering()
        mapController?.stopEngine()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupLayout()
        
        guard let kmController =
                KMController(viewContainer: mapView) else { return }
        mapController = kmController
        mapContainer = mapView
        mapController?.delegate = self
        
        mapController?.initEngine() //엔진 초기화. 엔진 내부 객체 생성 및 초기화가 진행된다.
//        mapController?.authenticate()
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        addObservers()

        if mapController?.engineStarted == false {
            mapController?.startEngine()
        }
        
        if mapController?.rendering == false {
            mapController?.startRendering()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapController?.startRendering()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapController?.stopRendering()
    }

    override func viewDidDisappear(_ animated: Bool) {
        removeObservers()
        mapController?.stopEngine()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // 여기서 지도 뷰를 로드하거나 업데이트
        if mapController == nil {
            initializeMapView()
        }
    }

    func initializeMapView() {
        guard let kmController = KMController(viewContainer: mapView) else { return }
        mapController = kmController
        mapContainer = mapView
        mapController?.delegate = self
        mapController?.initEngine() //엔진 초기화
        mapController?.startRendering() //렌더링 시작
    }
    
    func authenticationSucceeded() {
        if mapController?.engineStarted == true {
            mapController?.stopEngine()
            mapController?.stopRendering()
        }
        
            mapController?.startEngine()    //엔진 시작 및 렌더링 준비. 준비가 끝나면 MapControllerDelegate의 addViews 가 호출된다.
            mapController?.startRendering() //렌더링 시작.
    }
    
    func authenticationFailed(_ errorCode: Int, desc: String) {
        
        print("error code: \(errorCode)")
        print("msg: \(desc)")
    }
    
    func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        if mapController?.addView(mapviewInfo) == Result.OK {
            print("OK")
        }
    }
    
    func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)

    }
    
    func addObservers(){
         NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    
         _observerAdded = true
     }
     
     func removeObservers(){
         NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
         NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
     
          _observerAdded = false
     }
     
     @objc func willResignActive(){
         mapController?.stopRendering()
     }
     
     @objc func didBecomeActive(){
         print("becomeActive!!!!")
         mapController?.startEngine()
         mapController?.startRendering()
     }
}

