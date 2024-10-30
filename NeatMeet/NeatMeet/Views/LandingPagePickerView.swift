import UIKit

class LandingPagePickerView: UIView {
    var pickerView: UIPickerView!
    var toolbar: UIToolbar!
    var doneButton: UIBarButtonItem!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        setUpPickerView()
        setUpToolbar()
        initConstraints()
    }

    private func setUpPickerView() {
        pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pickerView)
    }

    private func setUpToolbar() {
        toolbar = UIToolbar()
        toolbar.sizeToFit()

        doneButton = UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil)
        toolbar.setItems([doneButton], animated: true)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(toolbar)
    }

    private func initConstraints() {
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            toolbar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),

            pickerView.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            pickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
