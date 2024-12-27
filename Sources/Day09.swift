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
  
  func part2() -> Any {
    
    var blocks = entities
    
    while let lastFileIndex =
            blocks.lastIndex(where: {$0.isFile && !$0.hasMoved}) {
      
      let lastFile = blocks[lastFileIndex]
      
      guard let firstEmptySpace = blocks.firstIndex(
        where: {!$0.isFile && $0.size >= lastFile.size}),
            firstEmptySpace < lastFileIndex
      else {
        // there are no empty spaces large enough for this block,
        // OR the open spaces are to the right and not eligible
        // flag block to remain here
        blocks[lastFileIndex].hasMoved = true
        continue
      }
      
      // Now firstEmptySpace is the index of a space large enough to fit
      // the block.
      
      // convert the file we are moving to an empt space
      blocks[lastFileIndex].isFile = false
      blocks[lastFileIndex].fileId = nil
      
      // fill in the block and then insert any remaining empty space
      if let leftoverEmptySpace =
          blocks[firstEmptySpace].fillEmptyBlock(with: lastFile){
        blocks.insert(leftoverEmptySpace, at: firstEmptySpace + 1)
      }
    }
    
    var blockIndex = 0
    
    return blocks.compactMap{block in
      let result = block.calcChecksum(blockIndex)
      blockIndex += block.size
      return result
    }.reduce(0, +)
    
  }
}

struct Block {
  var isFile = false
  var size: Int = 0
  var fileId: Int? = nil
  public var hasMoved = false
  
  public init(isFile: Bool = false, size: Int, fileId: Int? = nil) {
    self.isFile = isFile
    self.size = size
    self.fileId = fileId
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
  
  // Fill the current empty block with the specified block, IF it fits.
  public mutating func fillEmptyBlock(with fileBlock: Block?) -> Block?{
    
    guard let fileBlock, let fileId = fileBlock.fileId else {
      // block was eitehr nil to begin with, OR it doesn't
      // have a file ID and is therefor an empty block we can't
      // use. Return nil
      return nil
    }
    
    guard fileBlock.size <= size else {
      // This file size is too large for this block. make no changes
      // and return nil
      // (can I combine these guard statements?)
      return nil
    }
    
    // update our fields to convert empty space to a file and create
    // a new block with any leftover space.
    let leftoverSpace = size-fileBlock.size
    self.fileId = fileId
    self.isFile = true // maybe do this with a didSet?
    self.size = fileBlock.size
    self.hasMoved = true // so we don't try to move this again
    
    if leftoverSpace > 0 {
      // we have some space leftover that needs to remain empty
      return Block(size: leftoverSpace)
    }
    return nil
  }
  
  public func calcChecksum(_ index: Int) -> Int? {
    
    guard let fileId else {
      return nil
    }
    let range = index..<index+size
    return range.map{$0 * fileId}.reduce(0,+)
  }
  
  func prettyPrint () {
    if let fileId {
      for _ in 0..<size {print(fileId, terminator: "")}
    } else {
      for _ in 0..<size {print(".", terminator: "")}
    }
  }
}

extension Block: CustomStringConvertible{
  public var description: String{
    if let fileId {
      return "File \(fileId) of size: \(size)"
    } else {
      return "Empty space of size \(size)"
    }
  }
}
