import Foundation

class Game: CustomStringConvertible, Equatable {
    var description: String {
        get { return "\(team), \(opponent), \(databaseId)" }
    }
    
    var team: String
    var opponent: String
    var databaseId: String
    
    init(team: String, opponent: String, databaseId: String) {
        self.team = team
        self.opponent = opponent
        self.databaseId = databaseId
    }
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.databaseId == rhs.databaseId
    }
}


var dateFormatter: DateFormatter {
    let df = DateFormatter()
    df.timeZone = TimeZone.autoupdatingCurrent
    return df
}

let timeFormat = "h:mma"
let dateFormat = "M/dd/yyyy"
let dateTimeFormat = "\(dateFormat) \(timeFormat)"

class ExportableGame: Game {
    override var description: String {
        get {
            dateFormatter.dateFormat = dateFormat
            let df = DateFormatter()
            df.timeZone = TimeZone.autoupdatingCurrent
            df.dateFormat = dateTimeFormat
            return "\(dateFormatter.string(from: start)), \(df.string(from: start)), \(df.string(from: finish)), \(team), \(opponent), \(databaseId)"
        }
    }
    
    
    var clubId = ""
    var start: Date
    var finish: Date
    var facility: String
    var type = "Game"
    var note = ""
    
    init(team: String,
         opponent: String,
         databaseId: String,
         start: Date,
         finish: Date,
         facility: String) {
        
        self.start = start
        self.finish = finish
        self.facility = facility
        super.init(team: team, opponent: opponent, databaseId: databaseId)
    }
    
    convenience init(team: String,
                     opponent: String,
                     databaseId: String,
                     date: String,
                     start: String,
                     finish: String,
                     facility: String) {
        
        let realStart = ExportableGame.convert(date: date, time: start)
        let realFinish = ExportableGame.convert(date: date, time: finish)
        self.init(team: team, opponent: opponent, databaseId: databaseId, start: realStart, finish: realFinish, facility: facility)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func getDate() -> String {
        let df = dateFormatter
        df.timeZone = TimeZone.autoupdatingCurrent
        df.dateFormat = dateFormat
        return df.string(from: start)
    }
    
    private func convert(time date: Date) -> String {
        let df = dateFormatter
        df.dateFormat = timeFormat
        return df.string(from: date)
    }
    
    static private func convert(date: String, time: String) -> Date {
        let df = dateFormatter
        df.timeZone = TimeZone.autoupdatingCurrent
        df.dateFormat = dateTimeFormat
        return df.date(from: "\(date) \(time)")!
    }
    
    func getStartTime() -> String {
        return convert(time: start)
    }
    
    func getFinishTime() -> String {
        return convert(time: finish)
    }
}

let exportableGame = ExportableGame(team: "x", opponent: "y", databaseId: "12345", date: "4/28/2018", start: "8:30AM", finish: "10:15AM", facility: "pony")
let xGame = Game(team: "a", opponent: "b", databaseId: "12345")

exportableGame == xGame
var xGames: [Game] = []
xGames.append(xGame)

xGames.index(of: exportableGame as Game)

