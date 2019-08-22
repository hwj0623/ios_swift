import UIKit



class CustomDateFormatter {
    
    static func convertDateToString(_ input: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        let result = dateFormatter.string(from: input)
        return result
    }
    
    static func convertStringToDate(year: Int, month : Int, day: Int) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dDay = dateFormatter.date(from: "\(year)-\(month)-\(day)")
        return dDay!
    }
}


var cur = Date.init() + TimeInterval(90*24*60*60)
print(cur)

//var after = cur + 90*24*60*60

//print(after)

