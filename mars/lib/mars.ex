defmodule Mars do

  def createInput() do
    "5 5\n1 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM"
  end
   
  # "RegExp validating the string pattern defined on the specification"
  def validateInput(input, regExp) do
      Regex.match?(regExp,input)   
  end

  #"first time reading input"
  def gettingValidInput(input, regExp) do
      regExpResult = runRegExp(input, regExp)
      List.pop_at(regExpResult,0) |> elem(0) #"return first element which contains a valid input"
  end
  #"manage the creation of the action map and execution of it"
  def runPlateau(input) do
      listOfInputs = Regex.split(~r{\n}, input)
      actionMap = createActionMap(listOfInputs)
      executePlateuActionMap(actionMap, 1)
  end

  #"executes once for each rover in the map "
  def executePlateuActionMap(actionMap, acc) do
    if Map.has_key?(actionMap, ~s(:rover#{acc})) do
      rouver = Map.get(actionMap, ~s(:rover#{acc})) #"get next rouver map"
      boundaries = Map.get(actionMap, :boundaries)
      xBoundary = String.to_integer(Enum.fetch!(boundaries,0))
      yBoundary = String.to_integer(Enum.fetch!(boundaries,1))
      plateauAction(xBoundary, yBoundary, Map.get(rouver, :xPosition), Map.get(rouver, :yPosition), Map.get(rouver, :direction), String.codepoints(Map.get(rouver, :listOfCommands)))
      executePlateuActionMap(actionMap, acc + 1)
    end
  end

  #"for each command within listOfCommands executes this function. Moves position, validates boundaries and rotates accordingly"
  def plateauAction(xBoundary, yBoundary, xPosition, yPosition, direction, listOfCommands) do
    popListResult =  List.pop_at(listOfCommands,0)
    currentCommand = popListResult |> elem(0)
    case currentCommand do
      "M" ->
        case direction do
          "N" ->
            plateauAction(xBoundary, yBoundary, xPosition, if(yBoundary < yPosition + 1, do: yBoundary, else: yPosition + 1), direction, popListResult|> elem(1))
          "W" ->
            plateauAction(xBoundary, yBoundary, if(xPosition - 1 < 0, do: 0, else: xPosition - 1), yPosition, direction, popListResult|> elem(1))
          "S" ->
            plateauAction(xBoundary, yBoundary, xPosition, if(yPosition - 1 < 0, do: 0, else: yPosition - 1), direction, popListResult |> elem(1))
          "E" -> 
            plateauAction(xBoundary, yBoundary, if(xBoundary < xPosition + 1, do: xBoundary, else: xPosition + 1), yPosition, direction, popListResult|> elem(1))
        end
      "L" ->
        plateauAction(xBoundary, yBoundary, xPosition, yPosition, rotateEnumL(direction), popListResult |> elem(1))
      "R" ->
        plateauAction(xBoundary, yBoundary, xPosition, yPosition, rotateEnumR(direction), popListResult |> elem(1)) 
      _ ->
      IO.puts ~s("#{xPosition} #{yPosition} #{direction}")
    end
  end  

  #"it could be a linked list and then I would just need to get next element"
  def rotateEnumR(currentDirection) do
        case currentDirection do
          "N" ->
            "E"
           "W" ->
            "N"
           "S" ->
            "W"
           "E" -> 
            "S"
        end
  end
  #"it could be a linked list and then I would just need to get next element"
  def rotateEnumL(currentDirection) do
        case currentDirection do
          "N" ->
            "W"
           "W" ->
            "S"
           "S" ->
            "E"
           "E" -> 
            "N"
        end
  end

  #"starts the creation of the action map by collecting the boundaries" 
  defp createActionMap(inputList) do
    inputListPopResult  =  List.pop_at(inputList,0)
    plateauBoundary     =  Regex.split(~r{ }, inputListPopResult |> elem(0)) #"creates a list with the boundaries"
    actionMap = %{boundaries: plateauBoundary}
    remainingInputList  =  inputListPopResult |> elem(1)
    createActionMap(remainingInputList, actionMap, 1)
  end

  #"creates a rover that contains direction, position and list of commands" 
  defp createActionMap(inputList, actionMap, acc) do
    if List.first(inputList) do
      inputListPopResult  =  List.pop_at(inputList,0)
      positionList        = returnRoverPosition(inputListPopResult) #"retrive direction and position"
      resultingObject     = List.pop_at(inputListPopResult |> elem(1), 0)
      commandList         = returnRoverListOfCommands(resultingObject) #"retrive command list"
      # "creating a new rover map" 
      roverMap = Map.new(positionList)
      roverMap = Map.put_new(roverMap, :listOfCommands, commandList)
      actionMap= Map.put_new(actionMap, ~s(:rover#{acc}), roverMap)  
      remainingInputList  =  resultingObject |> elem(1)
      createActionMap(remainingInputList, actionMap, acc + 1)
    else
      actionMap
    end
  end

  #"return direction and position of a rover"
  defp returnRoverPosition(inputListPopResult) do
    roverPosition   = inputListPopResult |> elem(0)
    roverPosition   = Regex.split(~r{ }, roverPosition)  
    # "breaking in varaibles the position and direction of a rover"
    xPosition = String.to_integer(Enum.fetch!(roverPosition, 0))
    yPosition = String.to_integer(Enum.fetch!(roverPosition, 1))
    direction = Enum.fetch!(roverPosition, 2)
    [xPosition: xPosition, yPosition: yPosition, direction: direction]
  end

  #"return list of commands of a rover"
  defp returnRoverListOfCommands(inputListPopResult) do
    # "getting list of commands"
    inputListPopResult |> elem(0)
  end

  #"RegExp return first element of Run which contains only valid inputs, avoiding end of line trash "
  defp runRegExp(input, regExp) do
    Regex.run(regExp,input)
  end

  #"Compile only once, for reuse "
  def returnRegExpCompiled() do
    Regex.compile(~s/((^\\d{1,3}\\s+\\d{1,3}$)(\\s*^\\d{1,3}\\s+\\d{1,3}\\s+[NSWE]$\\s*^[RLM]+$)+)/,"im")
  end

  def runMarsRovers() do
    input = createInput() #"inline testing"
    runMarsRovers(input)
  end

  def runMarsRovers([]) do
    input = createInput() #"inline testing"
    runMarsRovers(input)
  end
  
  def runMarsRovers(nil) do
    input = createInput() #"inline testing"
    runMarsRovers(input)
  end  

  def runMarsRovers(input) do  
    regExpTuple = returnRegExpCompiled() #"compile regular expression for further use"
    if elem(regExpTuple,0) == :ok do
      regExp = elem(regExpTuple,1);
      if validateInput(input, regExp) do #"if the regexp is valid then validate input"
        validInput = gettingValidInput(input, regExp)
        runPlateau(validInput)
        IO.puts ""
      end
    else
      IO.puts "Invalid regular expression"
    end  
  end
end
