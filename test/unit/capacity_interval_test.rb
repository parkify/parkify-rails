require 'test_helper'

class CapacityIntervalTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end
  
  # Read about fixtures at http://api.rubyonrails.org/classes/ActiveRecord/Fixtures.html
  
  #|--a1--|
  #        |--a2--|
  
  test "overlap_1" do
    a1=capacity_intervals(:overlap_1_A1).find
    a2=capacity_intervals(:overlap_1_A2).find
    #assert ! capacity_intervals(:overlap_1_A1).overlapping(capacity_intervals(:overlap_1_A2)
    assert ! a1.overlapping(a2)
  end
  

#|--a1--|
#       |--a2--|
  test "overlap_2" do
    a1=capacity_intervals(:overlap_2_A1).find.find
    a2=capacity_intervals(:overlap_2_A2).find
    assert ! a1.overlapping(a2)
  end

#|--a1--|
#      |--a2--|
  test "overlap_3" do
    a1=capacity_intervals(:overlap_3_A1).find
    a2=capacity_intervals(:overlap_3_A2).find
    assert a1.overlapping(a2)
  end


#|--a1--|
#|--a2--|
  test "overlap_4" do
    a1=capacity_intervals(:overlap_4_A1).find
    a2=capacity_intervals(:overlap_4_A2).find
    assert a1.overlapping(a2)
  end

#      |--a1--|
#|--a2--|
  test "overlap_5" do
    a1=capacity_intervals(:overlap_5_A1).find
    a2=capacity_intervals(:overlap_5_A2).find
    assert a1.overlapping(a2)
  end


#       |--a1--|
#|--a2--|
  test "overlap_6" do
    a1=capacity_intervals(:overlap_6_A1).find
    a2=capacity_intervals(:overlap_6_A2).find
    assert ! a1.overlapping(a2)
  end


#        |--a1--|
#|--a2--|
  test "overlap_7" do
    a1=capacity_intervals(:overlap_7_A1).find
    a2=capacity_intervals(:overlap_7_A2).find
    assert ! a1.overlapping(a2)
  end



#|---a1---|
#  |--a2--|
  test "overlap_8" do
    a1=capacity_intervals(:overlap_8_A1).find
    a2=capacity_intervals(:overlap_8_A2).find
    assert a1.overlapping(a2)
  end


#|---a1---|
# |--a2--|
  test "overlap_9" do
    a1=capacity_intervals(:overlap_9_A1).find
    a2=capacity_intervals(:overlap_9_A2).find
    assert a1.overlapping(a2)
  end



#|---a1---|
#|--a2--|
  test "overlap_10" do
    a1=capacity_intervals(:overlap_10_A1).find
    a2=capacity_intervals(:overlap_10_A2).find
    assert a1.overlapping(a2)
  end

#  |--a1--|
#|---a2---|
  test "overlap_11" do
    a1=capacity_intervals(:overlap_11_A1).find
    a2=capacity_intervals(:overlap_11_A2).find
    assert a1.overlapping(a2)
  end
  
# |--a1--|
#|---a2---|
  test "overlap_12" do
    a1=capacity_intervals(:overlap_12_A1).find
    a2=capacity_intervals(:overlap_12_A2).find
    assert a1.overlapping(a2)
  end

#|--a1--|
#|---a2---|
  test "overlap_13" do
    a1=capacity_intervals(:overlap_13_A1).find
    a2=capacity_intervals(:overlap_13_A2).find
    assert a1.overlapping(a2)
  end


end
