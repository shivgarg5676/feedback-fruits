import Ember from 'ember';

export default Ember.Route.extend({
  session: Ember.inject.service(),
  beforeModel:function(){
    if(this.get('session.currentUser')){
      this.transitionTo('/')
    }
  },
  setupController:function(controller,model){
    this._super(controller,model)
    controller.set('showLogin',true)
  },
 actions:{
   willTransition:function(transition){
     if(!this.get('session.currentUser')){
      transition.abort()
     }
   }
 }

});
