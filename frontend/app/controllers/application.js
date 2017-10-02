import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service(),
  actions:{
    toggle:function(elem){
      this.set(elem, this.toggleProperty(elem))
    },
  }
});
