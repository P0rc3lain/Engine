//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

extension String {
    public subscript(value: NSRange) -> Substring {
        self[value.lowerBound ..< value.upperBound]
    }
    subscript(value: Int) -> Character {
        self[index(at: value)]
    }
    subscript(value: CountableClosedRange<Int>) -> Substring {
        self[index(at: value.lowerBound) ... index(at: value.upperBound)]
    }
    subscript(value: CountableRange<Int>) -> Substring {
      self[index(at: value.lowerBound) ..< index(at: value.upperBound)]
    }
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
      self[..<index(at: value.upperBound)]
    }
    subscript(value: PartialRangeThrough<Int>) -> Substring {
      self[...index(at: value.upperBound)]
    }
    subscript(value: PartialRangeFrom<Int>) -> Substring {
      self[index(at: value.lowerBound)...]
    }
    func index(at offset: Int) -> String.Index {
      index(startIndex, offsetBy: offset)
    }
}
