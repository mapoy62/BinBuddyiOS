//
//  DayCheckboxView.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 11/01/25.
//

import UIKit

class DayCheckboxView: UIStackView {

    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()

    private let dayButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 15 // Para hacer el botón circular
        button.clipsToBounds = true
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return button
    }()

    // Callback para manejar eventos de clic
    var onButtonTapped: (() -> Void)?

    init(day: Int) {
        super.init(frame: .zero)
        axis = .vertical
        alignment = .center
        spacing = 4

        // Configurar el label
        dayLabel.text = "Day \(day)"

        // Configurar el botón
        dayButton.tag = day
        dayButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        // Agregar subviews al stack
        addArrangedSubview(dayLabel)
        addArrangedSubview(dayButton)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Método para manejar el evento de clic del botón
    @objc private func buttonTapped() {
        onButtonTapped?() // Llama al callback cuando el botón se presiona
    }

    // Método para alternar el estado del botón
    func toggleSelection() {
        if dayButton.backgroundColor == .systemGreen {
            dayButton.backgroundColor = .systemGray5 // Desmarcar
        } else {
            dayButton.backgroundColor = .systemGreen // Marcar
        }
    }

    // Método para verificar si está seleccionado
    func isSelected() -> Bool {
        return dayButton.backgroundColor == .systemGreen
    }
}

