# frozen_string_literal: true

class Game
  # スコアに関する定数
  CARD_MARK_SCORE_MAP = {
    'A' => 1,
    '2' => 2,
    '3' => 3,
    '4' => 4,
    '5' => 5,
    '6' => 6,
    '7' => 7,
    '8' => 8,
    '9' => 9,
    '10' => 10,
    'J' => 10,
    'Q' => 10,
    'K' => 10
  }.freeze
  OTHER_A_SCORE = 11
  BLACK_JACK_SCORE= 21
  MIN_DEALER_SCORE = 17

  # プレイヤーに関する定数
  MIN_PLAYER_COUNT = 2
  MAX_PLAYER_COUNT = 4

  # 手札に関する定数
  DEFAULT_HAND_SIZE = 2

  # @param [Deck] deck
  # @param [Player] manual_player
  # @param [Array<Player>] other_players
  # @param [Player] dealer
  def initialize(deck:, manual_player:, dealer:, other_players: [])
    @deck = deck
    @manual_player = manual_player
    @other_players = other_players
    @dealer = dealer
  end

  def start
    puts "ブラックジャックを開始します\n"

    # プレイヤーとディーラーにカードを2枚ずつ配る
    [@manual_player, *@other_players, @dealer].each do |player|
      player.draw_cards_from(deck: @deck, draw_count: DEFAULT_HAND_SIZE)
    end
  end

  def advance_players_turn
    # 操作者のターン
    loop do
      @manual_player.show_score
      puts "カードを引きますか？(Y/N)\n"
      input = gets.chomp

      break if input == 'N'

      if input != 'Y'
        puts "入力はYかNでお願いします。\n"
        next
      end

      @manual_player.draw_cards_from(deck: @deck)
      @manual_player.show_card_at(@manual_player.hand.size)

      if @manual_player.burst?
        puts "バーストしました。\n"
        break
      end
    end

    # 他のプレイヤーのターン
    @other_players.each do |player|
      loop do
        # ブラックジャック or バースト or (ランダムで)スタンド でターン終了
        break if player.blackjack? || player.burst? || player.stand_randomly?

        player.draw_cards_from(deck: @deck)
      end
    end
  end

  def advance_dealer_turn
    while @dealer.score < MIN_DEALER_SCORE
      @dealer.show_card_at(@dealer.hand.size)
      @dealer.show_score

      @dealer.draw_cards_from(deck: @deck)

      @dealer.show_card_at(@dealer.hand.size)
    end
  end

  # @param [Boolean] is_all_burst
  def show_winner(is_all_burst: false)
    if is_all_burst
      puts "プレイヤーが全員バーストしたため、#{@dealer.name}の勝ちです。\n"
    else
      winner = [@manual_player, *@other_players, @dealer].select do |player|
        player.score <= BLACK_JACK_SCORE
      end.max_by(&:score)
      puts "#{winner.name}の勝ちです。\n"
    end
  end
end
