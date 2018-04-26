//
//  CapturedImagesStackView.swift
//  GiniVision
//
//  Created by Enrique del Pozo Gómez on 4/25/18.
//

import UIKit

final class CapturedImagesStackView: UIView {
    
    enum Status {
        case filled(count: Int, lastImage: UIImage), empty
    }
    
    let thumbnailSize: CGSize = {
        if UIDevice.current.isIpad {
            return CGSize(width: 40, height: 60)
        } else {
            return CGSize(width: 30, height: 45)
        }
    }()
    var didTapImageStackButton: (() -> Void)?
    fileprivate let stackCountCircleSize = CGSize(width: 25, height: 25)
    fileprivate var imagesCount: Int = 0
    
    fileprivate lazy var thumbnailButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 1
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: -2, height: 2)
        button.addTarget(self, action: #selector(thumbnailButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate lazy var thumbnailStackBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.isHidden = true
        return view
    }()
    
    fileprivate lazy var stackIndicatorLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.Gini.blue
        return label
    }()
    
    fileprivate lazy var stackIndicatorCircleView: UIView = {
        var view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame.size = self.stackCountCircleSize
        view.backgroundColor = .white
        view.layer.cornerRadius = self.stackCountCircleSize.width / 2
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        return view
    }()
    
    fileprivate lazy var capturedImagesStackSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("ginivision.camera.capturedImagesStackLabel",
                                       bundle: Bundle(for: GiniVision.self),
                                       comment: "label shown below images stack")
        label.textAlignment = .center
        label.textColor = .white
        label.font = label.font.withSize(12)

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(thumbnailStackBackgroundView)
        addSubview(thumbnailButton)
        addSubview(stackIndicatorCircleView)
        addSubview(capturedImagesStackSubtitleLabel)
        stackIndicatorCircleView.addSubview(stackIndicatorLabel)
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(frame:) initializer instead")
    }

}

// MARK: - Public methods

extension CapturedImagesStackView {
    func absoluteThumbnailFrame(from view: UIView) -> CGRect {
        return convert(thumbnailButton.frame, to: view)
    }
    
    func updateStackStatus(to status: Status) {
        switch status {
        case .filled(let count, let lastImage):
            imagesCount = count
            thumbnailStackBackgroundView.isHidden = count < 2
            thumbnailButton.setImage(lastImage, for: .normal)
            isHidden = false
        case .empty:
            imagesCount = 0
            thumbnailStackBackgroundView.isHidden = true
            thumbnailButton.setImage(nil, for: .normal)
            isHidden = true
        }
        
        stackIndicatorLabel.text = "\(imagesCount)"
    }
    
    func addImageToStack(image: UIImage) {
        updateStackStatus(to: .filled(count: imagesCount + 1, lastImage: image))
    }
}

// MARK: - Private methods

extension CapturedImagesStackView {
    @objc fileprivate func thumbnailButtonAction() {
        didTapImageStackButton?()
    }
    
    fileprivate func addConstraints() {
        // multipageReviewButton
        Constraints.active(item: thumbnailButton, attr: .centerX, relatedBy: .equal,
                           to: self, attr: .centerX)
        Constraints.active(item: thumbnailButton, attr: .height, relatedBy: .equal, to: nil,
                           attr: .notAnAttribute, constant: thumbnailSize.height)
        Constraints.active(item: thumbnailButton, attr: .width, relatedBy: .equal, to: nil,
                           attr: .notAnAttribute, constant: thumbnailSize.width)
        
        // multipageReviewBackgroundView
        Constraints.active(item: thumbnailStackBackgroundView, attr: .centerY, relatedBy: .equal,
                           to: thumbnailButton, attr: .centerY, constant: 3)
        Constraints.active(item: thumbnailStackBackgroundView, attr: .centerX, relatedBy: .equal,
                           to: thumbnailButton, attr: .centerX, constant: -3)
        Constraints.active(item: thumbnailStackBackgroundView, attr: .height, relatedBy: .equal, to: nil,
                           attr: .notAnAttribute, constant: thumbnailSize.height)
        Constraints.active(item: thumbnailStackBackgroundView, attr: .width, relatedBy: .equal, to: nil,
                           attr: .notAnAttribute, constant: thumbnailSize.width)
        
        // stackIndicatorCircleView
        Constraints.active(item: stackIndicatorCircleView, attr: .trailing, relatedBy: .equal,
                           to: thumbnailButton, attr: .trailing, constant: stackCountCircleSize.height / 2)
        Constraints.active(item: stackIndicatorCircleView, attr: .top, relatedBy: .equal,
                           to: thumbnailButton, attr: .top, constant: -stackCountCircleSize.height / 2)
        Constraints.active(item: stackIndicatorCircleView, attr: .height, relatedBy: .equal, to: nil,
                           attr: .notAnAttribute, constant: stackCountCircleSize.height)
        Constraints.active(item: stackIndicatorCircleView, attr: .width, relatedBy: .equal, to: nil,
                           attr: .notAnAttribute, constant: stackCountCircleSize.width)
        Constraints.active(item: stackIndicatorCircleView, attr: .top, relatedBy: .greaterThanOrEqual,
                           to: self, attr: .top, constant: 10)
        // stackIndicatorLabel
        Constraints.active(item: stackIndicatorLabel, attr: .centerX, relatedBy: .equal,
                           to: stackIndicatorCircleView, attr: .centerX)
        Constraints.active(item: stackIndicatorLabel, attr: .centerY, relatedBy: .equal,
                           to: stackIndicatorCircleView, attr: .centerY)
        
        // capturedImagesStackSubtitleLabel
        Constraints.active(item: capturedImagesStackSubtitleLabel, attr: .bottom, relatedBy: .equal,
                           to: self, attr: .bottom, constant: -10)
        Constraints.active(item: capturedImagesStackSubtitleLabel, attr: .top, relatedBy: .equal,
                           to: thumbnailStackBackgroundView, attr: .bottom, constant: 4)
        Constraints.active(item: capturedImagesStackSubtitleLabel, attr: .leading, relatedBy: .equal,
                           to: self, attr: .leading)
        Constraints.active(item: capturedImagesStackSubtitleLabel, attr: .trailing, relatedBy: .equal,
                           to: self, attr: .trailing)
        
    }
}
