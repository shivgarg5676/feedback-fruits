import DS from 'ember-data';

export default DS.JSONAPIAdapter.extend({
  namespace: 'api/v1',
  pathForType:function(type){
    return type.underscore().pluralize()
  }

});
