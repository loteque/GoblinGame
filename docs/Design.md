# Goblin Armies


### pxlpush

Revision: 0.0.1

License 

Copyright © Loteque, maeve 2024 - Present




- ![Overview](#overview)
  - ![Theme / Setting / Genre](#theme--setting--genre)
  - ![Targeted platforms](#targeted-platforms)
  - ![Project _**scope**_](#project-_**scope**_)
  - ![influences](#influences)
  - ![The Elevator Pitch](#the-elevator-pitch)
  - ![Project Description](#project-description)
  - ![What sets this project apart?](#what-sets-this-project-apart)
- ![Story and Gameplay](#story-and-gameplay)
  - ![Story](story)
  - ![Core Gameplay Mechanics Brief](#core-gameplay-mechanics-brief)
  - ![Gameplay Brief](gameplay-brief)
  - ![Core Gameplay Mechanics](#core-gameplay-mechanics)
  - ![Gameplay](gameplay)
- ![Assets](assets)
  - ![2D](2d)
  - ![Code](code)


## Overview
### Theme / Setting / Genre
- Themes: Environmental conservation
- Goblin army in a Fantasy Mad Max style wasteland.
- Genre: Console Real Time Strategy

### Targeted platforms
- Web
- Windows
- Linux


### Project _**scope**_ 
- **Game Time Scale**
  - Time Scale 2 weeks total

- **2 Core team members**
  - Maeve - Art
  - Loteque - Programming, Else

- **Aditional team members**
  - Jonah Bloom - Composer/Recording


### Influences
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


## Story and Gameplay
### Story Brief
- Corrupted goblins have taken over the lands and are taking all they can!
- Player’s goblin group are among the last uncorrupted and must save the land by defeating the corrupted goblins

### Core Gameplay Mechanics Brief
- Goblins are a primary resource.
- Player must build goblin army up to defeat the coruption

### Core Gameplay Mechanics
- Goblins are a primary resource.
- Special goblins (e.g., big goblins who throw smaller goblins).
- Character movement
  - Movement with keyboard / gamepad
- Player collects goblins
- Attackables:
  - Enemy Goblins
- Breakables:
  - Enemy Goblin Camps
  - ~~Crate~~ :_**scope**_
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
    - increases 'green' on the map

### Gameplay Brief
- The player starts with a player goblin. 
- They must wander the land, collecting npc goblins, build an army and build up their base in order to destroy the corrupted goblin army and restore the land.

### Gameplay
- [ ] Player starts with Player character.
- [ ] Player explores the map.
- [ ] Player locates and collects goblins.
- [x] ~~Player locates breakables.~~ :_**scope**_
- [ ] Player finds a corrupted goblin.
- [x] ~~NPC Goblins break breakables and collect scrap~~ :_**scope**_
- [ ] Player uses NPCs to Collects Scrap
- [ ] Player uses NPC Goblins to fight corrupted goblins.
- [ ] Player creates a Command center
- [ ] Enemy Command center spawns in
- [ ] Enemy goblins collect scrap
- [ ] Player sends NPC goblins to collect scrap.
- [ ] player and enemy return scrap to their command center
- [ ] Command center increases upgrade meter
- [ ] when upgrade meter is full comand center upgrades
- [ ] when command center upgrades green tiles spread
- [ ] Corrupted goblins attack command center.
- [ ] Player attacks corrupted command center.
- [ ] When player defeats corrupted goblin base (corrupted command center) they win the map.


## Assets
### 2D
### Textures
- [ ] Tiling Ground textures
  - [ ] green ground
  - [ ] grey ground
  - [ ] corrupted ground
- [x] ~~Tiling lava rivers~~ :_**scope**_
- [ ] Tiling Toxic Sludge Rivers

### Sprites
- [ ] NPC Goblins
  - [ ] Idle animation (1 directions)(forward)
  - [ ] Running animation (4 directions)
  - [ ] Attacking animation (4 directions)
  - [ ] Hurt animation (1 direction)(forward)
  - [ ] Collection sprite for basic particle effect
  - [ ] Thrown animation (goblin flying through air)
  - [ ] Dying animation (1 direction, spin into forward direction)

- [ ] Player Goblin
  - [ ] Idle animation (1 directions)(forward)
  - [ ] Walking animation (4 directions)
  - [ ] Attacking animation (4 directions)
  - [ ] Hurt animation (1 direction)(forward)
  - [ ] Dying animation (1 direction, spin into forward direction)

- [ ] Corrupted Goblin (medium size)
  - [ ] Idle animation (1 directions)(forward)
  - [ ] Running animation (4 directions)
  - [ ] Attacking animation (4 directions)
  - [ ] Hurt animation (1 direction)(forward)
  - [ ] Collection sprite for basic particle effect
  - [ ] Thrown animation (goblin flying through air)
  - [ ] Dying animation (1 direction, spin into forward direction)

- [x] Environment
  - [x] ~~Dead trees~~ :_**scope**_
  - [x] ~~Cliff faces~~ :_**scope**_
    - [x] ~~West and South are the faces~~ :_**scope**_
  - [x] ~~Cliff edges~~ :_**scope**_
    - [x] ~~East and north are the edges~~ :_**scope**_
  - [x] ~~Lava Plumes~~
  - [ ] Toxic Plumes
  - [x] ~~Healing pool~~ :_**scope**_

- [ ] Player Goblin Base
  - [ ] Initial state
    - [ ] Damaged
  - [ ] Upgraded state 1
    - [ ] Damaged
  - [ ] Upgraded state 2
    - [ ] Damaged
  - ~~Upgraded state 3~~ :_**scope**_
    - ~~Damaged~~ :_**scope**_
  - ~~Destroyed~~ :_**scope**_

- [ ] Enemy Goblin Base
  - [ ] Initial state
    - [ ] Damaged
  - [ ] Upgraded state 1
    - [ ] Damaged
  - [ ] Upgraded state 2
    - [ ] Damaged
  - [x] ~~Upgraded state 3~~ :_**scope**_
    - [x] ~~Damaged~~ :_**scope**_
  - [x] ~~Destroyed~~ :_**scope**_

- [ ] HUD Elements
  - [ ] Health bar for player
  - [ ] Health bar for NPC goblins
  - [ ] Scrap counter
  - [ ] Base upgrade status
  - [ ] Base health bar
  - [ ] Health bar for npc goblins
  - [x] ~~Destructibles health bar~~ :_**scope**_

### Code
- [ ] Character Scripts (Player Pawn/Player Controller)
  - [ ] Controller
  - [ ] Stats
  - [ ] State
  - [ ] animation

- [ ] Actor Scripts
  - [ ] controller
  - [ ] Stats
  - [ ] State
  - [ ] animation

- [ ] Base Scripts
  - [ ] Base
  - [ ] Army Manager

- [ ] Collectables Scripts
  - [ ] Scrap

- [ ] Breakables Script
  - [ ] Bases

- [ ] Static Unit Object Script
  - [ ] Bases

- [ ] Ambient Scripts (Runs in the background)
  - [ ] Game state Manager
  - [ ] Level Manager
  - [ ] HID Manager
  - [ ] Audio Manager
    - [ ] SFX Manager
    - [ ] Music Manager
    <details>
      <summary>Detailed View</summary>
    
    - [ ] SFX Manager
    - [ ] Music Manager
      - [ ] tracks which layers of music are playing 
      - [ ] plays calm music at the beginning of the game
      - [ ] listens for player_left_base_signal
        - [ ] if player not in combat 
        - [ ] checks if this music layer is already playing
        - [ ] on_player_left_base fades in exploration layer
      - [ ] listens for damage_taken signal
        - [ ] checks if this music layer is already playing
        - [ ] on_damage_taken fades in combat layer
      - [ ] listens for combat_finished signal
        - [ ] fades out all music
        - [ ] starts silence timer
        - [ ] on silence_timer_timeout
          - [ ] if base::player_in_base=true and combat=false: fadein calm layer
          - [ ] else: fadein calm layer and exploration layer
      </details>    
  - [ ] Environemnt Manager (ground tiles)
