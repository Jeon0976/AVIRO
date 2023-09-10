import UIKit

final class TimeChangebleView: UIView, UIContextMenuInteractionDelegate {
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
        btn.menu = setButtonMenuWhenClickedButton()
        btn.showsMenuAsPrimaryAction = true
        
        return btn
    }()
        
    var isChangedTime: (() -> Void)?
    var shouldShowContextMenu: Bool = true

    private var isReversedTime: Bool!
    
    init(isReversedTime: Bool) {
        super.init(frame: .zero)
        
        self.isReversedTime = isReversedTime
        
        setupLayout()
        setupAttribute()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setupAttribute()
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
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -rightInset)
        ])
    }
    
    private func setupAttribute() {
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        
        let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(contextMenuInteraction)
    }
    
    @objc private func tappedView() {
        button.sendActions(for: .touchDown)
    }
    
    internal func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        if shouldShowContextMenu {
            return UIContextMenuConfiguration(
                identifier: nil,
                previewProvider: nil
            ) { suggestedActions in
                return self.setButtonMenuWhenClickedView()
            }
        } else {
            return nil
        }
    }

    func makeLabelText(_ time: String) {
        self.label.text = time
        
        if time == "시간 선택" {
            label.textColor = .gray3
        } else {
            label.textColor = .gray0
        }
    }
    
    func changeLabelText(_ time: String) {
        self.label.text = time
        self.label.textColor = .gray0
        
        isChangedTime?()
    }
    
    func loadTimeData() -> String {
        guard let text = self.label.text else { return "" }
        return text
    }
    
    func isEnabledButton(_ isEnabled: Bool) {
        button.isEnabled = isEnabled
        shouldShowContextMenu = isEnabled
        
        if !isEnabled {
            self.backgroundColor = .gray6
        } else {
            self.backgroundColor = .gray7
        }
    }
    
    private func setButtonMenuWhenClickedButton() -> UIMenu {
        var actions: [UIAction] = []
        
        let hours = isReversedTime ? Array((0...23).reversed()) : Array(0...23)
        let minutes = isReversedTime ? stride(from: 50, to: -1, by: -10) : stride(from: 0, to: 60, by: 10)

        for hour in hours {
            for minute in minutes {
                let timeString = String(format: "%02d:%02d", hour, minute)
                
                let action = UIAction(title: timeString, handler: { [weak self] _ in
                    self?.changeLabelText(timeString)
                })
                
                actions.append(action)
            }
        }
        
        return UIMenu(title: "시간선택", children: actions)
    }

    private func setButtonMenuWhenClickedView() -> UIMenu {
        var actions: [UIAction] = []
        
        let hours = Array(0...23)
        let minutes = stride(from: 0, to: 60, by: 10)

        for hour in hours {
            for minute in minutes {
                let timeString = String(format: "%02d:%02d", hour, minute)
                
                let action = UIAction(title: timeString, handler: { [weak self] _ in
                    self?.changeLabelText(timeString)
                })
                
                actions.append(action)
            }
        }
        
        return UIMenu(title: "시간선택", children: actions)
    }
}
