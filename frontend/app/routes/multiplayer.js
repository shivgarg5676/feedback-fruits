import Ember from 'ember';

export default Ember.Route.extend({

  cableService: Ember.inject.service('cable'),
  setupController:function(controller,model){
    this._super(controller, model)
    this.get('controller.subscription').perform('joinGame')
    controller.set('gameState',[{},{},{},{},{},{},{},{},{}])
  }
});
