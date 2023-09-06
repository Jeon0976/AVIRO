import UIKit

final class TimeChangebleView: UIView {
    private var topInset: CGFloat = 15.0
    private var bottomInset: CGFloat = 15.0
    private var leftInset: CGFloat = 12.0
    private var rightInset: CGFloat = 12.0
    
    private lazy var label: UILabel = {
        let lbl = UILabel()
        
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        
        return lbl
    }()
    
    private lazy var button: UIButton = {
        let btn = UIButton()

        btn.setImage(UIImage(named: "DownSorting"), for: .normal)
        
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupLayout() {
        [
            label,
            button
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: topInset),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leftInset),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -bottomInset),
            
            button.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -rightInset),
        ])
    }
    
    private func setAttribute() {
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
    }
    
    func makeLabelText(_ time: String) {
        self.label.text = time
        
        if time == "시간 선택" {
            label.textColor = .gray3
        } else {
            label.textColor = .gray0
        }
    }
}
