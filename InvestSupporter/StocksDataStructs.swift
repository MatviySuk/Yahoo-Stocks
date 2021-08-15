//
//  StocksDataModel.swift
//  InvestSupporter
//
//  Created by Matviy Suk on 07.05.2021.
//

import Foundation
import CoreData


struct QuoteParent: Codable {
    var quoteResponse: QuoteResponse
//    var chartQuote: ChartQuote
    init() {
        quoteResponse = QuoteResponse()
//        chartQuote = ChartQuote()
    }
}

struct QuoteResponse: Codable {
    var error: QuoteError?
    var result: [Stock]?
    init() {
        error = nil
        result = []
    }
}

struct QuoteError: Codable {
    var lang: String?
    var description: String?
    var message: String?
    var code: Int?
    init() {
        lang = ""
        description = ""
        message = ""
        code = 0
    }
    init(error: Error) {
        self.description = error.localizedDescription
    }
}

struct Stock: Codable, Equatable, Hashable {
    
    var ask : Double?
//    var askSize : Int?
//    var averageDailyVolume10Day : Int?
//    var averageDailyVolume3Month : Int?
    var bid : Double?
//    var bidSize : Int?
//    var bookValue : Double?
//    var currency : String?
//    var epsTrailingTwelveMonths : Double?
//    var esgPopulated : Bool?
//    var exchange : String?
//    var exchangeDataDelayedBy : Int?
//    var exchangeTimezoneName : String?
//    var exchangeTimezoneShortName : String?
//    var fiftyDayAverage : Double?
//    var fiftyDayAverageChange : Double?
//    var fiftyDayAverageChangePercent : Double?
    var fiftyTwoWeekHigh : Double?
//    var fiftyTwoWeekHighChange : Double?
//    var fiftyTwoWeekHighChangePercent : Double?
    var fiftyTwoWeekLow : Double?
//    var fiftyTwoWeekLowChange : Double?
//    var fiftyTwoWeekLowChangePercent : Double?
//    var fiftyTwoWeekRange : String?
//    var financialCurrency : String?
//    var firstTradeDateMilliseconds : Int?
//    var fullExchangeName : String?
//    var gmtOffSetMilliseconds : Int?
//    var language : String?
    var longName : String?
//    var market : String?
    var marketCap : Int64?
//    var marketState : String?
//    var messageBoardId : String?
//    var priceHint : Int?
//    var priceToBook : Double?
    //------------------------------
    var chart: [ChartData]?
//    --------------------------------
//    var quoteSourceName : String?
//    var quoteType : String?
//    var region : String?
//    var regularMarketChange : Double?
//    var regularMarketChangePercent : Double?
//    var regularMarketDayHigh : Double?
//    var regularMarketDayLow : Double?
//    var regularMarketDayRange : String?
//    var regularMarketOpen : Double?
//    var regularMarketPreviousClose : Double?
//    var regularMarketPrice : Double?
//    var regularMarketTime : Int?
//    var regularMarketVolume : Int?
//    var sharesOutstanding : Int?
//    var shortName : String?
//    var sourceInterval : Int?
    var symbol : String?
//    var tradeable : Bool?
//    var trailingAnnualDividendRate : Double?
//    var trailingAnnualDividendYield : Double?
//    var trailingPE : Double?
//    var trailingThreeMonthNavReturns : Double?
//    var trailingThreeMonthReturns : Double?
//    var triggerable : Bool?
//    var twoHundredDayAverage : Double?
//    var twoHundredDayAverageChange : Double?
//    var twoHundredDayAverageChangePercent : Double?
//    var ytdReturn : Double?
}

struct ChartQuote: Codable {
    var chart: Chart
    init() {
        chart = Chart()
    }
}

struct Chart: Codable {
    var error: ChartError?
    var result: [Meta]?
    init() {
        error = nil
        result = []
    }
}

struct ChartError: Codable {
    var lang: String?
    var description: String?
    var message: String?
    var code: Int?
    init() {
        lang = ""
        description = ""
        message = ""
        code = 0
    }
}

struct Meta: Codable {
    var timeStamp: [Int?]?
    var indicators: Quote?
    
    struct Quote: Codable {
        var quote: [ChartData]?
        
        init() {
            self.quote = []
        }
        
        mutating func cleanNILLValues() {
            if self.quote?.first?.close == nil { self.quote?[0].close = [1.0, 1.0] }
            if self.quote?.first?.volume == nil { self.quote?[0].volume = [1.0, 1.0] }
            if self.quote?.first?.low == nil { self.quote?[0].low = [1.0, 1.0] }
            if self.quote?.first?.`open` == nil { self.quote?[0].`open` = [1.0, 1.0] }
            if self.quote?.first?.high == nil { self.quote?[0].high = [1.0, 1.0] }

            var resultQuote = Quote()
            resultQuote.quote?.append(ChartData())
            resultQuote.quote?[0].close = self.quote?.first?.close?.compactMap{$0}
            resultQuote.quote?[0].volume = self.quote?.first?.volume?.compactMap{$0}
            resultQuote.quote?[0].low = self.quote?.first?.low?.compactMap{$0}
            resultQuote.quote?[0].`open` = self.quote?.first?.`open`?.compactMap{$0}
            resultQuote.quote?[0].high = self.quote?.first?.high?.compactMap{$0}
            self.quote = resultQuote.quote
        }
    }
  }

struct ChartData: Codable, Equatable, Hashable {
    var close: [Double?]?
    var volume: [Double?]?
    var low: [Double?]?
    var `open`: [Double?]?
    var high: [Double?]?
}


// Possible time periods for stock`s chart data
enum TimeRanges: Int, RawRepresentable {
    case oneD = 86400
    case oneW = 604800
    case oneM = 2629743
    case threeM = 7889229
    case sixM = 15778458
    case oneY = 31556926
    case twoY = 63113852
    case fiveY = 157784630
    case tenY = 315569260
    case all = 600000000
}



