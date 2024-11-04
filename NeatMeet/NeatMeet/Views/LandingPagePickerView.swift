import UIKit

class LandingPagePickerView: UIView {
    var pickerView: UIPickerView!
    var toolbar: UIToolbar!
    var doneButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        setUpPickerView()
        initConstraints()
    }

    private func setUpPickerView() {
        pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pickerView)
    }

    private func initConstraints() {
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            pickerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
