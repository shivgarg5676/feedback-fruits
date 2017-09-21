import Ember from "ember";
let route = Ember.Route.extend({
  model(){
    return this.store.findAll('user')
  }
});
export default route;
