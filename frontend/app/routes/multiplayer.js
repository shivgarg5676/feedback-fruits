import Ember from 'ember';

export default Ember.Route.extend({
  model(){
    return this.store.query('game',{new: true});
  },

  setupController:function(controller,model){
    this._super(controller,model)
    let gameToPlay = model.filterBy('workflowState',"playing").get('firstObject')
    controller.set('gameToPlay', gameToPlay)
  }
});
