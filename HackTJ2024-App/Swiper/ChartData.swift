// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct ChartData: Codable {
    let chart: ChartD
}

// MARK: - Chart
struct ChartD: Codable {
    let result: [Result]
}

// MARK: - Result
struct Result: Codable {
    let timestamp: [Int]
    let indicators: Indicators
}

// MARK: - Indicators
struct Indicators: Codable {
    let quote: [Quote]
}

// MARK: - Quote
struct Quote: Codable {
    let high: [Double]
    let low: [Double]
}
