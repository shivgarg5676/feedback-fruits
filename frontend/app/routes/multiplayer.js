import Ember from 'ember';

export default Ember.Route.extend({
  setupController:function(controller,model){
    this._super(controller, model)
    controller.set('gameState',[{},{},{},{},{},{},{},{},{}]);
    controller.set('showStartNewGame', true);
    controller.set('message', "");
    controller.set('gameId',null);
  },
  resetController: function(controller,isExisting, transition){
    this._super.apply(this, arguments);
    controller.set('message', "")
  },
  actions:{
    willTransition:function(transition){
      if (!this.get('controller.showStartNewGame')){
        let r = confirm("Are you sure you want to quit?");
        if (r == true) {
          this.get('controller').get('subscription').perform('leaveGame')
        } else {
          transition.abort()
        }
      }

    }
  }
});
