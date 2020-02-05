//
//  ViewController.swift
//  moveTheViewPlease
//
//  Created by Alex 6.1 on 2/2/20.
//  Copyright © 2020 aglegaspi. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
    
    //MARK: -PROPERTIES
    var sampleData: [CellData] = [
        CellData(isOpen: false, title: "Empire State Building",
                 sectionData: """
                    First Stop
                    Another Stop
                    Food Stop
                    """),
        CellData(isOpen: false, title: "National Museum of Mathematics", sectionData: """
           Second Stop
           Restroom Stop
           """),
        CellData(isOpen: false, title: "Central Parks", sectionData: "Third Stop")
    ]
    
    var sliderViewTopConstraints: NSLayoutConstraint?
    var newSliderViewTopConstraints: NSLayoutConstraint?
    //TODO: add new constraint
    //TODO: create enum to match state and move to tap
    
    let sliderViewHeight: CGFloat = 500
    
    
    //MARK: -VIEWS
    lazy var sliderView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var poiTableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.register(StopsTableViewCell.self, forCellReuseIdentifier: "StopCell")
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = .clear
        tableview.separatorStyle = .none
        return tableview
    }()
    
    lazy var chevronArrows: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(systemName: "chevron.compact.up")
        image.tintColor = .black
        image.isUserInteractionEnabled = true
        return image
    }()
    
    //MARK: -VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        view.addSubview(sliderView)
        sliderView.addSubview(chevronArrows)
        sliderView.addSubview(poiTableView)
        constrainSliderView()
        constrainChevronImage()
        constrainPOITableView()
        loadGestures()
    }
    
    //MARK: -PRIVATE FUNCTIONS
    private func loadGestures() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeDown.direction = .down
        self.sliderView.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.sliderView.addGestureRecognizer(swipeUp)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        self.chevronArrows.addGestureRecognizer(tap)
    }
    
    
    //MARK: -RESPOND TO GESTURE
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        print(gesture)
        
        if let tapGesture = gesture as? UITapGestureRecognizer {
             print("tapped")
             switch tapGesture.numberOfTouches {
             case 1:
                 print("one tap")
                
                sliderViewTopConstraints?.isActive = true
                newSliderViewTopConstraints?.isActive = false
                
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.80, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { [weak self] in
                    
                    self?.view.layoutIfNeeded()
                    self?.sliderView.alpha = 1.0
                    self?.poiTableView.alpha = 1.0
                    }, completion: nil)
             case 2:
                 print("two tap")
             default:
                 print("dunno know")
             }
             
        }
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
                
                sliderViewTopConstraints?.isActive = false
                newSliderViewTopConstraints?.isActive = true
                
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.80, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { [weak self] in
                    
                    self?.view.layoutIfNeeded()
                    self?.sliderView.alpha = 0.5
                    self?.poiTableView.alpha = 0
                    }, completion: nil)
                
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped Up")
                
                sliderViewTopConstraints?.isActive = true
                newSliderViewTopConstraints?.isActive = false
                
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.80, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { [weak self] in
                    
                    self?.view.layoutIfNeeded()
                    self?.sliderView.alpha = 1.0
                    self?.poiTableView.alpha = 1.0
                    }, completion: nil)
                
            default:
                break
            }
        }
        
        
    }
    
    //MARK: -OBJ-C FUNCTIONS
    @objc func buttonPressed(sender: UIButton) {
        print(sender.tag)
        if sampleData[sender.tag].isOpen {
            sampleData[sender.tag].isOpen = false
        } else {
            sampleData[sender.tag].isOpen = true
        }
        
        let incides: IndexSet = [sender.tag]
        poiTableView.reloadSections(incides, with: .fade)
        
    }
    
    //MARK: -CONSTRAINTS
    private func constrainSliderView() {
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([sliderView.leadingAnchor.constraint(equalTo: view.leadingAnchor), sliderView.trailingAnchor.constraint(equalTo: view.trailingAnchor), sliderView.heightAnchor.constraint(equalToConstant: sliderViewHeight)])
        
        sliderViewTopConstraints = sliderView.topAnchor.constraint(equalTo: view.bottomAnchor, constant:  -sliderViewHeight + 20)
        sliderViewTopConstraints?.isActive = true
        
        newSliderViewTopConstraints = sliderView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -65)
        newSliderViewTopConstraints?.isActive = false
    }
    
    
    private func constrainPOITableView() {
        poiTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            poiTableView.topAnchor.constraint(equalTo: sliderView.topAnchor, constant: 50),
            poiTableView.bottomAnchor.constraint(equalTo: sliderView.bottomAnchor),
            poiTableView.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor),
            poiTableView.trailingAnchor.constraint(equalTo: sliderView.trailingAnchor)
        ])
    }
    
    private func constrainChevronImage() {
        chevronArrows.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chevronArrows.topAnchor.constraint(equalTo: sliderView.topAnchor, constant: 10),
            chevronArrows.centerXAnchor.constraint(equalTo: sliderView.centerXAnchor),
            chevronArrows.bottomAnchor.constraint(equalTo: poiTableView.topAnchor, constant: -10),
            chevronArrows.widthAnchor.constraint(equalToConstant: 40),
            chevronArrows.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}


//MARK: -EXT. TABLEVIEW DELEGATE & DATASOURCE
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if sampleData[section].isOpen == false {
            return 0
        } else {
            return 1
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sampleData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        button.setTitle(sampleData[section].title, for: .normal)
        button.backgroundColor = .yellow
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchDown)
        button.setTitleColor(.black, for: .normal)
        button.tag = section
        view.addSubview(button)
        
        view.backgroundColor = .gray
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let cell = poiTableView.dequeueReusableCell(withIdentifier: "StopCell", for: indexPath) as? StopsTableViewCell else { return UITableViewCell() }
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
        
        cell.stopLabel.text = sampleData[indexPath.section].sectionData
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    
}


//extension ViewController: UIGestureRecognizerDelegate { }
