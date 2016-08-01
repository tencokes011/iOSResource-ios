//
//  Extensions.swift
// 
//
//  Created by Timothy Owens on 4/17/15.
//
//

import UIKit
import ImageIO
import Alamofire
import SwiftyJSON

extension NSRange {
    func toRange(string: String) -> Range<String.Index> {
        let startIndex = string.startIndex.advancedBy(location)
        let endIndex = startIndex.advancedBy(length)
        return startIndex ..< endIndex
    }
}

extension Bool {
    func toInt() -> Int {
        if self {
            return 1
        } else {
            return 0
        }
    }
}

extension NSNumber {
    func toInt() -> Int {
        return self as Int
    }
}

extension Int {
    func toBool() -> Bool {
        if self == 1 {
            return true
        } else {
            return false
        }
    }
}

extension UIButton {
    func adjustImageInsets(frame: CGRect) {
            self.imageEdgeInsets = UIEdgeInsets(
                top: frame.minY - self.frame.minY,
                left: frame.minX - self.frame.minX,
                bottom: self.frame.maxY - frame.maxY,
                right: self.frame.maxX - frame.maxX
            )
    }
}

private let characterEntities : [String: Character] = [
    
    // XML predefined entities:
    "&quot;"     : "\"",
    "&amp;"      : "&",
    "&apos;"     : "'",
    "&lt;"       : "<",
    "&gt;"       : ">",
    
    // HTML character entity references:
    "&nbsp;"     : "\u{00A0}",
    "&iexcl;"    : "\u{00A1}",
    "&cent;"     : "\u{00A2}",
    "&pound;"    : "\u{00A3}",
    "&curren;"   : "\u{00A4}",
    "&yen;"      : "\u{00A5}",
    "&brvbar;"   : "\u{00A6}",
    "&sect;"     : "\u{00A7}",
    "&uml;"      : "\u{00A8}",
    "&copy;"     : "\u{00A9}",
    "&ordf;"     : "\u{00AA}",
    "&laquo;"    : "\u{00AB}",
    "&not;"      : "\u{00AC}",
    "&shy;"      : "\u{00AD}",
    "&reg;"      : "\u{00AE}",
    "&macr;"     : "\u{00AF}",
    "&deg;"      : "\u{00B0}",
    "&plusmn;"   : "\u{00B1}",
    "&sup2;"     : "\u{00B2}",
    "&sup3;"     : "\u{00B3}",
    "&acute;"    : "\u{00B4}",
    "&micro;"    : "\u{00B5}",
    "&para;"     : "\u{00B6}",
    "&middot;"   : "\u{00B7}",
    "&cedil;"    : "\u{00B8}",
    "&sup1;"     : "\u{00B9}",
    "&ordm;"     : "\u{00BA}",
    "&raquo;"    : "\u{00BB}",
    "&frac14;"   : "\u{00BC}",
    "&frac12;"   : "\u{00BD}",
    "&frac34;"   : "\u{00BE}",
    "&iquest;"   : "\u{00BF}",
    "&Agrave;"   : "\u{00C0}",
    "&Aacute;"   : "\u{00C1}",
    "&Acirc;"    : "\u{00C2}",
    "&Atilde;"   : "\u{00C3}",
    "&Auml;"     : "\u{00C4}",
    "&Aring;"    : "\u{00C5}",
    "&AElig;"    : "\u{00C6}",
    "&Ccedil;"   : "\u{00C7}",
    "&Egrave;"   : "\u{00C8}",
    "&Eacute;"   : "\u{00C9}",
    "&Ecirc;"    : "\u{00CA}",
    "&Euml;"     : "\u{00CB}",
    "&Igrave;"   : "\u{00CC}",
    "&Iacute;"   : "\u{00CD}",
    "&Icirc;"    : "\u{00CE}",
    "&Iuml;"     : "\u{00CF}",
    "&ETH;"      : "\u{00D0}",
    "&Ntilde;"   : "\u{00D1}",
    "&Ograve;"   : "\u{00D2}",
    "&Oacute;"   : "\u{00D3}",
    "&Ocirc;"    : "\u{00D4}",
    "&Otilde;"   : "\u{00D5}",
    "&Ouml;"     : "\u{00D6}",
    "&times;"    : "\u{00D7}",
    "&Oslash;"   : "\u{00D8}",
    "&Ugrave;"   : "\u{00D9}",
    "&Uacute;"   : "\u{00DA}",
    "&Ucirc;"    : "\u{00DB}",
    "&Uuml;"     : "\u{00DC}",
    "&Yacute;"   : "\u{00DD}",
    "&THORN;"    : "\u{00DE}",
    "&szlig;"    : "\u{00DF}",
    "&agrave;"   : "\u{00E0}",
    "&aacute;"   : "\u{00E1}",
    "&acirc;"    : "\u{00E2}",
    "&atilde;"   : "\u{00E3}",
    "&auml;"     : "\u{00E4}",
    "&aring;"    : "\u{00E5}",
    "&aelig;"    : "\u{00E6}",
    "&ccedil;"   : "\u{00E7}",
    "&egrave;"   : "\u{00E8}",
    "&eacute;"   : "\u{00E9}",
    "&ecirc;"    : "\u{00EA}",
    "&euml;"     : "\u{00EB}",
    "&igrave;"   : "\u{00EC}",
    "&iacute;"   : "\u{00ED}",
    "&icirc;"    : "\u{00EE}",
    "&iuml;"     : "\u{00EF}",
    "&eth;"      : "\u{00F0}",
    "&ntilde;"   : "\u{00F1}",
    "&ograve;"   : "\u{00F2}",
    "&oacute;"   : "\u{00F3}",
    "&ocirc;"    : "\u{00F4}",
    "&otilde;"   : "\u{00F5}",
    "&ouml;"     : "\u{00F6}",
    "&divide;"   : "\u{00F7}",
    "&oslash;"   : "\u{00F8}",
    "&ugrave;"   : "\u{00F9}",
    "&uacute;"   : "\u{00FA}",
    "&ucirc;"    : "\u{00FB}",
    "&uuml;"     : "\u{00FC}",
    "&yacute;"   : "\u{00FD}",
    "&thorn;"    : "\u{00FE}",
    "&yuml;"     : "\u{00FF}",
    "&OElig;"    : "\u{0152}",
    "&oelig;"    : "\u{0153}",
    "&Scaron;"   : "\u{0160}",
    "&scaron;"   : "\u{0161}",
    "&Yuml;"     : "\u{0178}",
    "&fnof;"     : "\u{0192}",
    "&circ;"     : "\u{02C6}",
    "&tilde;"    : "\u{02DC}",
    "&Alpha;"    : "\u{0391}",
    "&Beta;"     : "\u{0392}",
    "&Gamma;"    : "\u{0393}",
    "&Delta;"    : "\u{0394}",
    "&Epsilon;"  : "\u{0395}",
    "&Zeta;"     : "\u{0396}",
    "&Eta;"      : "\u{0397}",
    "&Theta;"    : "\u{0398}",
    "&Iota;"     : "\u{0399}",
    "&Kappa;"    : "\u{039A}",
    "&Lambda;"   : "\u{039B}",
    "&Mu;"       : "\u{039C}",
    "&Nu;"       : "\u{039D}",
    "&Xi;"       : "\u{039E}",
    "&Omicron;"  : "\u{039F}",
    "&Pi;"       : "\u{03A0}",
    "&Rho;"      : "\u{03A1}",
    "&Sigma;"    : "\u{03A3}",
    "&Tau;"      : "\u{03A4}",
    "&Upsilon;"  : "\u{03A5}",
    "&Phi;"      : "\u{03A6}",
    "&Chi;"      : "\u{03A7}",
    "&Psi;"      : "\u{03A8}",
    "&Omega;"    : "\u{03A9}",
    "&alpha;"    : "\u{03B1}",
    "&beta;"     : "\u{03B2}",
    "&gamma;"    : "\u{03B3}",
    "&delta;"    : "\u{03B4}",
    "&epsilon;"  : "\u{03B5}",
    "&zeta;"     : "\u{03B6}",
    "&eta;"      : "\u{03B7}",
    "&theta;"    : "\u{03B8}",
    "&iota;"     : "\u{03B9}",
    "&kappa;"    : "\u{03BA}",
    "&lambda;"   : "\u{03BB}",
    "&mu;"       : "\u{03BC}",
    "&nu;"       : "\u{03BD}",
    "&xi;"       : "\u{03BE}",
    "&omicron;"  : "\u{03BF}",
    "&pi;"       : "\u{03C0}",
    "&rho;"      : "\u{03C1}",
    "&sigmaf;"   : "\u{03C2}",
    "&sigma;"    : "\u{03C3}",
    "&tau;"      : "\u{03C4}",
    "&upsilon;"  : "\u{03C5}",
    "&phi;"      : "\u{03C6}",
    "&chi;"      : "\u{03C7}",
    "&psi;"      : "\u{03C8}",
    "&omega;"    : "\u{03C9}",
    "&thetasym;" : "\u{03D1}",
    "&upsih;"    : "\u{03D2}",
    "&piv;"      : "\u{03D6}",
    "&ensp;"     : "\u{2002}",
    "&emsp;"     : "\u{2003}",
    "&thinsp;"   : "\u{2009}",
    "&zwnj;"     : "\u{200C}",
    "&zwj;"      : "\u{200D}",
    "&lrm;"      : "\u{200E}",
    "&rlm;"      : "\u{200F}",
    "&ndash;"    : "\u{2013}",
    "&mdash;"    : "\u{2014}",
    "&lsquo;"    : "\u{2018}",
    "&rsquo;"    : "\u{2019}",
    "&sbquo;"    : "\u{201A}",
    "&ldquo;"    : "\u{201C}",
    "&rdquo;"    : "\u{201D}",
    "&bdquo;"    : "\u{201E}",
    "&dagger;"   : "\u{2020}",
    "&Dagger;"   : "\u{2021}",
    "&bull;"     : "\u{2022}",
    "&hellip;"   : "\u{2026}",
    "&permil;"   : "\u{2030}",
    "&prime;"    : "\u{2032}",
    "&Prime;"    : "\u{2033}",
    "&lsaquo;"   : "\u{2039}",
    "&rsaquo;"   : "\u{203A}",
    "&oline;"    : "\u{203E}",
    "&frasl;"    : "\u{2044}",
    "&euro;"     : "\u{20AC}",
    "&image;"    : "\u{2111}",
    "&weierp;"   : "\u{2118}",
    "&real;"     : "\u{211C}",
    "&trade;"    : "\u{2122}",
    "&alefsym;"  : "\u{2135}",
    "&larr;"     : "\u{2190}",
    "&uarr;"     : "\u{2191}",
    "&rarr;"     : "\u{2192}",
    "&darr;"     : "\u{2193}",
    "&harr;"     : "\u{2194}",
    "&crarr;"    : "\u{21B5}",
    "&lArr;"     : "\u{21D0}",
    "&uArr;"     : "\u{21D1}",
    "&rArr;"     : "\u{21D2}",
    "&dArr;"     : "\u{21D3}",
    "&hArr;"     : "\u{21D4}",
    "&forall;"   : "\u{2200}",
    "&part;"     : "\u{2202}",
    "&exist;"    : "\u{2203}",
    "&empty;"    : "\u{2205}",
    "&nabla;"    : "\u{2207}",
    "&isin;"     : "\u{2208}",
    "&notin;"    : "\u{2209}",
    "&ni;"       : "\u{220B}",
    "&prod;"     : "\u{220F}",
    "&sum;"      : "\u{2211}",
    "&minus;"    : "\u{2212}",
    "&lowast;"   : "\u{2217}",
    "&radic;"    : "\u{221A}",
    "&prop;"     : "\u{221D}",
    "&infin;"    : "\u{221E}",
    "&ang;"      : "\u{2220}",
    "&and;"      : "\u{2227}",
    "&or;"       : "\u{2228}",
    "&cap;"      : "\u{2229}",
    "&cup;"      : "\u{222A}",
    "&int;"      : "\u{222B}",
    "&there4;"   : "\u{2234}",
    "&sim;"      : "\u{223C}",
    "&cong;"     : "\u{2245}",
    "&asymp;"    : "\u{2248}",
    "&ne;"       : "\u{2260}",
    "&equiv;"    : "\u{2261}",
    "&le;"       : "\u{2264}",
    "&ge;"       : "\u{2265}",
    "&sub;"      : "\u{2282}",
    "&sup;"      : "\u{2283}",
    "&nsub;"     : "\u{2284}",
    "&sube;"     : "\u{2286}",
    "&supe;"     : "\u{2287}",
    "&oplus;"    : "\u{2295}",
    "&otimes;"   : "\u{2297}",
    "&perp;"     : "\u{22A5}",
    "&sdot;"     : "\u{22C5}",
    "&lceil;"    : "\u{2308}",
    "&rceil;"    : "\u{2309}",
    "&lfloor;"   : "\u{230A}",
    "&rfloor;"   : "\u{230B}",
    "&lang;"     : "\u{2329}",
    "&rang;"     : "\u{232A}",
    "&loz;"      : "\u{25CA}",
    "&spades;"   : "\u{2660}",
    "&clubs;"    : "\u{2663}",
    "&hearts;"   : "\u{2665}",
    "&diams;"    : "\u{2666}",
    
]


extension String {

    var htmlToString:String {
            return try! NSAttributedString(data: dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil).string
        }
        var htmlToNSAttributedString:NSAttributedString {
            return try! NSAttributedString(data: dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
        }
    
    func NSRangeFromRange(range : Range<String.Index>) -> NSRange {
        let utf16view = self.utf16
        let from = String.UTF16View.Index(range.startIndex, within: utf16view)
        let to = String.UTF16View.Index(range.endIndex, within: utf16view)
        return NSMakeRange(utf16view.startIndex.distanceTo(from), from.distanceTo(to))
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

extension NSDate {
    
    private class func componentFlags() -> NSCalendarUnit { return [.Year,.Month,.Day,.WeekOfYear,.Hour,.Minute,.Second, .Weekday, .WeekdayOrdinal, .WeekOfYear] }
    
    private class func components(fromDate fromDate: NSDate) -> NSDateComponents! {
        return NSCalendar.currentCalendar().components(NSDate.componentFlags(), fromDate: fromDate)
    }
    
    private func components() -> NSDateComponents  {
        return NSDate.components(fromDate: self)!
    }
    
    class func withDate(day: Int, month: Int, year: Int) -> NSDate {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let components = NSDateComponents()
        components.day = day
        components.month = month
        components.year = year
        return calendar!.dateFromComponents(components)!
    }
    
    class func combineDate(date: NSDate, time: NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        
        let dateComponents = calendar.components([.Year, .Month, .Day], fromDate: date)
        let timeComponents = calendar.components([.Hour, .Minute], fromDate: time)
        
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
        
        return calendar.dateFromComponents(dateComponents)!
    }
    
    func roundTimeToNearest15Minute() -> NSDate {
        let referenceTime = self.timeIntervalSinceReferenceDate
        let remaining = referenceTime % 900
        var timeRoundTo15Minutes = referenceTime - remaining
        if remaining > 450 {
            timeRoundTo15Minutes = referenceTime + (900 - remaining)
        }
        let roundDate = NSDate(timeIntervalSinceReferenceDate: timeRoundTo15Minutes)
        return roundDate
    }

    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            return true
        }
        return false
    }
    
    func isGreaterThanDateOrEqual(dateToCompare: NSDate) -> Bool {
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending || self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            return true
        }
        return false
    }
    
    func isLessThanDateOrEqual(dateToCompare: NSDate) -> Bool {
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending || self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            return true
        }
        return false
    }

    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            return true
        }
        return false
    }
    
    func isEqualToDateIgnoringTime(date: NSDate) -> Bool
    {
        let comp1 = NSDate.components(fromDate: self)
        let comp2 = NSDate.components(fromDate: date)
        return ((comp1.year == comp2.year) && (comp1.month == comp2.month) && (comp1.day == comp2.day))
    }
    
    var startOfDay: NSDate {
        return NSCalendar.currentCalendar().startOfDayForDate(self)
    }
    
    var endOfDay: NSDate? {
        let components = NSDateComponents()
        components.day = 1
        components.second = -1
        return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: self, options: NSCalendarOptions())
    }
}

extension NSDateFormatter {
    class func recordButtonFormat() -> NSDateFormatter {
        let format = NSDateFormatter()
        format.dateFormat = "MMM dd, yyyy h:mm a"
        return format
    }

    class func recordButtonDate(date: String) -> NSDate {
        let format = NSDateFormatter()
        format.dateFormat = "MMM dd, yyyy h:mm a"
        return format.dateFromString(date)!
    }

    class func pickerDateFormatter(date: NSDate) -> String {
        let format = NSDateFormatter()
        format.dateFormat = "MMM dd, yyyy h:mm a"
        format.timeZone = NSTimeZone.defaultTimeZone()
        return format.stringFromDate(date)
    }
    
    class func pickerTimeFormatter(date: NSDate) -> String {
        let format = NSDateFormatter()
        format.dateFormat = "h:mm a"
        return format.stringFromDate(date)
    }
    
    class func pickerHourFormatter(date: NSDate) -> String {
        let format = NSDateFormatter()
        format.dateFormat = "h"
        return format.stringFromDate(date)
    }
    
    class func pickerMinuteFormatter(date: NSDate) -> String {
        let format = NSDateFormatter()
        format.dateFormat = "mm"
        return format.stringFromDate(date)
    }
    
    class func pickerAMPMFormatter(date: NSDate) -> String {
        let format = NSDateFormatter()
        format.dateFormat = "a"
        return format.stringFromDate(date)
    }

    class func dateFormatter() -> NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }

    class func dayDateFormatter() -> NSDateFormatter {
        let date = NSDateFormatter()
        date.dateFormat = "E MMM dd, YYYY"
        return date
    }
    
    class func jsonDateFormatter() -> NSDateFormatter {
        let date = NSDateFormatter()
        date.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss.SSSZ"
        date.timeZone = NSTimeZone(abbreviation: "UTC")
        return date
    }
    
    class func scheduleSectionHeader() -> NSDateFormatter {
        let date = NSDateFormatter()
        date.dateFormat = "EEEE, MMMM d, yyyy"
        return date
    }
    
    class func tivtiHeaderMonth() -> NSDateFormatter {
        let date = NSDateFormatter()
        date.dateFormat = "MMMM"
        return date
    }
    
    class func tivtiCollectionSectionHeaderMonth() -> NSDateFormatter {
        let date = NSDateFormatter()
        date.dateFormat = "MMM yyyy"
        return date
    }
    
    class func scheduleSectionHeaderToday() -> NSDateFormatter {
        let date = NSDateFormatter()
        date.dateFormat = "MMMM d, yyyy"
        return date
    }
}

extension Array {
    func get(index: Int) -> Element? {
        if 0 <= index && index < count {
            return self[index]
        } else {
            return nil
        }
    }
}

extension UIImage {
    
    class func imageWithColorWithRounded(color: UIColor) -> UIImage {
        
        let image = UIImage.imageWithColor(color)
        
        let imageView = UIImageView(image: image)
        
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, 1.0)
        
        UIBezierPath(roundedRect: imageView.bounds, cornerRadius: 25).addClip()
        
        image.drawInRect(imageView.bounds)
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return imageView.image!
    }
    
    class func imageWithColor(color: UIColor) -> UIImage {
        let innerRect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(innerRect.size)
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, innerRect)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    class func imageWithBorder(image: UIImage, borderColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGRectMake(0, 0, 1, 1).size, false, 0)
        
        let path = UIBezierPath(rect: CGRectMake(0, 0, 1, 1))
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSaveGState(context)

        path.addClip()
        
        image.drawInRect(CGRectMake(0, 0, 1, 1))
        CGContextRestoreGState(context)
        
        UIColor.purpleColor().setStroke()
        path.lineWidth = 2.0
        
        path.stroke()
        
        _ = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return image
    }

    class func animatedImageWithData(data: NSData) -> NSArray {
        let source = CGImageSourceCreateWithData(data, nil)
        let image = UIImage.animatedImageWithSource(source!)
        return image
    }

    class func delayForImageAtIndex(index: UInt, source: CGImageSourceRef) -> Double {
        var delay = 0.05
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, Int(index), nil)
        let properties: NSDictionary = cfProperties!
        let gifProperties = properties[kCGImagePropertyGIFDictionary as NSString] as! NSDictionary

        var number: AnyObject! = gifProperties[kCGImagePropertyGIFUnclampedDelayTime as NSString]
        if number.doubleValue == 0 {
            number = gifProperties[kCGImagePropertyGIFDelayTime as NSString]
        }
        delay = number as! Double
        if delay < 0.05 {
            delay = 0.05
        }
        return delay
    }

    class func gcdForPair(var a: Int?, var _ b: Int?) -> Int {
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }

        if a < b {
            let c = a
            a = b
            b = c
        }

        var rest: Int
        while true {
            rest = a! % b!

            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }

    class func gcdForArray(array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        var gcd = array[0]
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        return gcd
    }

    class func animatedImageWithSource(source: CGImageSource) -> NSArray {
        let count = CGImageSourceGetCount(source)
        var images = [CGImageRef]()
        var delays = [Int]()
        for i in 0 ..< count {
            images.append(CGImageSourceCreateImageAtIndex(source, i, nil)!)
            let delaySeconds = UIImage.delayForImageAtIndex(UInt(i), source: source)
            delays.append(Int(delaySeconds * 1000.0))
        }
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        var frame: UIImage
        var frameCount: Int
        for i in 0 ..< count {
            frame = UIImage(CGImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)

            for _ in 0 ..< frameCount {
                frames.append(frame)
            }
        }
        return frames
    }
}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(CGColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.CGColor
        }
    }
    
    @IBInspectable var leftBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: newValue, height: bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = UIColor(CGColor: layer.borderColor!)
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[line]|", options: [], metrics: nil, views: views))
        }
    }
    
    @IBInspectable var topBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[line]|", options: [], metrics: nil, views: views))
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
        }
    }
    
    @IBInspectable var rightBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: bounds.width, y: 0.0, width: newValue, height: bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[line]|", options: [], metrics: nil, views: views))
        }
    }
    @IBInspectable var bottomBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: bounds.height, width: bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[line]|", options: [], metrics: nil, views: views))
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
        }
    }
}

extension UISearchBar {
    var textField: UITextField {
        return self.valueForKey("_searchField") as! UITextField
    }
}

extension Bool {
    init<T : IntegerType>(_ integer: T) {
        if integer == 0 {
            self.init(false)
        } else {
            self.init(true)
        }
    }
}

extension UIViewController {
    
    func setScreeName(name: String) {
        self.title = name
        self.sendScreenView()
    }
    
    func sendScreenView() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: self.title)
        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject: AnyObject])
    }
    
    func trackEvent(category: String, action: String, label: String, value: NSNumber) {
        let tracker = GAI.sharedInstance().defaultTracker
        let trackDictionary = GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value).build() as [NSObject: AnyObject]
        tracker.send(trackDictionary)
    }
}

extension NSObject {
    
    func objectTrackEvent(category: String, action: String, label: String, value: NSNumber) {
        let tracker = GAI.sharedInstance().defaultTracker
        let trackDictionary = GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value).build() as [NSObject: AnyObject]
        tracker.send(trackDictionary)
    }
}

public protocol ResponseCollectionSerializable {
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
}

public protocol ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, representation: AnyObject)
}

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
            debugPrint(self)
        #endif
        return self
    }
    
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: Response<T, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T, NSError> { request, response, data, error in
            guard error == nil else { return .Failure(error!) }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                if let
                    response = response,
                    responseObject = T(response: response, representation: value)
                {
                    return .Success(responseObject)
                } else {
                    let failureReason = "JSON could not be serialized into response object: \(value)"
                    let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    return .Failure(error)
                }
            case .Failure(let error):
                return .Failure(error)
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: Response<[T], NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T], NSError> { request, response, data, error in
            guard error == nil else { return .Failure(error!) }
            
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                if let response = response {
                    return .Success(T.collection(response: response, representation: value))
                } else {
                    let failureReason = "Response collection could not be serialized due to nil response"
                    let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    return .Failure(error)
                }
            case .Failure(let error):
                return .Failure(error)
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}



public enum HTTPStatusCode: Int {
    // Informational
    case Continue = 100
    case SwitchingProtocols = 101
    case Processing = 102
    
    // Success
    case OK = 200
    case Created = 201
    case Accepted = 202
    case NonAuthoritativeInformation = 203
    case NoContent = 204
    case ResetContent = 205
    case PartialContent = 206
    case MultiStatus = 207
    case AlreadyReported = 208
    case IMUsed = 226
    
    // Redirections
    case MultipleChoices = 300
    case MovedPermanently = 301
    case Found = 302
    case SeeOther = 303
    case NotModified = 304
    case UseProxy = 305
    case SwitchProxy = 306
    case TemporaryRedirect = 307
    case PermanentRedirect = 308
    
    // Client Errors
    case BadRequest = 400
    case Unauthorized = 401
    case PaymentRequired = 402
    case Forbidden = 403
    case NotFound = 404
    case MethodNotAllowed = 405
    case NotAcceptable = 406
    case ProxyAuthenticationRequired = 407
    case RequestTimeout = 408
    case Conflict = 409
    case Gone = 410
    case LengthRequired = 411
    case PreconditionFailed = 412
    case RequestEntityTooLarge = 413
    case RequestURITooLong = 414
    case UnsupportedMediaType = 415
    case RequestedRangeNotSatisfiable = 416
    case ExpectationFailed = 417
    case ImATeapot = 418
    case AuthenticationTimeout = 419
    case UnprocessableEntity = 422
    case Locked = 423
    case FailedDependency = 424
    case UpgradeRequired = 426
    case PreconditionRequired = 428
    case TooManyRequests = 429
    case RequestHeaderFieldsTooLarge = 431
    case LoginTimeout = 440
    case NoResponse = 444
    case RetryWith = 449
    case UnavailableForLegalReasons = 451
    case RequestHeaderTooLarge = 494
    case CertError = 495
    case NoCert = 496
    case HTTPToHTTPS = 497
    case TokenExpired = 498
    case ClientClosedRequest = 499
    
    // Server Errors
    case InternalServerError = 500
    case NotImplemented = 501
    case BadGateway = 502
    case ServiceUnavailable = 503
    case GatewayTimeout = 504
    case HTTPVersionNotSupported = 505
    case VariantAlsoNegotiates = 506
    case InsufficientStorage = 507
    case LoopDetected = 508
    case BandwidthLimitExceeded = 509
    case NotExtended = 510
    case NetworkAuthenticationRequired = 511
    case NetworkTimeoutError = 599
}

public extension HTTPStatusCode {
    
    public var isInformational: Bool {
        return inRange(100...199)
    }
    
    public var isSuccess: Bool {
        return inRange(200...299)
    }
    
    public var isRedirection: Bool {
        return inRange(300...399)
    }
    
    public var isClientError: Bool {
        return inRange(400...499)
    }
    
    public var isServerError: Bool {
        return inRange(500...599)
    }
    
    private func inRange(range: Range<Int>) -> Bool {
        return range.contains(rawValue)
    }
}

public extension HTTPStatusCode {
    public var localizedReasonPhrase: String {
        return NSHTTPURLResponse.localizedStringForStatusCode(rawValue)
    }
}

public extension HTTPStatusCode {
    public init?(HTTPResponse: NSHTTPURLResponse?) {
        if let value = HTTPResponse?.statusCode {
            self.init(rawValue: value)
        } else {
            return nil
        }
    }
}

extension Int {
    func secondsToHoursMinutesSeconds() -> (Int, Int, Int) {
        return (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
    }
}



