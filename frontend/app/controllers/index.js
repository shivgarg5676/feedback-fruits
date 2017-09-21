import Ember from "ember";
let controller = Ember.Controller.extend({
  actions:{
    playMultiplayer:function(){
      this.transitionToRoute('multiplayer')
    }
  }
})
export default controller;
