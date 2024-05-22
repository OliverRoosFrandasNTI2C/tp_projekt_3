require 'ruby2d'  # Laddar Ruby2D-biblioteket för att skapa spelet

# Ställer in spel-fönstrets titel och dimensioner
set title: "DinoRun"
set width: 800
set height: 400

# Laddar och ställer in bakgrundsbilden
background_image = Image.new(
  'img/background1.png',  # Sökvägen till bakgrundsbilden
  width: 800,         # Bildens bredd
  height: 400,        # Bildens höjd
  z: -1               # Z-index för att placera bilden bakom andra objekt
)

# Definierar Dino-klassen för spelkaraktären
class Dino
  attr_reader :x, :y, :height, :width  # Gör dessa attribut tillgängliga externt

  def initialize
    @x = 50          # Initial x-position för dino
    @y = 314         # Initial y-position för dino
    @height = 30     # Dinons höjd
    @width = 48      # Dinons bredd
    @velocity = 2    # Initial hastighet
    @gravity = 0.8   # Gravitationskraft
    @jump_power = -15 # Hopphöjd
    @on_ground = true # Indikerar om dino är på marken

    # Skapar en sprite för dino
    @dino = Sprite.new(
      'img/mort_test.png',  # Sökvägen till spriten
      width: 48,        # Spritens bredd
      height: 48,       # Spritens höjd
      clip_width: 48,   # Bredden på varje bildruta i spriten
      y: @y             # Initial y-position för spriten
    )
  end

  # Metod för att få dino att hoppa
  def jump
    return unless @on_ground  # Hoppa bara om dino är på marken

    @velocity = @jump_power  # Ställ in hastigheten till hopphöjden
    @on_ground = false       # Indikerar att dino är i luften
  end

  # Metod för att flytta dino och hantera gravitation
  def move
    @velocity += @gravity  # Ökar hastigheten med gravitationen
    @y += @velocity        # Uppdaterar y-positionen baserat på hastigheten

    if @y >= 314  # Om dino når marken
      @y = 314      # Återställ y-positionen till marknivå
      @velocity = 0 # Nollställ hastigheten
      @on_ground = true  # Indikerar att dino är på marken
    end

    @dino.y = @y  # Uppdaterar spritens y-position
  end
end

# Definierar Cactus-klassen för hinder
class Cactus
  attr_reader :x, :y, :width, :height  # Gör dessa attribut tillgängliga externt

  def initialize(x)
    @x = x          # Initial x-position för kaktusen
    @y = 300        # Initial y-position för kaktusen
    @width = 60     # Kaktusens bredd
    @height = 60    # Kaktusens höjd
    @speed = 5      # Hastighet som kaktusen rör sig med

    # Skapar en bild för kaktusen
    @cactus = Image.new(
      'img/Kaktus.png',  # Sökvägen till bilden
      x: @x,         # Initial x-position för bilden
      y: @y,         # Initial y-position för bilden
      width: @width, # Bildens bredd
      height: @height # Bildens höjd
    )
  end

  # Metod för att flytta kaktusen till vänster
  def move
    @x -= @speed  # Minskar kaktusens x-position med dess hastighet
    @cactus.x = @x  # Uppdaterar bildens x-position
  end

  # Kontroll för att se om kaktusen är utanför skärmen
  def off_screen?
    @x + @width < 0  # Returnerar true om kaktusen är utanför skärmens vänstra kant
  end
end

# Skapar en instans av dino och en tom array för kaktusar
dino = Dino.new  # Skapar en ny dino-instans
cactus = []      # Skapar en tom array för kaktusar

# Variabler för att hålla reda på senaste kaktusens spawn-position och minimalt avstånd
last_cactus_spawn = 800  # Startvärde för senaste spawn-positionen
min_distance_between_cacti = 200  # Minsta avstånd mellan två kaktusar

# Poängsystem
points = 0  # Startar poängen på 0
point_text = Text.new("Points: #{points}", x: 10, y: 10, size: 20, color: 'black')  # Skapar en text som visar poängen

# Spelloopen
update do
  # Skapar en ny kaktus slumpmässigt
  if last_cactus_spawn < (800 - min_distance_between_cacti) && rand(100) < 2
    cactus.push(Cactus.new(800))  # Lägger till en ny kaktus i arrayen
    last_cactus_spawn = 800       # Återställer spawn-positionen
  end

  # Flyttar varje kaktus och tar bort de som är utanför skärmen
  cactus.each(&:move)        # Anropar move-metoden på varje kaktus
  cactus.reject!(&:off_screen?)  # Tar bort kaktusar som är utanför skärmen

  # Flyttar dino
  dino.move  # Anropar move-metoden på dino

  # Kollisionsdetektering mellan dino och kaktusar
  cactus.each do |c|
    if dino.y + dino.height >= 300 && dino.y <= 350 &&  # Kollar om dino är inom kaktusens höjdområde
       dino.x - 20 >= c.x && dino.x <= c.x + c.width  # Kollar om dino är inom kaktusens x-område
      close  # Stänger spelet om en kollision inträffar
    end
  end

  # Uppdaterar poängen
  points += 1  # Ökar poängen med 1
  point_text.text = "Points: #{points}"  # Uppdaterar poängtexten

  # Flyttar spawn-punkten närmare dino
  last_cactus_spawn -= 5  # Minskar avståndet till nästa spawn-punkt
end

# Gör att dino hoppar när mellanslagstangenten trycks ned
on :key_down do |event|
  if event.key == 'space'  # Kollar om mellanslagstangenten trycks ned
    dino.jump  # Får dino att hoppa
  end
end

# Visar fönstret
show  # Startar spelet