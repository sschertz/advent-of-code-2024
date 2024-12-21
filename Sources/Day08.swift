import Algorithms

struct Day08: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] { data.split(separator: "\n").map { String($0) }
  }
  
  func makeGrid(strings: [String]) -> (Grid<Character>, [Character:[Coordinate]]) {
    
    var grid: Grid<Character> = Grid(
      columns: strings[0].count, rows: strings.count, initialValue: ".")
    var antennaLocations: [Character:[Coordinate]] = [:]
    var row = 0
    
    // populate the grid
    for string in strings {
      var col = 0
      for char in string {
        grid[col, row] = char
        if char != "." {
          antennaLocations[char, default: []].append(Coordinate(col: col,row: row))
        }
        col += 1
      }
      row += 1
    }
    
    return (grid, antennaLocations)
  }

  func part1() -> Any {
    let strings = entities
    let (grid, antennaMap) = makeGrid(strings: strings)
    
    var antinodes: Set<Coordinate> = []
    
    for (_, antennas) in antennaMap {
      var antennasToProcess = antennas
      while !antennasToProcess.isEmpty{
        let antenna = antennasToProcess.removeFirst()
        antennasToProcess.forEach{secondAntenna in
          // can probably move this into the type
          let colDistance = antenna.col - secondAntenna.col
          let rowDistance = antenna.row - secondAntenna.row
          //print("Need to move columns \(colDistance) and rows \(rowDistance)")
          antinodes.insert(Coordinate(col: antenna.col+colDistance,row: antenna.row+rowDistance))
          antinodes.insert(Coordinate(col: secondAntenna.col-colDistance, row: secondAntenna.row-rowDistance))
        }
      }
    }
    
    return antinodes.filter{ grid.isValidCoordinate($0.col, $0.row)}.count
    
  }

  func part2() -> Any {
    return 0
  }
}

struct Coordinate: Equatable, Hashable, CustomStringConvertible {
  var col: Int
  var row: Int
  var description:String {
    "(\(col),\(row))"
  }
}
