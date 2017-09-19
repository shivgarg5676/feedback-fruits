import Ember from "ember";
let controller = Ember.Controller.extend({
  actions:{
    toggle:function(elem){
      this.set(elem, !this.get(elem))
    }
  }
})
export default controller;
