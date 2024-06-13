# Goblin Armies


### pxlpush

Revision: 0.0.1

License 

Copyright © Loteque, maeve 2024 - Present




### Overview
![](Theme / Setting / Genre)
![](Core Gameplay Mechanics Brief)
![](Targeted platforms)
![](Monetization model (Brief/Document))
![](Project Scope)
![](Influences (Brief))
![](The Elevator Pitch)
![](Project Description (Brief))
![](What sets this project apart?)
![](Core Gameplay Mechanics (Detailed))
![](Story and Gameplay)
![](Story (Brief))
![](Gameplay (Brief))
![](Assets)
![](2D)
![](Code)



### Theme / Setting / Genre
- Themes: Environmental conservation
- Goblin army in a Fantasy Mad Max style wasteland.
- Genre: Console Real Time Strategy

### Core Gameplay Mechanics Brief
- Goblins are a primary resource.
- Player must build goblin army up to defeat the coruption

### Targeted platforms
- Web
- Windows
- Linux


### Project Scope 
**Game Time Scale**
- Time Scale 2 weeks total

**2 Core team members**
- Maeve - Art
- Loteque - Programming, Else

**Aditional team members**
- Jonah Bloom - Composer/Recording


### Influences (Brief)
- Disgaea
  - Video Game
  - Noted for its turn-based strategy and character-throwing mechanics.
- Pikmin
  - Video game
  - Mentioned in the context of RTS but clarified that it is an RTS, not TBS.
- Mad Max Furiosa
  - Movie
  - Visual style, feel.
- Pizza Tower
  - Video Game
  - Visual Style

### The Elevator Pitch
Pikmin, but goblins with more war

### What sets this project apart?
- It is an RTS, fully playable on console. These are rare
- It has Thematic elements of Environmental Conservation through teamwork
- If give a unique perspective of goblins as protectors of the land

### Core Gameplay Mechanics (Detailed)
- Goblins are a primary resource.
- Special goblins (e.g., big goblins who throw smaller goblins).
- Character movement
  - Movement with keyboard / gamepad
- Player collects goblins
- Attackables:
  - Enemy Goblins
  - Breakables:
  - Enemy Goblin Camps
  - Crate
- Collectables:
  - Scrap
- Player has health
- NPC goblins can attack
- Autoattack based on range.
  - Can target:
    - Attackables
    - Breakables
  - Can collect Collectables
    - Auto-collect when near
- (stretch) Basic goblins can specialize into advanced classes like:
    - tough goblins
   - wizards
- Map:
  - Mostly Open
  - Minimal obstacles
- Player has a base, A single (Command center)
- Player can upgrade the command center.
  - Upgrades cost scrap
  - When they upgrade the base:
    - Increases Goblin production rate.





## Story and Gameplay
### Story (Brief)
- Corrupted goblins have taken over the lands and are taking all they can!
- Player’s goblin group are among the last uncorrupted and must save the land by defeating the corrupted goblins

### Gameplay (Brief)
- The player starts with a player goblin. 
- They must wander the land, collecting npc goblins, build an army and build up their base in order to destroy the corrupted goblin army.

### Gameplay (Detailed)
- Player starts with Player character.
- Player explores the map.
- Player locates and collects goblins.
- Player locates breakables.
- Player finds a corrupted goblin.
- NPC Goblins break breakables and collect scrap
- NPC Goblins fight corrupted goblins.
- Player creates a Command center
- Player sends NPC goblins to collect scrap.
- Player upgrades command center
- Corrupted goblins attack command center.
- Player attacks corrupted command center.
- When player defeats corrupted goblin base (corrupted command center) they win the map.


## Assets
### 2D
### Textures
- Tiling Ground texture
- Tiling lava rivers

### Sprites
- NPC Goblins
  - Idle animation (1 directions)(forward)
  - Running animation (4 directions)
  - Attacking animation (4 directions)
  - Hurt animation (1 direction)(forward)
  - Collection sprite for basic particle effect
  - Thrown animation (goblin flying through air)
  - Dying animation (1 direction, spin into forward direction)

- Player Goblin
  - Idle animation (1 directions)(forward)
  - Walking animation (4 directions)
  - Attacking animation (4 directions)
  - Hurt animation (1 direction)(forward)
  - Dying animation (1 direction, spin into forward direction)

- Corrupted Goblin (medium size)
  - Idle animation (1 directions)(forward)
  - Running animation (4 directions)
  - Attacking animation (4 directions)
  - Hurt animation (1 direction)(forward)
  - Collection sprite for basic particle effect
  - Thrown animation (goblin flying through air)
  - Dying animation (1 direction, spin into forward direction)

- Environment
  - Dead trees
  - Cliff faces
    - West and South are the faces
  - Cliff edges
    - East and north are the edges
  - Lava Plumes
  - Healing pool

- Command center
  - Initial state
    - Damaged
  - Upgraded state 1
    - Damaged
  - Upgraded state 2
    - Damaged
  - Upgraded state 3
    - Damaged
  - Destroyed

- Corupted Command center
  - Initial state
    - Damaged
  - Upgraded state 1
    - Damaged
  - Upgraded state 2
    - Damaged
  - Upgraded state 3
    - Damaged
  - Destroyed

- HUD Elements
  - Health bar for player
  - Health bar for NPC goblins
  - Scrap counter
  - Base upgrade status
  - Base health bar
  - Health bar for npc goblins
  - Destructibles health bar

### Code
- Character Scripts (Player Pawn/Player Controller)
  - Controller
  - Stats
  - State
  - animation

- NPC Scripts
  - controller
  - Stats
  - State
  - animation

- Base Scripts
  - Base State
  - Army Manager

- Ambient Scripts (Runs in the background)
  - Game state Manager
  - Level Manager
  - HID Manager
  - Audio Manager
