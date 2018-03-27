defmodule MarsTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest Mars

  test "validating input - invalid input" do
  	regularExp = Mars.returnRegExpCompiled()
  	assert Mars.validateInput("12 N 12", elem(regularExp,1)) == false
  end

  test "validating input - only one valid input" do
  	regularExp = Mars.returnRegExpCompiled()
  	assert Mars.validateInput("5 5\n1 2 N\nLMLMLMLMM", elem(regularExp,1)) == true
  end

  test "validating input - test case provided my deepx" do
  	regularExp = Mars.returnRegExpCompiled()
  	assert Mars.validateInput("5 5\n1 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM", elem(regularExp,1)) == true
  end

  test "validating results - test case provided my deepx" do
  	frunMarsRovers = fn ->
  		Mars.runMarsRovers("5 5\n1 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM") 
  	end
  	assert String.contains? capture_io(frunMarsRovers), ["1 3 N", "5 1 E"]
  end

  test "validating results - testing boundaries" do
    frunMarsRovers = fn ->
  		Mars.runMarsRovers("5 5\n1 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM\n0 0 S\nMRMRM\n5 5 N\nMRMRM") 
  	end
  	assert String.contains? capture_io(frunMarsRovers), ["1 3 N", "5 1 E", "0 1 N", "5 4 S"]
  end

  test "validating results - testing starting out of boundaries" do
    frunMarsRovers = fn ->
  		Mars.runMarsRovers("5 5\n6 6 N\nMRMRM") 
  	end
  	assert String.contains? capture_io(frunMarsRovers), ["5 4 S"]
  end

end
