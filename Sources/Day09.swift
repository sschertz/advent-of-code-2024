import Algorithms

struct Day09: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Convert data to an array of blocks
  var entities: [Block] {
    var isFile = true
    var index = 0
    return data.map{
      var block = Block(isFile: isFile, size: Int(String($0))!)
      if isFile {
        block.fileId = index
        index += 1
      }
      isFile = !isFile
      return block
    }
  }

  func part1() -> Any {
    var compactedFileMap: [Int] = []
    var blocks = entities
    var endIndex = blocks.index(before: blocks.endIndex)
    
    for i in blocks.startIndex...endIndex{
      //print("processing block \(i)")
      
      let availableSpace = blocks[i].size
      if blocks[i].isFile {
        compactedFileMap += blocks[i].getFileArray(of: availableSpace)
        continue
      }
      
      // This is an empty space, so gather files from the other end of the
      // array.
      var blocksToInsert: [Int] = []
      var remainingSpace = availableSpace
      while blocksToInsert.count < availableSpace && i < endIndex{
        if blocks[endIndex].isFile {
          // this is a file, so get blocks to process and reduce
          // our available space accordingly.
          let newBlocks = blocks[endIndex].getFileArray(of: remainingSpace)
          remainingSpace -= newBlocks.count
          blocksToInsert += newBlocks
          if blocks[endIndex].size <= 0 {
            endIndex = blocks.index(before: endIndex)
          }
        } else {
          // this is not a file, so just go to the next endindex
          endIndex = blocks.index(before: endIndex)
        }
      }
      compactedFileMap += blocksToInsert
    }
    
    return compactedFileMap.enumerated().map{
      let (index, value) = $0
      return index * value
    }.reduce(0, +)
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    return 0
  }
}

struct Block: CustomStringConvertible {
  var isFile = false
  var size: Int = 0
  var fileId: Int? = nil
  
  var description: String{
    if let fileId {
      return "File \(fileId) of size: \(size)"
    } else {
      return "Empty space of size \(size)"
    }
  }
  
  mutating func getFileArray(of limit: Int) -> [Int]{
    // need to be sure that this is a file, not free space.
    var countToReturn = 0
    guard let fileId else {
      return [] // not a file, so nothing to return
    }
    if limit < size {
      countToReturn = limit
    } else {
      countToReturn = size
    }
    size -= countToReturn // reduce our size by the items we've handled.
    return Array.init(repeating: fileId, count: countToReturn)
  }
  
  func prettyPrint () {
    if let fileId {
      for _ in 0..<size {print(fileId, terminator: "")}
    } else {
      for _ in 0..<size {print(".", terminator: "")}
    }
  }
}
