# frozen_string_literal: true

class Player
  attr_accessor :name, :hand, :is_dealer

  # @param [String] name
  # @param [Boolean] is_dealer
  def initialize(name: '', is_dealer: false)
    @name =
      if is_dealer
        'ディーラー'
      else
        name.empty? ? '名無し' : name
      end
    @hand = []
    @is_dealer = is_dealer
  end


  # @param [Array<Array<String, String>>] deck
  # @return [Array<String, String>]
  def draw_card(deck)
    deck.sample.tap do |drawn_card|
      @hand << drawn_card
      calculate_score
    end
  end

  private

  def calculate_score
    if hand.any? { |_, num| num == 'A' }
      simple_sum = hand.sum { |_, num| card_num_score_map[num] }
      @score = simple_sum <= 11 ? simple_sum + 9 : simple_sum
    else
      @score = hand.sum{ |_, num| card_num_score_map[num] }
    end
  end
end
