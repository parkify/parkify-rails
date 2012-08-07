require 'spec_helper'

describe CapacityInterval do
  #pending "add some examples to (or delete) #{__FILE__}"
  
  #|--a1--|
  #        |--a2--|
  it "shouldn't overlap disjoint 1" do
    a1 = Factory.build(:capacity_interval, start_time: Time.at(0), end_time: Time.at(7))
    a2 = Factory.new(:capacity_interval, start_time: Time.at(8), end_time: Time.at(15))
    CapacityInterval.overlapping(a2).should == []
  end
  
  #|--a1--|
  #       |--a2--|
  it "shouldn't overlap adjacent 1" do
    a1 = Factory.build(:capacity_interval, start_time: Time.at(0), end_time: Time.at(7))
    a2 = Factory.new(:capacity_interval, start_time: Time.at(7), end_time: Time.at(14))
    CapacityInterval.overlapping(a2).should == []
  end
  
  #|--a1--|
  #      |--a2--|
  it "should overlap cross 1" do
    a1 = Factory.build(:capacity_interval, start_time: Time.at(0), end_time: Time.at(7))
    a2 = Factory.new(:capacity_interval, start_time: Time.at(6), end_time: Time.at(13))
    CapacityInterval.overlapping(a2).should == [a1]
  end
  
  #|--a1--|
  #|--a2--|
  it "should overlap equal 1" do
    a1 = Factory.build(:capacity_interval, start_time: Time.at(0), end_time: Time.at(7))
    a2 = Factory.new(:capacity_interval, start_time: Time.at(0), end_time: Time.at(7))
    CapacityInterval.overlapping(a2).should == [a1]
  end
  
  #      |--a1--|
  #|--a2--|
  it "should overlap cross 2" do
    a1 = Factory.build(:capacity_interval, start_time: Time.at(6), end_time: Time.at(13))
    a2 = Factory.new(:capacity_interval, start_time: Time.at(0), end_time: Time.at(7))
    CapacityInterval.overlapping(a2).should == [a1]
  end
  
  #       |--a1--|
  #|--a2--|
  it "shouldn't overlap adjacent 2" do
    a1 = Factory.build(:capacity_interval, start_time: Time.at(7), end_time: Time.at(14))
    a2 = Factory.new(:capacity_interval, start_time: Time.at(0), end_time: Time.at(7))
    CapacityInterval.overlapping(a2).should == []
  end
  
  #        |--a1--|
  #|--a2--|
  it "shouldn't overlap disjoint 2" do
    a1 = Factory.build(:capacity_interval, start_time: Time.at(8), end_time: Time.at(15))
    a2 = Factory.new(:capacity_interval, start_time: Time.at(0), end_time: Time.at(7))
    CapacityInterval.overlapping(a2).should == []
  end
  
  #|---a1---|
  #  |--a2--|
  it "should overlap subset 1" do
    a1 = Factory.build(:capacity_interval, start_time: Time.at(0), end_time: Time.at(9))
    a2 = Factory.new(:capacity_interval, start_time: Time.at(2), end_time: Time.at(9))
    CapacityInterval.overlapping(a2).should == [a1]
  end
  
  #|---a1---|
  # |--a2--|
  it "should overlap subset 2" do
    a1 = Factory.build(:capacity_interval, start_time: Time.at(0), end_time: Time.at(9))
    a2 = Factory.new(:capacity_interval, start_time: Time.at(1), end_time: Time.at(8))
    CapacityInterval.overlapping(a2).should == [a1]
  end
  
  #|---a1---|
  #|--a2--|
  it "should overlap subset 3" do
    a1 = Factory.build(:capacity_interval, start_time: Time.at(0), end_time: Time.at(9))
    a2 = Factory.new(:capacity_interval, start_time: Time.at(0), end_time: Time.at(7))
    CapacityInterval.overlapping(a2).should == [a1]
  end
  
  #  |--a1--|
  #|---a2---|
  it "should overlap subset 4" do
    a1 = Factory.build(:capacity_interval, start_time: Time.at(2), end_time: Time.at(9))
    a2 = Factory.new(:capacity_interval, start_time: Time.at(0), end_time: Time.at(9))
    CapacityInterval.overlapping(a2).should == [a1]
  end
  
  # |--a1--|
  #|---a2---|
  it "should overlap subset 5" do
    a1 = Factory.build(:capacity_interval, start_time: Time.at(1), end_time: Time.at(8))
    a2 = Factory.new(:capacity_interval, start_time: Time.at(0), end_time: Time.at(9))
    CapacityInterval.overlapping(a2).should == [a1]
  end
  
  #|--a1--|
  #|---a2---|
  it "should overlap subset 6" do
    a1 = Factory.build(:capacity_interval, start_time: Time.at(0), end_time: Time.at(7))
    a2 = Factory.new(:capacity_interval, start_time: Time.at(0), end_time: Time.at(9))
    CapacityInterval.overlapping(a2).should == [a1]
  end

end