# frozen_string_literal: true

class Player
  attr_accessor :name, :hand, :score, :is_dealer

  DEALER_NAME = 'ディーラー'
  DEFAULT_NAME = '名無し'

  # @param [String] name
  # @param [Boolean] is_dealer
  def initialize(name: '', is_dealer: false)
    @name =
      if is_dealer
        DEALER_NAME
      else
        name.empty? ? DEFAULT_NAME : name
      end
    @hand = []
    @score = 0
    @is_dealer = is_dealer
  end

  # @param [Deck] deck
  # @param [Integer] draw_count
  # @return [Array<Array<String, String>>]
  def draw_cards_from(deck:, draw_count: 1)
    deck.draw_and_remove_cards(card_count: draw_count).tap do |drawn_cards|
      @hand.concat(drawn_cards)
      calculate_score
    end
  end

  # @return [Boolean]
  def blackjack?
    score == Game::BLACK_JACK_SCORE
  end

  # @return [Boolean]
  def stand_randomly?
    score < Game::BLACK_JACK_SCORE && rand(10).even?
  end

  # @return [Boolean]
  def burst?
    score > Game::BLACK_JACK_SCORE
  end

  # @param [Integer] hand_index
  def show_card_at(hand_index)
    card_suit, card_mark = hand[hand_index - 1]
    puts "#{name}の引いた#{hand_index}枚目のカードは#{card_suit}の#{card_mark}です。\n"
  end

  def show_score
    puts "#{name}の現在の得点は#{score}です。\n"
  end

  private

  def calculate_score
    simple_sum = hand.sum { |_, mark| Game::CARD_MARK_SCORE_MAP[mark] }
    a_count = hand.count { |_, mark| mark == 'A' }
    @score =
      if a_count.positive?
        a_score = Game::CARD_MARK_SCORE_MAP['A']
        # 'A'は合計が21を超えないように1と11の大きな方を選択する
        (1..a_count).inject(simple_sum) do |sum, _|
          # 元のスコア(1)を引いて11を足してバーストしないかどうかをチェック
          tmp_score = (sum - a_score) + Game::OTHER_A_SCORE
          tmp_score <= Game::BLACK_JACK_SCORE ? tmp_score : sum
        end
      else
        simple_sum
      end
  end
end
