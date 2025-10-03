import FoundationModels

@Generable
enum CoffeeTag: String, CaseIterable {
    case strong
    case bold
    case rich
    case velvety
    case smooth
    case balanced
    case light
    case creamy
    case sweet
    case airy
    case silky
    case chocolatey
    case nutty
    case indulgent
    case boozy
    case refreshing
    case lowAcidity
    case buttery
    case caffeinated
    case bright
    case bitter
}

@Generable
struct Coffee {
    let name: String
    let summary: String
    let tags: [CoffeeTag]
}

extension Coffee {
    static let all: [Coffee] = [
        Coffee(
            name: "Espresso",
            summary: "A concentrated shot of coffee extracted under high pressure with no milk; intense, rich, bittersweet flavor with a velvety crema on top.",
            tags: [.strong, .bold, .rich, .velvety]
        ),
        Coffee(
            name: "Americano",
            summary: "Single shot of espresso diluted with hot water, no milk; smooth, mellow body with subtle acidity and notes of toasted grains.",
            tags: [.smooth, .balanced, .light]
        ),
        Coffee(
            name: "Ristretto",
            summary: "A 'short' shot of espresso using less water; no milk, offering a sweeter, more concentrated flavor with bright acidity and rich body.",
            tags: [.strong, .bold, .bright]
        ),
        Coffee(
            name: "Lungo",
            summary: "A 'long' espresso shot extracted with more water; no milk, delivering a more diluted, slightly more bitter profile with deeper caramel notes.",
            tags: [.bold, .bitter, .rich]
        ),
        Coffee(
            name: "Latte",
            summary: "Single espresso shot topped with steamed whole milk (roughly 2:1 milk-to-espresso) and a thin layer of microfoam; creamy, mild sweetness with gentle coffee aroma.",
            tags: [.creamy, .sweet, .smooth]
        ),
        Coffee(
            name: "Cappuccino",
            summary: "Equal parts espresso, steamed whole milk, and thick milk foam; balanced, airy texture with pronounced coffee notes and a sweet, creamy finish.",
            tags: [.creamy, .airy, .balanced]
        ),
        Coffee(
            name: "Flat White",
            summary: "Double espresso shot with steamed whole milk microfoam (about 1:2 milk-to-espresso); silky, velvety mouthfeel with a strong coffee flavor and subtle sweetness.",
            tags: [.silky, .creamy, .strong]
        ),
        Coffee(
            name: "Macchiato",
            summary: "Single espresso 'stained' with a small dollop of steamed whole milk foam; bold espresso flavor softened by a hint of creamy sweetness.",
            tags: [.bold, .strong, .creamy]
        ),
        Coffee(
            name: "Cortado",
            summary: "Equal parts espresso and steamed dairy milk with no foam; harmonious, balanced cup with mellow acidity and a smooth, satiny texture.",
            tags: [.balanced, .smooth, .creamy]
        ),
        Coffee(
            name: "Mocha",
            summary: "Espresso blended with steamed whole milk and chocolate syrup, topped with milk foam; sweet, chocolatey, and richly indulgent with a velvety finish.",
            tags: [.chocolatey, .sweet, .indulgent, .creamy]
        ),
        Coffee(
            name: "Almond Milk Latte",
            summary: "Espresso shot with steamed almond milk in a 1:3 ratio; nutty, slightly sweet, plant-based creaminess and a lighter, airy body.",
            tags: [.nutty, .light, .creamy]
        ),
        Coffee(
            name: "Oat Milk Cappuccino",
            summary: "Equal parts espresso, steamed oat milk, and oat-milk foam; smooth, naturally sweet cereal notes with a rich, velvety texture.",
            tags: [.nutty, .creamy, .sweet, .smooth]
        ),
        Coffee(
            name: "Affogato",
            summary: "Hot shot of espresso poured over a scoop of vanilla gelato (dairy base); contrasts hot and cold, creamy sweetness balanced by robust coffee.",
            tags: [.sweet, .indulgent, .creamy]
        ),
        Coffee(
            name: "Irish Coffee",
            summary: "Hot brewed coffee mixed with Irish whiskey and brown sugar, topped with lightly whipped heavy cream; warming, boozy, sweet, and luxuriously creamy.",
            tags: [.boozy, .sweet, .creamy, .rich]
        ),
        Coffee(
            name: "Vienna Coffee",
            summary: "Strong brewed coffee or espresso topped with a dollop of whipped heavy cream instead of milk; rich, smooth mouthfeel with a sweet cream accent.",
            tags: [.creamy, .sweet, .rich, .velvety]
        ),
        Coffee(
            name: "Cold Brew",
            summary: "Coarse-ground coffee steeped in cold water for 12+ hours, served over ice; no milk, featuring smooth, low-acid profile with chocolatey, nutty notes.",
            tags: [.smooth, .chocolatey, .lowAcidity, .refreshing]
        ),
        Coffee(
            name: "Nitro Cold Brew",
            summary: "Cold brew infused with nitrogen and served on tap; no milk, offering a creamy, cascading texture with subtle sweetness and chocolate undertones.",
            tags: [.smooth, .velvety, .chocolatey, .lowAcidity]
        ),
        Coffee(
            name: "Frappuccino",
            summary: "Blended iced coffee with whole milk and ice, sweetened with flavored syrup and topped with whipped cream; refreshing, sweet, and creamy with customizable flavors.",
            tags: [.sweet, .creamy, .indulgent, .refreshing]
        ),
        Coffee(
            name: "Bulletproof Coffee",
            summary: "Hot brewed coffee blended with unsalted grass-fed butter and MCT oil (no milk); rich, buttery texture delivering sustained energy and smooth mouthfeel.",
            tags: [.buttery, .rich, .strong]
        ),
        Coffee(
            name: "Red Eye",
            summary: "Drip-brewed coffee 'hit' with a single shot of espresso, no milk; bold, highly caffeinated, combining drip coffee smoothness with espresso intensity.",
            tags: [.strong, .bold, .caffeinated]
        )
    ]
}
