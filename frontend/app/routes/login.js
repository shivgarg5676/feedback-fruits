import Ember from 'ember';

export default Ember.Route.extend({
  session: Ember.inject.service(),
  beforeModel:function(){
    if(this.get('session.currentUser')){
      this.transitionTo('/')
    }
  },
 actions:{
   willTransition:function(transition){
     if(!this.get('session.currentUser')){
      transition.abort()
     }
   },
   login(){

   }
 }

});
