# Canabalt
### A HaxeFlixel port of CANABALT, by Adam 'Atomic' Saltsman, ported by Cameron 'ninjamuffin99' Taylor

## Setup


0. Make sure when you clone, you clone the submodules to get the assets repo:
    - `git clone --recurse-submodules https://github.com/ninjamuffin99/canabalt-hf.git`
    - If you accidentally cloned without the `assets` submodule (aka didn't follow the step above), you can run `git submodule update --init --recursive` to get the assets in a foolproof way.
1. Install Haxe from [Haxe.org](https://haxe.org), using 4.3.3 as of writing!
    - Recommend using [`haxeget`](https://github.com/l0go/haxeget)
2. Install `hmm` (run `haxelib --global install hmm` and then `haxelib --global run hmm setup`)
3. Install haxelibs by running `hmm install`
4. Compile via `lime test PLATFORM`, `mac`, `linux`, `windows`, `html5` and probably even `hl` 


## Todos
- [ ] Preloader.as 
    - Better looking PLAY button
    - Loading Canabalt text
- [ ] NG api fixes for Safari

### other notes
- [ ] Newgrounds Leaderboard API
    - proper in-game filtering
    - shows leaderboards in-game on click, and then saves that preference
     

# License
Licensing info can be found in the [LICENSE.md](LICENSE.md) file.

Please note that the game's assets are covered by a separate licence. Please see the [ninjamuffin99/canabalt-assets](https://github.com/ninjamuffin99/canabalt-assets/blob/main/LICENSE.md) repository for clarifications.


