//
//  MenuBar.swift
//  Capstone
//
//  Created by Mithun Reddy on 10/12/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(red: 41.0/255.0, green: 35.0/255.0, blue: 66.0/255.0, alpha: 1.0)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    let cellID = "cellID"
    let menuLabels = ["Categories", "Exercises"]
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    var chartViewController: ChartViewController?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellID)
        
        addSubview(collectionView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[collectionView]|", options: [], metrics: nil, views: ["collectionView": collectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: [], metrics: nil, views: ["collectionView": collectionView]))
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        setupHorizontalBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = .white
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
}

extension MenuBar: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? MenuCell else { return MenuCell() }
        cell.menuLabel.text = menuLabels[indexPath.item]
        cell.menuLabel.textColor = UIColor(white: 1.0, alpha: 0.25)
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .left)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chartViewController?.scrollToMenuIndex(menuIndex: indexPath.item)
    }
}

class MenuCell: UICollectionViewCell {
    
    let menuLabel: UILabel = {
        let label = UILabel()
        label.text = "Menu"
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var isHighlighted: Bool {
        didSet {
            menuLabel.textColor = isHighlighted ? UIColor(white: 1.0, alpha: 1.0) : UIColor(white: 1.0, alpha: 0.25)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            menuLabel.textColor = isSelected ? UIColor(white: 1.0, alpha: 1.0) : UIColor(white: 1.0, alpha: 0.25)
        }
    }
    
    func setupViews() {
        addSubview(menuLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[menuLabel(100)]", options: [], metrics: nil, views: ["menuLabel": menuLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[menuLabel(28)]", options: [], metrics: nil, views: ["menuLabel": menuLabel]))
        addConstraint(NSLayoutConstraint(item: menuLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: menuLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        menuLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}
