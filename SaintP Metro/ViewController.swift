//
//  ViewController.swift
//  SaintP Metro
//
//  Created by user on 09.08.2021.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var showDetailsButton: UIButton!
  @IBOutlet weak var resetRouteButton: UIButton!
  @IBOutlet weak var mapView: UIView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var fromStationButton: UIButton!
  @IBOutlet weak var toStationButton: UIButton!
  @IBOutlet weak var routeTimeLabel: UILabel!
  @IBOutlet weak var transfersNumberLabel: UILabel!
  
  private var buttonDiameter: CGFloat {
    let side = min(self.view.layer.frame.width, self.view.layer.frame.height)
    return side / 40
  }
  
  let spbMetro = MetroGraph()

  private var route = [Station]()
  private var routeEdges = [Edge]()
  
  private var numberOfTransfers: Int {
    var counter = 0
    guard !route.isEmpty else { return 0 }
    for (index, station) in route.enumerated() {
      guard route.indices.contains(index + 1) else { return counter }
      if station.button.color != route[index + 1].button.color {
        counter += 1
      }
    }
    return counter
  }
  
  private var transfersText: String {
    let strNumberOfTransfers = String(numberOfTransfers)
    switch strNumberOfTransfers.last {
    case "1": return "\(numberOfTransfers) пересадка"
    case "2", "3", "4": return "\(numberOfTransfers) пересадки"
    case "0": if numberOfTransfers == 0 {
      return "Без пересадок"
    } else { return "\(numberOfTransfers) пересадок"}
    default: return "\(numberOfTransfers) пересадок"
    }
  }
  
  private var fromStation: Station?
  private var toStation: Station?
  var overlayView: UIView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.delegate = self
    scrollView.decelerationRate = .fast
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    routeTimeLabel.text = nil
    transfersNumberLabel.text = nil
    
    let scrollViewSize = scrollView.bounds.size
    let mapViewSize = mapView.bounds.size
    
    let xScale = scrollViewSize.width / mapViewSize.width
    let yScale = scrollViewSize.height / mapViewSize.height
    let minScale = min(xScale, yScale)
    
    scrollView.minimumZoomScale = minScale
    scrollView.maximumZoomScale = 3
    
    toStationButton.layer.cornerRadius = fromStationButton.frame.size.height / 4
    showDetailsButton.layer.cornerRadius = showDetailsButton.bounds.height / 4
    showDetailsButton.isHidden = true
    resetRouteButton.layer.cornerRadius = showDetailsButton.layer.cornerRadius
    
    for button in [fromStationButton, toStationButton] {
      button?.layer.cornerRadius = fromStationButton.frame.size.height / 4
      button?.layer.borderWidth = 1
      button?.layer.borderColor = UIColor.darkGray.cgColor
    }
    
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
    button.color = color
    button.buttonDiameter = buttonDiameter
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

  
  @objc func stationButtonTapped(sender: StationButton?, isFromSearch: Bool = false) {
    
    switch (fromStation, toStation) {
    case (nil, nil):
      showDetailsButton.isHidden = true
      fromStation = sender?.station
      sender?.largeCircle()
      updateRouteLabels()
      
    case (nil, _):
      if sender?.station == toStation {
        showDetailsButton.isHidden = true
        fromStation = toStation
        toStation = nil
      } else {
        fromStation = sender?.station
        sender?.largeCircle()

        if fromStation != nil && toStation != nil {
          calculatePath()
        }
      }
      updateRouteLabels()
      
    case (_, nil):
      if sender?.station == fromStation {
        showDetailsButton.isHidden = true
        toStation = fromStation
        fromStation = nil
      } else {
        toStation = sender?.station
        sender?.largeCircle()

        if fromStation != nil && toStation != nil {
          calculatePath()
        }
      }
      updateRouteLabels()
      
    default:
      guard let overlayView = overlayView else { return }
      overlayView.removeFromSuperview()
      clearTimeAndTransfersLabel()
      showDetailsButton.isHidden = true
      fromStation?.button.smallCircle(buttonDiameter: buttonDiameter)
      toStation?.button.smallCircle(buttonDiameter: buttonDiameter)
      sender?.largeCircle()
      fromStation = sender?.station
      toStation = nil
      updateRouteLabels()
    }
  }
  
  func updateRouteLabels() {
    
    if fromStation != nil {
      fromStationButton.setTitle(fromStation?.name, for: .normal)
      fromStationButton.tintColor = fromStation?.button.color
      fromStationButton.setTitleColor(.black, for: .normal)
    } else {
      fromStationButton.setTitle("Откуда", for: .normal)
      fromStationButton.tintColor = .darkGray
      fromStationButton.setTitleColor(.darkGray, for: .normal)
    }
    
    if toStation != nil {
      toStationButton.setTitle(toStation?.name, for: .normal)
      toStationButton.tintColor = toStation?.button.color
      toStationButton.setTitleColor(.black, for: .normal)
    } else {
      toStationButton.setTitle("Куда", for: .normal)
      toStationButton.tintColor = .darkGray
      toStationButton.setTitleColor(.darkGray, for: .normal)
    }
  }
  
  func calculatePath(){
    DispatchQueue.global(qos: .background).async { [weak self] in
      let result = self?.spbMetro.findShortestPath(between: (self?.fromStation)!, and: (self?.toStation)!) ?? ([],[])
      self?.route = result.0
      self?.routeEdges = result.1
      DispatchQueue.main.async { [weak self] in
        self?.drawRoute()
        self?.showDetailsButton.isHidden = false
        self?.routeTimeLabel.text = "\((self?.toStation)!.shortestDistanceFromStart) мин"
        self?.transfersNumberLabel.text = self?.transfersText
        self?.scaleMapToRoute()
      }
    }
  }
  
  func drawRoute(){
    if overlayView != nil {
      overlayView?.removeFromSuperview()
    }
    
    overlayView = PassthroughView(frame: CGRect(x: -25, y: -25, width: view.frame.size.width + 50, height: view.frame.size.height + 50))
    guard let overlayView = overlayView else { return }
    
    overlayView.backgroundColor = .white
    overlayView.layer.opacity = 0.8
    overlayView.isUserInteractionEnabled = true
    mapView.addSubview(overlayView)
    
    for edge in routeEdges {
      if let edgeView = edge.edgeView {
        edgeView.isUserInteractionEnabled = false
        mapView.addSubview(edgeView)
      }
    }
    
    for station in route {
      mapView.addSubview(station.button)
      mapView.addSubview(station.button.label)
    }
  }
  
  @IBAction func showDetails(_ sender: UIButton) {
  }
  
  @IBAction func resetRoute(_ sender: UIButton) {
    overlayView?.removeFromSuperview()
    fromStation?.button.smallCircle(buttonDiameter: buttonDiameter)
    toStation?.button.smallCircle(buttonDiameter: buttonDiameter)
    fromStation = nil
    toStation = nil
    updateRouteLabels()
    showDetailsButton.isHidden = true
    clearTimeAndTransfersLabel()
    scrollView.zoom(to: mapView.bounds, animated: true)
  }
  
  func clearTimeAndTransfersLabel(){
    routeTimeLabel.text = nil
    transfersNumberLabel.text = nil
  }
  
  @IBAction func switchStations(_ sender: UIButton) {
    swap(&fromStation, &toStation)
    updateRouteLabels()
    
    if fromStation != nil && toStation != nil {
      calculatePath()
    }
  }
  
  @IBAction func searchForStation(_ sender: UIButton) {
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "showRoute"{
      guard let destinationVC = segue.destination as? DetailsTableViewController else { return }
      destinationVC.route = self.route
      destinationVC.routeEdges = self.routeEdges
      destinationVC.numberOfTransfers = self.numberOfTransfers
      destinationVC.transfersText = self.transfersText
    }
    
    if segue.identifier == "showSearchView" {
      guard let destinationVC = segue.destination as? SearchStationTableViewController else { return }
      var allStations = [Station]()
      spbMetro.allVertices.forEach { station in
        allStations.append(station)
      }
      destinationVC.allStations = allStations.sorted{ $0.name < $1.name }
      destinationVC.buttonTapped = sender as? UIButton
      destinationVC.delegate = self
    }
  }
  
  func scaleMapToRoute(){
    var minX: CGFloat = CGFloat(Int.max)
    var minY: CGFloat = CGFloat(Int.max)
    var maxX: CGFloat = CGFloat(Int.min)
    var maxY: CGFloat = CGFloat(Int.min)

    for station in route {
      minX = min(minX, min(station.button.frame.minX, station.button.label.frame.minX))
      minY = min(minY, min(station.button.frame.minY, station.button.label.frame.minY))
      maxX = max(maxX, max(station.button.frame.maxX, station.button.label.frame.maxX))
      maxY = max(maxY, max(station.button.frame.maxY, station.button.label.frame.maxY))
    }
    
    scrollView.zoom(to: CGRect(x: minX - 10, y: minY - 10, width: maxX - minX + 20, height: maxY - minY + 20), animated: true)
  }
}

extension ViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return mapView
  }
}

extension ViewController: SearchStationTableViewDelegate {
  func receiveSearchResult(station: Station, button: UIButton){
    if fromStation != nil && button == fromStationButton {
      
      fromStation?.button.smallCircle(buttonDiameter: buttonDiameter)
        fromStation = nil
        stationButtonTapped(sender: station.button)
    } else if toStationButton != nil && button == toStationButton {
      toStation?.button.smallCircle(buttonDiameter: buttonDiameter)
        toStation = nil
        stationButtonTapped(sender: station.button)
    } else {
      stationButtonTapped(sender: station.button)
    }
  }
}
