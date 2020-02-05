//
//  ViewController.swift
//  moveTheViewPlease
//
//  Created by Alex 6.1 on 2/2/20.
//  Copyright © 2020 aglegaspi. All rights reserved.
//

//MARK:-- Comments 1
//Mixing constraints and frame tend to give problems depending on which device or function you usee. to combat that, its better to modify just the constraints. and its much easier to work with.

import UIKit

class ViewController: UIViewController {
    
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
    
    let sampleCategoryData: [CategoryData] = [
        CategoryData(name: "History"),
        CategoryData(name: "Art"),
        CategoryData(name: "Blah"),
        CategoryData(name: "Blah2"),
        CategoryData(name: "Yeet")
    ]
    
    var sliderViewTopConstraints: NSLayoutConstraint?
    var newSliderViewTopConstraints: NSLayoutConstraint?
    //TODO: add new constraint
    //TODO: create enum to match state and move to tap
    
    let sliderViewHeight: CGFloat = 500
    
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
        return tableview
    }()
    
    lazy var chevronArrows: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(systemName: "chevron.compact.up")
        image.tintColor = .black
        return image
    }()
    
    lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        
        swipeUp()
        swipeDown()
        view.addSubview(sliderView)
        sliderView.addSubview(chevronArrows)
        sliderView.addSubview(categoriesCollectionView)
        sliderView.addSubview(poiTableView)
        constrainSliderView()
        constrainChevronImage()
        constrainCategoriesCollectionView()
        constrainPOITableView()
    }
    
    private func swipeDown() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeDown.direction = .down
        self.sliderView.addGestureRecognizer(swipeDown)
    }
    
    private func swipeUp() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.sliderView.addGestureRecognizer(swipeUp)
    }
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        
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
                    self?.categoriesCollectionView.alpha = 0
                    }, completion: nil)
                
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped Up")
                
                sliderViewTopConstraints?.isActive = true
                newSliderViewTopConstraints?.isActive = false
                
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.80, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { [weak self] in
                    
                    self?.view.layoutIfNeeded()
                    self?.sliderView.alpha = 1.0
                    self?.poiTableView.alpha = 1.0
                    self?.categoriesCollectionView.alpha = 1.0
                    }, completion: nil)
                
            default:
                break
            }
        }
    }
    
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
            poiTableView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor, constant: 10),
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
            chevronArrows.bottomAnchor.constraint(equalTo: categoriesCollectionView.topAnchor, constant: -10),
            chevronArrows.widthAnchor.constraint(equalToConstant: 40),
            chevronArrows.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func constrainCategoriesCollectionView() {
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoriesCollectionView.topAnchor.constraint(equalTo: chevronArrows.bottomAnchor, constant: 10),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: sliderView.trailingAnchor),
            categoriesCollectionView.bottomAnchor.constraint(equalTo: poiTableView.topAnchor, constant: -10),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
}

//MARK: - Extensions

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
        //TODO: work on animation on cell
        guard let cell = poiTableView.dequeueReusableCell(withIdentifier: "StopCell", for: indexPath) as? StopsTableViewCell else { return UITableViewCell() }
        
        cell.alpha = 0
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
        
        
        cell.stopLabel.text = sampleData[indexPath.section].sectionData
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleCategoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = sampleCategoryData[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoriesCollectionViewCell else {return UICollectionViewCell()}
        
        cell.setUpCells(cell: cell, data: category)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}
extension ViewController: UICollectionViewDelegateFlowLayout {}
