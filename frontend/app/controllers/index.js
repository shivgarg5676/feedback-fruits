import Ember from "ember";
let controller = Ember.Controller.extend({

  playerSorting: ['gamesWon:desc'],
  sortedPlayers: Ember.computed.sort('model', 'playerSorting'),
  actions:{
    playMultiplayer:function(){
      this.transitionToRoute('multiplayer')
    }
  }
})
export default controller;
