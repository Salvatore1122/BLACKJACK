# frozen_string_literal: true

Dir["#{File.dirname(__FILE__)}/models/*.rb"].sort.each { |f| require f }

puts "あなたの名前を入力してください。\n"
you = Player.new(name: gets.chomp)

puts "プレイヤー人数を入力してください。\n"
player_count = gets.chomp.to_i
loop do
  break if player_count >= Game::MIN_PLAYER_COUNT && player_count <= Game::MAX_PLAYER_COUNT

  puts "プレイヤー人数は#{Game::MIN_PLAYER_COUNT}人から#{Game::MAX_PLAYER_COUNT}人です。再度入力してください。\n"
  player_count = gets.chomp.to_i
end

# 操作者とディーラー以外のプレイヤーを作成
other_players = (player_count - 2).times.map { |i| Player.new(name: "プレイヤー#{i + 1}") }
dealer = Player.new(is_dealer: true)
deck = Deck.new.cards
game = Game.new(deck: deck, manual_player: you, other_players: other_players, dealer: dealer)

# ゲーム開始
# * 全員にカードを2枚ずつ配り、操作者の手札とスコア開示
# * ディーラーは1枚目のカードのみ開示
game.start

you.hand.each.with_index(1) { |_, i| you.show_card(i) }
you.show_score

dealer.show_card(1)
puts "ディーラーの引いた2枚目のカードは分かりません。\n"

# プレイヤーのターンを進行
game.advance_players_turn

# ディーラーのターン進行
is_all_burst = you.burst? && other_players.all?(&:burst?)
game.advance_dealer_turn unless is_all_burst

# 全員のスコア開示と勝者の発表
[you, *other_players, dealer].each(&:show_score)
game.show_winner(is_all_burst: is_all_burst)
puts "ブラックジャックを終了します。\n"
