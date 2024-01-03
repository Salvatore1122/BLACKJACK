# frozen_string_literal: true

class Deck
  # cardsは以下のような配列で構成される
  # ex. [['ハート', 'A'], ['ハート', '2'], ['ハート', '3'], ... ['クラブ', 'K']]
  attr_accessor :cards

  CARD_FACES = %w[ハート ダイヤ スペード クラブ].freeze
  CARD_MARKS = %w[A 2 3 4 5 6 7 8 9 10 J Q K].freeze

  def initialize
    @cards = CARD_FACES.product(CARD_MARKS)
  end
end
