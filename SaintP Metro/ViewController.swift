//
//  ViewController.swift
//  SaintP Metro
//
//  Created by user on 09.08.2021.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var showDetailsButton: UIButton!
  @IBOutlet weak var mapView: UIView!
  @IBOutlet weak var fromStationLabel: UILabel!
  @IBOutlet weak var toStationLabel: UILabel!
  
  var pinchGestureRecognizer = UIPinchGestureRecognizer()
  var panGestureRecognizer = UIPanGestureRecognizer()
  var initialCenter = CGPoint()
  
  var buttonDiameter: CGFloat {
    self.view.layer.frame.width / 40
  }
  
  let spbMetro = MetroGraph()
  
  var fromStation: Station?
  var toStation: Station?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.clipsToBounds = false
    mapView.isUserInteractionEnabled = true
    mapView.addGestureRecognizer(pinchGestureRecognizer)
    mapView.addGestureRecognizer(panGestureRecognizer)
    pinchGestureRecognizer.addTarget(self, action: #selector(pinchGesture))
    panGestureRecognizer.addTarget(self, action: #selector(panGesture))
    
    showDetailsButton.layer.cornerRadius = showDetailsButton.bounds.height / 4
    
    //Line 1 stations
    let deviatkinoStation = createButtonLabelAndStationWith(title: "Девяткино", x: 231, y: 107, lineNumber: 1)
    let grazhdanskiiProspektStation = createButtonLabelAndStationWith(title: "Гражданский проспект", x: 231, y: 125, lineNumber: 1)
    let akademicheskaiaStation = createButtonLabelAndStationWith(title: "Академическая", x: 231, y: 143, lineNumber: 1)
    let politekhnicheskaiaStation = createButtonLabelAndStationWith(title: "Политехническая", x: 231, y: 161, lineNumber: 1)
    let ploshadMuzhestvaStation = createButtonLabelAndStationWith(title: "Площадь Мужества", x: 231, y: 179, lineNumber: 1)
    let lesnaiaStation = createButtonLabelAndStationWith(title: "Лесная", x: 231, y: 197, lineNumber: 1)
    let vyborgskaiaStation = createButtonLabelAndStationWith(title: "Выборгская", x: 231, y: 215, lineNumber: 1)
    let ploshadLeninaStation = createButtonLabelAndStationWith(title: "Площадь Ленина", x: 231, y: 233, lineNumber: 1)
    let chernyshevskaiaStation = createButtonLabelAndStationWith(title: "Чернышевская", x: 231, y: 260, lineNumber: 1)
    let ploshadVosstaniiaStation = createButtonLabelAndStationWith(title: "Площадь Восстания", x: 231, y: 278, lineNumber: 1)
    let vladimirskaiaStation = createButtonLabelAndStationWith(title: "Владимирская", x: 231, y: 340, lineNumber: 1)
    let pushkinskaiaStation = createButtonLabelAndStationWith(title: "Пушкинская", x: 191, y: 364, lineNumber: 1)
    let tekhnolozhka1Station = createButtonLabelAndStationWith(title: "Технологический институт 1", x: 166, y: 380, lineNumber: 1, isLabelToLeft: true)
    let baltiiskaiaStation = createButtonLabelAndStationWith(title: "Балтийская", x: 102, y: 424, lineNumber: 1, isLabelToLeft: true)
    let narvskaiaStation = createButtonLabelAndStationWith(title: "Нарвская", x: 102, y: 440, lineNumber: 1, isLabelToLeft: true)
    let kirovskiiZavodStation = createButtonLabelAndStationWith(title: "Кировский завод", x: 102, y: 458, lineNumber: 1, isLabelToLeft: true)
    let avtovoStation = createButtonLabelAndStationWith(title: "Автово", x: 102, y: 476, lineNumber: 1, isLabelToLeft: true)
    let leninskiiProspektStation = createButtonLabelAndStationWith(title: "Ленинский проспект", x: 102, y: 512, lineNumber: 1, isLabelToLeft: true)
    let prospektVeteranovStation = createButtonLabelAndStationWith(title: "Проспект Ветеранов", x: 102, y: 532, lineNumber: 1, isLabelToLeft: true)
    
    spbMetro.addEdgeBetween(deviatkinoStation, and: grazhdanskiiProspektStation, withWeight: 4)
    spbMetro.addEdgeBetween(grazhdanskiiProspektStation, and: akademicheskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(akademicheskaiaStation, and: politekhnicheskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(politekhnicheskaiaStation, and: ploshadMuzhestvaStation, withWeight: 4)
    spbMetro.addEdgeBetween(ploshadMuzhestvaStation, and: lesnaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(lesnaiaStation, and: vyborgskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(vyborgskaiaStation, and: ploshadLeninaStation, withWeight: 4)
    spbMetro.addEdgeBetween(ploshadLeninaStation, and: chernyshevskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(chernyshevskaiaStation, and: ploshadVosstaniiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(ploshadVosstaniiaStation, and: vladimirskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(vladimirskaiaStation, and: pushkinskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(pushkinskaiaStation, and: tekhnolozhka1Station, withWeight: 4)
    spbMetro.addEdgeBetween(tekhnolozhka1Station, and: baltiiskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(baltiiskaiaStation, and: narvskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(narvskaiaStation, and: kirovskiiZavodStation, withWeight: 4)
    spbMetro.addEdgeBetween(kirovskiiZavodStation, and: avtovoStation, withWeight: 4)
    spbMetro.addEdgeBetween(avtovoStation, and: leninskiiProspektStation, withWeight: 4)
    spbMetro.addEdgeBetween(leninskiiProspektStation, and: prospektVeteranovStation, withWeight: 4)
    
    vladimirskaiaStation.button.label.center.x -= vladimirskaiaStation.button.label.frame.width / 2
    vladimirskaiaStation.button.label.center.y += buttonDiameter
    
    //Line 2 stations
    let parnasStation = createButtonLabelAndStationWith(title: "Парнас", x: 166, y: 60, lineNumber: 2)
    let prospektProsvesheniiaStation = createButtonLabelAndStationWith(title: "Проспект\nПросвещения", x: 166, y: 80, lineNumber: 2)
    let ozerkiStation = createButtonLabelAndStationWith(title: "Озерки", x: 166, y: 98, lineNumber: 2)
    let udelnaiaStation = createButtonLabelAndStationWith(title: "Удельная", x: 166, y: 116, lineNumber: 2)
    let pionerskaiaStation = createButtonLabelAndStationWith(title: "Пионерская", x: 166, y: 134, lineNumber: 2)
    let chernaiaRechkaStation = createButtonLabelAndStationWith(title: "Черная\nречка", x: 166, y: 152, lineNumber: 2)
    let petrogradskaiaStation = createButtonLabelAndStationWith(title: "Петроградская", x: 166, y: 205, lineNumber: 2)
    let gorkovskaiaStation = createButtonLabelAndStationWith(title: "Горьковская", x: 166, y: 233, lineNumber: 2)
    let nevskiiProspektStation = createButtonLabelAndStationWith(title: "Невский\nпроспект", x: 166, y: 278, lineNumber: 2)
    let sennaiaStation = createButtonLabelAndStationWith(title: "Сенная площадь", x: 166, y: 340, lineNumber: 2, isLabelToLeft: true)
    let tekhnolozhka2Station = createButtonLabelAndStationWith(title: "Технологический институт 2", x: 166, y: 390, lineNumber: 2, isLabelToLeft: true)
    let frunzenskaiaStation = createButtonLabelAndStationWith(title: "Фрунзенская", x: 166, y: 414, lineNumber: 2, isLabelToLeft: true)
    let moskovskieVorotaStation = createButtonLabelAndStationWith(title: "Московские\nворота", x: 166, y: 432, lineNumber: 2, isLabelToLeft: true)
    let elektrosilaStation = createButtonLabelAndStationWith(title: "Электросила", x: 166, y: 449, lineNumber: 2, isLabelToLeft: true)
    let parkPobedyStation = createButtonLabelAndStationWith(title: "Парк Победы", x: 166, y: 467, lineNumber: 2, isLabelToLeft: true)
    let moskovskaiaStation = createButtonLabelAndStationWith(title: "Московская", x: 166, y: 485, lineNumber: 2, isLabelToLeft: true)
    let zvezdnaiaStation = createButtonLabelAndStationWith(title: "Звездная", x: 166, y: 532, lineNumber: 2, isLabelToLeft: true)
    let kupchinoStation = createButtonLabelAndStationWith(title: "Купчино", x: 166, y: 550, lineNumber: 2, isLabelToLeft: true)
    
    spbMetro.addEdgeBetween(parnasStation, and: prospektProsvesheniiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(prospektProsvesheniiaStation, and: ozerkiStation, withWeight: 4)
    spbMetro.addEdgeBetween(ozerkiStation, and: udelnaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(udelnaiaStation, and: pionerskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(pionerskaiaStation, and: chernaiaRechkaStation, withWeight: 4)
    spbMetro.addEdgeBetween(chernaiaRechkaStation, and: petrogradskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(petrogradskaiaStation, and: gorkovskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(gorkovskaiaStation, and: nevskiiProspektStation, withWeight: 4)
    spbMetro.addEdgeBetween(nevskiiProspektStation, and: sennaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(sennaiaStation, and: tekhnolozhka2Station, withWeight: 4)
    spbMetro.addEdgeBetween(tekhnolozhka2Station, and: frunzenskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(frunzenskaiaStation, and: moskovskieVorotaStation, withWeight: 4)
    spbMetro.addEdgeBetween(moskovskieVorotaStation, and: elektrosilaStation, withWeight: 4)
    spbMetro.addEdgeBetween(elektrosilaStation, and: parkPobedyStation, withWeight: 4)
    spbMetro.addEdgeBetween(parkPobedyStation, and: moskovskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(moskovskaiaStation, and: zvezdnaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(zvezdnaiaStation, and: kupchinoStation, withWeight: 4)
    
    //Line 3 stations
    let begovaiaStation = createButtonLabelAndStationWith(title: "Беговая", x: 9, y: 152, lineNumber: 3)
    let zenitStation = createButtonLabelAndStationWith(title: "Зенит", x: 9, y: 184, lineNumber: 3)
    let primorskaiaStation = createButtonLabelAndStationWith(title: "Приморская", x: 53, y: 248, lineNumber: 3, isLabelToLeft: true)
    let vasileostrovskaiaStation = createButtonLabelAndStationWith(title: "Василеостровская", x: 80, y: 288, lineNumber: 3, isLabelToLeft: true)
    let gostinyiDvorStation = createButtonLabelAndStationWith(title: "Гостиный\nдвор", x: 166, y: 288, lineNumber: 3)
    let maiakovskaiaStation = createButtonLabelAndStationWith(title: "Маяковская", x: 231, y: 288, lineNumber: 3)
    let ploshadAlNevskogo1Station = createButtonLabelAndStationWith(title: "Пл. Александра Невского 1", x: 269, y: 340, lineNumber: 3)
    let elizarovskaiaStation = createButtonLabelAndStationWith(title: "Елизаровская", x: 294, y: 376, lineNumber: 3, isLabelToLeft: true)
    let lomonosovskaiaStation = createButtonLabelAndStationWith(title: "Ломоносовская", x: 307, y: 394, lineNumber: 3, isLabelToLeft: true)
    let proletarskaiaStation = createButtonLabelAndStationWith(title: "Пролетарская", x: 321, y: 414, lineNumber: 3, isLabelToLeft: true)
    let obukhovoStation = createButtonLabelAndStationWith(title: "Обухово", x: 333, y: 433, lineNumber: 3, isLabelToLeft: true)
    let rybatskoeStation = createButtonLabelAndStationWith(title: "Рыбацкое", x: 345, y: 449, lineNumber: 3, isLabelToLeft: true)
    
    spbMetro.addEdgeBetween(begovaiaStation, and: zenitStation, withWeight: 4)
    spbMetro.addEdgeBetween(zenitStation, and: primorskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(primorskaiaStation, and: vasileostrovskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(vasileostrovskaiaStation, and: gostinyiDvorStation, withWeight: 4)
    spbMetro.addEdgeBetween(gostinyiDvorStation, and: maiakovskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(maiakovskaiaStation, and: ploshadAlNevskogo1Station, withWeight: 4)
    spbMetro.addEdgeBetween(ploshadAlNevskogo1Station, and: elizarovskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(elizarovskaiaStation, and: lomonosovskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(lomonosovskaiaStation, and: proletarskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(proletarskaiaStation, and: obukhovoStation, withWeight: 4)
    spbMetro.addEdgeBetween(obukhovoStation, and: rybatskoeStation, withWeight: 4)
    
    gostinyiDvorStation.button.label.center.y += buttonDiameter
    
    //Line 4 stations
    let spasskaiaStation = createButtonLabelAndStationWith(title: "Спасская", x: 166, y: 330, lineNumber: 4, isLabelToLeft: true)
    let dostoevskaiaStation = createButtonLabelAndStationWith(title: "Достоевская", x: 231, y: 330, lineNumber: 4, isLabelToLeft: true)
    let ligovskiiProspektStation = createButtonLabelAndStationWith(title: "Лиговский\nпроспект", x: 246, y: 330, lineNumber: 4)
    let ploshadAlNevskogo2Station = createButtonLabelAndStationWith(title: "Пл. Александра Невского 2", x: 269, y: 330, lineNumber: 4)
    let novocherkasskaiaStation = createButtonLabelAndStationWith(title: "Новочеркасская", x: 321, y: 352, lineNumber: 4)
    let ladozhskaiaStation = createButtonLabelAndStationWith(title: "Ладожская", x: 335, y: 370, lineNumber: 4)
    let prospektBolshevikovStation = createButtonLabelAndStationWith(title: "Проспект\nБольшевиков", x: 350, y: 389, lineNumber: 4)
    let ulitsaDybenkoStation = createButtonLabelAndStationWith(title: "Улица\nДыбенко", x: 364, y: 405, lineNumber: 4)
    
    ligovskiiProspektStation.button.label.center.y -= buttonDiameter * 1.4
    ligovskiiProspektStation.button.label.center.x -= buttonDiameter
    dostoevskaiaStation.button.label.center.y -= buttonDiameter * 0.7
    dostoevskaiaStation.button.label.center.x += buttonDiameter * 0.2

    spbMetro.addEdgeBetween(spasskaiaStation, and: dostoevskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(dostoevskaiaStation, and: ligovskiiProspektStation, withWeight: 4)
    spbMetro.addEdgeBetween(ligovskiiProspektStation, and: ploshadAlNevskogo2Station, withWeight: 4)
    spbMetro.addEdgeBetween(ploshadAlNevskogo2Station, and: novocherkasskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(novocherkasskaiaStation, and: ladozhskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(ladozhskaiaStation, and: prospektBolshevikovStation, withWeight: 4)
    spbMetro.addEdgeBetween(prospektBolshevikovStation, and: ulitsaDybenkoStation, withWeight: 4)

    //Line 5 stations
    let komendantskiiProspektStation = createButtonLabelAndStationWith(title: "Комендантский\nпроспект", x: 84, y: 116, lineNumber: 5)
    let staraiaDerevniaStation = createButtonLabelAndStationWith(title: "Старая деревня", x: 84, y: 134, lineNumber: 5)
    let krestovskiiOstrovStation = createButtonLabelAndStationWith(title: "Крестовский\nостров", x: 84, y: 196, lineNumber: 5)
    let chkalovskaiaStation = createButtonLabelAndStationWith(title: "Чкаловская", x: 102, y: 224, lineNumber: 5, isLabelToLeft: true)
    let sportivnaiaStation = createButtonLabelAndStationWith(title: "Спортивная", x: 116, y: 245, lineNumber: 5, isLabelToLeft: true)
    let admiralteiskaiaStation = createButtonLabelAndStationWith(title: "Адмиралтейская", x: 153, y: 301, lineNumber: 5, isLabelToLeft: true)
    let sadovaiaStation = createButtonLabelAndStationWith(title: "Садовая", x: 166, y: 320, lineNumber: 5, isLabelToLeft: true)
    let zvenigorodskaiaStation = createButtonLabelAndStationWith(title: "Звенигородская", x: 191, y: 355, lineNumber: 5, isLabelToLeft: true)
    let obvodnyiKanalStation = createButtonLabelAndStationWith(title: "Обводный канал", x: 231, y: 458, lineNumber: 5)
    let volkovskaiaStation = createButtonLabelAndStationWith(title: "Волковская", x: 231, y: 476, lineNumber: 5)
    let bukharestskaiaStation = createButtonLabelAndStationWith(title: "Бухарестская", x: 231, y: 494, lineNumber: 5)
    let mezhdunarodnaiaStation = createButtonLabelAndStationWith(title: "Международная", x: 231, y: 512, lineNumber: 5)
    let prospektSlavyStation = createButtonLabelAndStationWith(title: "Проспект Славы", x: 231, y: 530, lineNumber: 5)
    let dunaiskaiaStation = createButtonLabelAndStationWith(title: "Дунайская", x: 231, y: 549, lineNumber: 5)
    let shusharyStation = createButtonLabelAndStationWith(title: "Шушары", x: 231, y: 567, lineNumber: 5)
    
    spbMetro.addEdgeBetween(komendantskiiProspektStation, and: staraiaDerevniaStation, withWeight: 4)
    spbMetro.addEdgeBetween(staraiaDerevniaStation, and: krestovskiiOstrovStation, withWeight: 4)
    spbMetro.addEdgeBetween(krestovskiiOstrovStation, and: chkalovskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(chkalovskaiaStation, and: sportivnaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(sportivnaiaStation, and: admiralteiskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(admiralteiskaiaStation, and: sadovaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(sadovaiaStation, and: zvenigorodskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(zvenigorodskaiaStation, and: obvodnyiKanalStation, withWeight: 4)
    spbMetro.addEdgeBetween(obvodnyiKanalStation, and: volkovskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(volkovskaiaStation, and: bukharestskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(bukharestskaiaStation, and: mezhdunarodnaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(mezhdunarodnaiaStation, and: prospektSlavyStation, withWeight: 4)
    spbMetro.addEdgeBetween(prospektSlavyStation, and: dunaiskaiaStation, withWeight: 4)
    spbMetro.addEdgeBetween(dunaiskaiaStation, and: shusharyStation, withWeight: 4)
    
    //Transfer sations
    spbMetro.addEdgeBetween(nevskiiProspektStation, and: gostinyiDvorStation, withWeight: 3)
    spbMetro.addEdgeBetween(ploshadVosstaniiaStation, and: maiakovskaiaStation, withWeight: 3)
    spbMetro.addEdgeBetween(ploshadAlNevskogo2Station, and: ploshadAlNevskogo1Station, withWeight: 3)
    spbMetro.addEdgeBetween(dostoevskaiaStation, and: vladimirskaiaStation, withWeight: 3)
    spbMetro.addEdgeBetween(zvenigorodskaiaStation, and: pushkinskaiaStation, withWeight: 3)
    spbMetro.addEdgeBetween(tekhnolozhka1Station, and: tekhnolozhka2Station, withWeight: 3)
    spbMetro.addEdgeBetween(spasskaiaStation, and: sadovaiaStation, withWeight: 3)
    spbMetro.addEdgeBetween(spasskaiaStation, and: sennaiaStation, withWeight: 3)
    spbMetro.addEdgeBetween(sennaiaStation, and: sadovaiaStation, withWeight: 3)

    for edge in spbMetro.edges {
      let edgeView = BezierLine(edge: edge, view: self.view)
      mapView.addSubview(edgeView)
    }
    
    for station in spbMetro.allVertices {
      mapView.addSubview(station.button)
    }
    for station in spbMetro.allVertices {
      mapView.addSubview(station.button.label)
    }
    mapView.layoutSubviews()
    
  }
  
  func createButtonLabelAndStationWith(title: String, x: CGFloat, y: CGFloat, lineNumber: Int, isLabelToLeft: Bool? = nil) -> Station {
    
    var color = UIColor.clear
    
    switch lineNumber {
    case 1: color = .systemRed
    case 2: color = .systemBlue
    case 3: color = .systemGreen
    case 4: color = .systemOrange
    case 5: color = .systemPurple
    default: color = .clear
    }
    
    let button = StationButton(frame: CGRect(x: view.layer.frame.width * x / 414, y: view.layer.frame.width  / 414 * y, width: buttonDiameter, height: buttonDiameter))
    button.backgroundColor = color
    button.addTarget(self, action: #selector(stationButtonTapped), for: .touchUpInside)
    
    let label = UILabel()
    label.text = title
    label.font = UIFont(name: "Helvetica Neue", size: mapView.frame.width / 52)
    label.numberOfLines = 0
    label.textColor = .label
    label.frame = CGRect(x: 0, y: 0, width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height)
    
    if isLabelToLeft == true {
      label.center = CGPoint(x: button.center.x - buttonDiameter * 0.6 - label.frame.width / 2, y: button.center.y)
      label.textAlignment = .right
    } else {
      label.center = CGPoint(x: button.center.x + buttonDiameter * 0.6 + label.frame.width / 2, y: button.center.y)
      label.textAlignment = .left
    }
    
    
    let station = spbMetro.addNewVertex(name: title, lineNumber: lineNumber)
    
    button.label = label
    station.button = button
    button.station = station
    
    return station
  }
  
  
  @IBAction func pinchGesture(){
    guard let gestureView = pinchGestureRecognizer.view else { return }

      gestureView.transform = gestureView.transform.scaledBy(x: pinchGestureRecognizer.scale, y: pinchGestureRecognizer.scale)
    
      pinchGestureRecognizer.scale = 1
  }
  
  @IBAction func panGesture(){
    guard let gestureView = panGestureRecognizer.view else { return }
    
    let translation = panGestureRecognizer.translation(in: gestureView.superview)

    if panGestureRecognizer.state == .began {
          self.initialCenter = gestureView.center
       }
    
    let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
    gestureView.center = newCenter
  }
  
  @objc func stationButtonTapped(sender: StationButton!) {
    
    switch (fromStation, toStation) {
    case (nil, nil):
      fromStation = sender.station
      largeCircle(sender: sender)
      updateRouteLabels()
      
//    case (nil, _):
//      if sender.station == toStation {
//        largeCircle(sender: fromStation?.button)
//        smallCircle(sender: sender)
//        fromStation = toStation
//        toStation = nil
//      } else {
//        fromStation = sender.station
//        largeCircle(sender: sender)
//      }
//      updateRouteLabels()
      
    case (_, nil):
      if sender.station == fromStation {
        largeCircle(sender: sender)
        smallCircle(sender: fromStation?.button)
        toStation = fromStation
        fromStation = nil
      } else {
        toStation = sender.station
        largeCircle(sender: sender)
        
        if fromStation != nil && toStation != nil {
          DispatchQueue.global(qos: .background).async { [weak self] in
            self?.spbMetro.findShortestPath(between: (self?.fromStation)!, and: (self?.toStation)!)
          }
        }
      }
      updateRouteLabels()
      
    default:
      smallCircle(sender: fromStation?.button)
      smallCircle(sender: toStation?.button)
      largeCircle(sender: sender)
      fromStation = sender.station
      toStation = nil
      updateRouteLabels()
    }
  }
  
  func largeCircle(sender: UIButton!){
    let buttonCenter = sender.center
    sender.frame.size = CGSize(width: buttonDiameter * 2, height: buttonDiameter * 2)
    sender.center = buttonCenter
    sender.layer.cornerRadius = sender.frame.width / 2
  }
  
  func smallCircle(sender: UIButton!){
    let buttonCenter = sender.center
    sender.frame.size = CGSize(width: buttonDiameter, height: buttonDiameter)
    sender.center = buttonCenter
    sender.layer.cornerRadius = sender.frame.width / 2
  }
  
  func updateRouteLabels() {
    fromStationLabel.text = fromStation?.name ?? "не выбрана"
    toStationLabel.text = toStation?.name ?? "не выбрана"
  }
  
  
}

extension Station {
  func placeLabelToLeft(){
    self.button.label.center = CGPoint(x: self.button.center.x - self.button.frame.width * 0.6 - self.button.label.frame.width / 2, y: button.center.y)
    self.button.label.textAlignment = .right
  }
}
