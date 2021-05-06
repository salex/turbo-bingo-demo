# README

This is a demo of a Rails app using Turbo (turbo-rail) to stream the current results of a game. This could be a box score for a live event like baseball or football, but in this case it's Bingo game.

I did this in trying to understand how Turbo work. It works, but is probably of not much use - other that demonstrate how a scorer (caller in this case) can stream the current status of a game to the players. 

* There is only one model - Game.
* Game is inherited by class Bingo. (a resource in routes)
* Bingo only has :show, :edit and :update actions
  * Show is the players/consumers view of the status
  * Edit is the caller control of the game. Control is only uses click on objects that are sent to a Stimulus controller.
  * Update responds from form submission send by the Stimulus controller and updates the game, then renders the edit action.
  * The update commit broadcasts the HTML changes to the viewers.


The player and caller views look about the same. The viewer can take no actions. The caller can click on a Bingo number and it will be broadcast updates to the viewers. The caller also has a button bar that can send actions to the Stimulus controller. Actions are like taking a break, responding to a bingo call - then resume the game if there was an error, or indicate the game was won and start a new game.

Turbo-rails adds helpers that are somewhat confusing. I tried using the turbo frames without using the dom_id helper to build the key, but I could not get it to work - again it seems model-centric. I have not found any examples of `broadcasts_to` which may be the missing piece.

Again, this has no real use. I tried this several years ago with jQuery/coffescript. I had rasperryPi's on large screen TV's to prototype the concept. Semi-worked but we decided not the have Bingo games.

The loop below shows how the caller controls the game in the left view, and the viewer response in in the right view.

Hell, I had nothing better to do!


![bingoloop](https://user-images.githubusercontent.com/125716/117353857-48760480-ae76-11eb-9f81-023d26510db9.gif)
