//
//  InstagramData.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 22/12/24.
//

import Foundation

struct InstagramData {
    static let categories: [InstagramCategory] = [
        InstagramCategory(
            title: "Moda Sustentableeee Titleee",
            profiles: [
                InstagramProfile(
                    username: "AleVintage",
                    displayName: "Ale Vintage",
                    profileImageURL: "https://www.instagram.com/alevintages/?hl=es",
                    bio: "Moda vintage con un toque moderno. 🌟"
                ),
                // Añade más perfiles aquí
            ]
        ),
        InstagramCategory(
            title: "Comida Sustentable",
            profiles: [
                InstagramProfile(
                    username: "EcoFoodie",
                    displayName: "Eco Foodie",
                    profileImageURL: "https://instagram.com/path_to_ecofoodie_profile_image.jpg",
                    bio: "Recetas saludables y sustentables con ingredientes de temporada. 🥗"
                ),
                // Añade más perfiles aquí
            ]
        ),
        // Añade más categorías según sea necesario
    ]
}
