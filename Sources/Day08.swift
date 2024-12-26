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
          let distance = antenna.distanceTo(to: secondAntenna)
          antinodes.insert(antenna.offsetBy(distance: distance, using: +))
          antinodes.insert(secondAntenna.offsetBy(distance: distance, using: -))
        }
      }
    }
    
    return antinodes.filter{ grid.isValidCoordinate($0.col, $0.row)}.count
    
  }

  func part2() -> Any {
    let strings = entities
    let (grid, antennaMap) = makeGrid(strings: strings)
    
    var antinodes: Set<Coordinate> = []
    for (_, antennas) in antennaMap {
      var antennasToProcess = antennas
      while !antennasToProcess.isEmpty{
        let ant1 = antennasToProcess.removeFirst()
        antennasToProcess.forEach{ant2 in
          let distance = ant1.distanceTo(to: ant2)
          var isValidCoord = true
          var newCoord: Coordinate = ant1
          while isValidCoord {
            newCoord = newCoord.offsetBy(distance: distance, using: +)
            isValidCoord = grid.isValidCoordinate(newCoord.col, newCoord.row)
            if isValidCoord { antinodes.insert(newCoord) }
          }
          isValidCoord = true
          newCoord = ant2
          while isValidCoord {
            newCoord = newCoord.offsetBy(distance: distance, using: -)
            isValidCoord = grid.isValidCoordinate(newCoord.col, newCoord.row)
            if isValidCoord { antinodes.insert(newCoord) }
          }
          // also add both of these to the list
          antinodes.insert(ant1)
          antinodes.insert(ant2)
          
        }
      }
    }
    
    return antinodes.count
  }
}
