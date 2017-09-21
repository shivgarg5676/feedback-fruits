import Ember from "ember";
import ajax from "frontend/helpers/ajax";
import constants from "frontend/utils/constants";
let mixin = Ember.Mixin.create({
  session: Ember.inject.service(),
  getLoggedInUser:function(){
    let self = this;
    let hash= {
      success:function(data){
        if(data.message == "No User Logged in"){
          if(typeof(self.transitionTo) == 'function'){
              self.transitionTo('login')
          }
          else{
            self.transitionToRoute('login')
          }
        }
        else{
          self.store.pushPayload('user', data)
          self.set('session.currentUser',self.store.peekRecord('user', data.data.id))
          if(typeof(self.transitionTo) == 'function'){
              self.transitionTo('/')
          }
          else{
            self.transitionToRoute('/')
          }
        }

      }
    }
    return ajax(constants.LOGGED_IN_USER_URL ,'GET', hash, this)
  }
})

export default mixin;
