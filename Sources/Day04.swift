import Algorithms

struct Day04: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  // Splits input data into its component parts and convert from string.
  var strings: [String] {
    data.split(separator: "\n").map{String($0)}
  }
  
  
  
  func part1() -> Any {
    let word="XMAS"
    var foundWordsCount = 0
    let startingChar = word.first!
    var startingChars:[(c: Int,r:Int)] = []
    var grid:Array2D<Character> = Array2D(columns: strings[0].count, rows: strings.count, initialValue: ".")
    
    var row=0
    // populate the grid and save a list of coordinates of the
    // starting character of the word to find.
    for string in strings {
        var col = 0
        for char in string {
            grid[col,row] = char
            if char == startingChar {
                startingChars.append((c: col, r: row))
            }
            col += 1
        }
        row += 1
    }
    
    for coord in startingChars{
        // check all 8 directions for valid words
        for direction in Array2D<Character>.Direction.allCases{
           // print("check \(direction)")
            guard grid.isValidPath(from: coord, direction: direction, distance: word.count-1) else {
                continue
            }
            
            var (c,r) = coord
            var foundWord = false
            for char in word{
                guard char==grid[c,r] else{
                    foundWord = false
                    break // Bail out of loop, no point in checking the
                          // rest of the letters.
                }
                // The letter is in our word, so continue the loop
                // I'm not sure why I got nil errors here, since we shouldn't be attempting
                // to move to a non-allowed coordinate.
                if let newCoord = grid.move(direction, from: (c: c, r: r)){
                    c=newCoord.c
                    r=newCoord.r
                    foundWord = true
                }
            }
            if foundWord{
                foundWordsCount += 1
            }
        }
    }
    return foundWordsCount
    
  }
  
  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    return 0
  }
}

public struct Array2D<T> {
  public let columns: Int
  public let rows: Int
  fileprivate var array: [T]
  
  public init(columns: Int, rows: Int, initialValue: T) {
    self.columns = columns
    self.rows = rows
    array = .init(repeating: initialValue, count: rows*columns)
  }
  
  public func isValidCoordinate(_ column: Int, _ row: Int) -> Bool {
    row >= 0 && row < rows && column >= 0 && column < columns
  }
  
  public func move(_ direction:Direction, from startCoord:(c: Int, r:Int), by distance: Int=1) -> (c: Int, r: Int)? {
    let (c, r) = startCoord
    
    guard isValidPath(from: startCoord, direction: direction) else {return nil}
    
    switch direction {
    case .up:
      return (c: c, r: r-distance)
    case .down:
      return (c:c, r: r+distance)
    case .left:
      return (c: c-distance, r: r)
    case .right:
      return (c: c+distance, r: r)
    case .upLeft:
      return (c: c-distance, r: r-distance)
    case .upRight:
      return (c: c+distance, r: r-distance)
    case .downLeft:
      return (c: c-distance, r: r+distance)
    case .downRight:
      return (c: c+distance, r: r+distance)
    }
  }
  
  public func isValidPath(from start: (c: Int,r: Int),
                          direction: Direction,
                          distance: Int=1) -> Bool{
    var (col, row) = start
    switch direction {
    case .up:
      row -= distance
    case .down:
      row += distance
    case .left:
      col -= distance
    case .right:
      col += distance
    case .upLeft:
      row -= distance
      col -= distance
    case .upRight:
      col += distance
      row -= distance
    case .downLeft:
      row += distance
      col -= distance
    case .downRight:
      row += distance
      col += distance
    }
    return isValidCoordinate(col, row)
  }
  
  
  public func prettyPrint() {
    for i in 0..<self.rows {
      print("[", terminator: "")
      for j in 0..<self.columns {
        if j == self.columns - 1 {
          print("\(self[j, i])", terminator: "")
        } else {
          print("\(self[j, i]) ", terminator: "")
        }
      }
      print("]")
    }
  }
  
  public subscript(column: Int, row: Int) -> T {
    get {
      precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
      precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
      return array[row*columns + column]
    }
    set {
      precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
      precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
      array[row*columns + column] = newValue
    }
  }
  
  public enum Direction: CaseIterable {
    case up, down, left, right, upLeft, upRight, downLeft, downRight
  }
}
