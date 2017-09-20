import Ember from "ember";
let controller = Ember.Controller.extend({
  actions:{
    toggle:function(elem){
      this.set(elem, !this.get(elem))
    },
    playMultiplayer:function(){
      this.transitionToRoute('multiplayer')
    }
  }
})
export default controller;
