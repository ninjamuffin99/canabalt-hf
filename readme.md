# Canabalt
### A HaxeFlixel port of CANABALT, by Adam 'Atomic' Saltsman, ported by Cameron 'ninjamuffin99' Taylor

This is a port of classic flash game CANABALT, which was ported into HaxeFlixel (the descendant of Flixel, which was used in the original game). Now supports various cross platform goodness (HTML5, Windows, Mac, Linux), the Newgrounds API ([via Newgrounds.io](https://newgrounds.io)) for leaderboards, and touch + gamepad support!

You can play the game on:
- [Newgrounds.com](https://www.newgrounds.com/portal/view/510303)
- [Itch.io](https://finji.itch.io/canabalt-classic)
- [Canabalt.com](https://canabalt.com/)

## Setup

0. Make sure when you clone, you clone the submodules to get the assets repo:
    - `git clone --recurse-submodules https://github.com/ninjamuffin99/canabalt-hf.git`
    - If you accidentally cloned without the `assets` submodule (aka didn't follow the step above), you can run `git submodule update --init --recursive` to get the assets in a foolproof way.
1. Install Haxe from [Haxe.org](https://haxe.org), using 4.3.3 as of writing!
    - Recommend using [`haxeget`](https://github.com/l0go/haxeget)
2. Install `hmm` (run `haxelib --global install hmm` and then `haxelib --global run hmm setup`)
3. Install haxelibs by running `hmm install`
4. Compile via `lime test PLATFORM`, `mac`, `linux`, `windows`, `html5` and probably even `hl` 

## How close to the original source is this 🤔

The haxe code is as close to the original source code as it could get, with minor tweaks for modern "flixel", crossplatform controls support, and small bug fixes. If you look through the code, what you will look at is very close to what Adam Saltsman wrote for the original Actionscript 3 release of Canabalt, *hopefully* resulting in 1:1 gameplay.

# License
Licensing info can be found in the [LICENSE.md](LICENSE.md) file.

Please note that the game's assets are covered by a separate licence. Please see the [ninjamuffin99/canabalt-assets](https://github.com/ninjamuffin99/canabalt-assets/blob/main/LICENSE.md) repository for clarifications.


