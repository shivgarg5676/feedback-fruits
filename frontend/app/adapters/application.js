import DS from 'ember-data';

export default DS.JSONAPIAdapter.extend({
  namespace: 'api/v1',
  pathForType:function(type){
    type = Ember.String.underscore(type);
    type = Ember.String.pluralize(type);
    return type
  }

});
