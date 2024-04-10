require 'ruby2d'

set title: "Dinosaur Game"

set fullscreen: true

hero = Sprite.new('mort_test.png',
width: 48,
height: 48,
clip_width: 48
)

on :key_held do |event|
  case event.key
  when 'left'
    hero.play flip: :horizontal

    if hero.x > 0
      hero.x -= 1
    end
  when 'right'
    hero.play

    if hero.x > (Window.width - hero.width)
      hero.x += 1
    end
  end
end



on :key_up do
  hero.stop
end



show