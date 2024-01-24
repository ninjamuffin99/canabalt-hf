# Canabalt
### A HaxeFlixel port of CANABALT, by Adam 'Atomic' Saltsman, ported by Cameron 'ninjamuffin99' Taylor

## Setup

1. Install Haxe from [Haxe.org](https://haxe.org), using 4.3.3 as of writing!
    - Recommend using [`haxeget`](https://github.com/l0go/haxeget)
2. Install `hmm` (run `haxelib --global install hmm` and then `haxelib --global run hmm setup`)
3. Install haxelibs by running `hmm install`
4. Compile via `lime test PLATFORM`, `mac`, `linux`, `windows`, `html5` and probably even `hl` 


## AS3 -> Haxe PROGRESS

- [X] BG.as
- [-] Bomb.as
    - Need to finish implementing some stuff for the emitter + uncomment some code
- [X] CBlock.as
- [X] CraneTrigger.as
- [ ] DemoMgr.as
- [X] Dove.as
- [X] Jet.as
- [X] MenuState.as
- [X] Obstacle.as
- [X] Player.as
- [-] PlayState.as
- [ ] Sequence.as
    - Need Collapsible buildings
    - Bomb Code
- [X] Shard.as
- [X] Walker.as
- [X] Window.as
- [X] Canabalt.as -> Main.hx
- [ ] Preloader.as 
    - Convert / just remake the preloader, with a button to load the title screen.

## todo, and other notes
### TODOS
- [ ] Bomb buildings

### other notes
- [X] Controller support
- [X] Touch screen support (in HTML5)
- [ ] Newgrounds Leaderboard API
    - proper in-game filtering