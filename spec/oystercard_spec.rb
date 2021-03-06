require "oystercard"
require "journey"
describe Oystercard do

  let(:max_bal)  { Oystercard::DEFAULT_LIMIT }
  let(:min_fare) { Journey::MINIMUM_FARE }
  let(:penalty)  { Journey::PENALTY }

  let(:station) { double :station }

  let(:journey) { double :journey, in_s: 'Whitechapel', :in_s= => nil, :out= => nil }

  let(:journey_log) { double :journey_log, start: "" }

  subject { described_class.new(journey_log) }

  describe "#balance" do
    it { is_expected.to respond_to(:balance) }

    it "creates new card with balance 0" do
      expect(subject.balance).to eq 0
    end

  end

  describe "#top_up" do
    it "allows users to add money to their oystercard" do
      expect(subject.top_up(500)).to eq 500
    end

    it "enforces maximum balance limit" do
      subject.top_up(max_bal)
      expect { subject.top_up(1) }.to raise_error("Cannot top up over maximum limit (£90)")
    end
  end

  describe "#touch_in" do
    # passes station to journeylog
    # receives fare information and updates balance

    # it "changes value of in_journey to true" do
    #   subject.top_up(min_fare)
    #   subject.touch_in(station)
    #   expect(subject).to be_in_journey
    # end
    it "will not allow touch in if insufficient funds" do
      expect{ subject.touch_in(station) }.to raise_error "Insufficient funds on card (required £#{min_fare/100})"

    end

    # it 'passes station to journeylog object' do
    #   subject.top_up(5000)
    #   subject.touch_in(station)
    #   expect(subject.journey_log.include?(journey)).to eq true
    # end

    # it "will remember the touch in station" do
    #   subject.top_up(min_fare)
    #   subject.touch_in(station)
    #   expect(subject.journeys.last.in_s).to eq station
    # end

    # it "will charge a penalty fare if no touch out" do
    #   subject.top_up(min_fare)
    #   subject.touch_in(station)
    #   expect{ subject.touch_in(station) }.to change { subject.balance }.by -penalty
    # end
  end

  describe "#touch_out" do

    before do
      subject.top_up(min_fare)
      subject.touch_in(station)
    end

    # it "changes value of in_journey to false" do
    #   subject.touch_out(station)
    #   expect(subject).not_to be_in_journey
    # end

    # it "deducts minimum fare from balance" do
    #   expect { subject.touch_out(station) }.to change{ subject.balance }.by(-min_fare)
    # end
    # it "will charge a penalty fare if no touch in" do
    #   subject.touch_out(station)
    #   expect{ subject.touch_out(station) }.to change { subject.balance }.by -penalty
    # end
  end

  describe "#journeys" do
    it "creates new journey log on initialization" do
      oc = Oystercard.new(journey_log)
      expect(oc.journey_log).to eq journey_log
    end

    # let(:journey) { double :journey, in_s: nil, out: nil, :in_s= => nil, :out= => nil,
    #                 fare: 100}
    # it "records touch in and touch out stations" do
    #   subject.top_up(2 * min_fare)
    #   subject.touch_in(station, journey)
    #   subject.touch_out(station, journey)
    #   subject.touch_in(station, journey)
    #   subject.touch_out(station, journey)
    #   expect(subject.journeys).to eq [journey, journey]
    # end
  end

end
