import Algorithms

struct Day05: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  // Split input data into array of two strings
  var entities: [String]{ data.split(separator: "\n\n").map{String($0)}}
  
  // Split the string up, then convert it to a dictionary where the key
  // comes from the SECOND value in the rules, and the value is an array
  // of numbers that the key cannot be before
  func makeRuleDictionary(strings:String) -> [Int:[Int]]{
    var dict:[Int:[Int]] = [:]
    strings.split(separator: "\n").forEach{
      let split = $0.split(separator: "|").compactMap{Int($0)}
      let key = split.last!
      let value = split.first!
      let newDict:[Int:[Int]] = [key:[value]]
      dict.merge(newDict){
        $0 + $1
      }
    }
    return dict
  }
  
  func makeListOfReports(string: String) -> [[Int]]{
    return string.split(separator: "\n").map {
      $0.split(separator: ",").compactMap { Int($0) }
    }
  }
  
  func part1() -> Any {
    let input = entities
    
    let cantBeBefore = makeRuleDictionary(strings: input.first!)
    let reports = makeListOfReports(string: input.last!)
    
    return reports.compactMap {
      var isValidReport = true
      
      var reportToProcess = $0
      
      
      while !reportToProcess.isEmpty && isValidReport {
        let valueToCheck = reportToProcess.first!
        let remainingItems = reportToProcess.dropFirst()
        if let rule = cantBeBefore[valueToCheck]{
          // There is a rule for valueToCheck
          // allSatisfy should return true if NONE of the numbers
          // in the report are also in list of numbers that the value
          // can't be before
          isValidReport = remainingItems.allSatisfy{
            return !rule.contains($0)
          }
        }
        reportToProcess = Array(remainingItems)
      }
      
      if isValidReport{
        let middleIx = ($0.count-1)/2
        return $0[middleIx]
      } else { return nil}
    }.reduce(0, +)
  }
  
  func part2() -> Any {
    
    let input = entities
    
    let cantBeBefore = makeRuleDictionary(strings: input.first!)
    let reports = makeListOfReports(string: input.last!)
    
    let invalidReports = reports.compactMap {
      var isValidReport = true
      
      var reportToProcess = $0
      
      
      while !reportToProcess.isEmpty && isValidReport {
        let valueToCheck = reportToProcess.first!
        let remainingItems = reportToProcess.dropFirst()
        if let rule = cantBeBefore[valueToCheck]{
          // There is a rule for valueToCheck
          // allSatisfy should return true if NONE of the numbers
          // in the report are also in list of numbers that the value
          // can't be before
          isValidReport = remainingItems.allSatisfy{
            return !rule.contains($0)
          }
        }
        reportToProcess = Array(remainingItems)
      }
      
      if !isValidReport{
        return $0
      } else { return nil}
    }
    
    return invalidReports.compactMap{
      var reportToProcess = $0
      var sortedReport:[Int] = []
      
      while !reportToProcess.isEmpty {
        let valueToCheck = reportToProcess.first!
        var remainingItems = reportToProcess.dropFirst()
        guard !remainingItems.isEmpty else {
          // this was the last item
          sortedReport.append(valueToCheck)
          break
        }
        if let rule = cantBeBefore[valueToCheck]{
          // There are values that cannot be before value to check
          if remainingItems.allSatisfy({!rule.contains($0)}){
            // remaining items doesn't contain any values that are in our
            // rule, so this value is sorted correctly
            sortedReport.append(valueToCheck)
          } else {
            remainingItems.append(valueToCheck)
          }
          
        } else {
          // There was no rule for this item, so it is in
          // correct order already. Add to the new sorted array
          sortedReport.append(valueToCheck)
        }
        reportToProcess = Array(remainingItems)
      }
      let middleIx = (sortedReport.count-1)/2
      return sortedReport[middleIx]
    }.reduce(0, +)
  }
}
