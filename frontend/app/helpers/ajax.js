import Ember from 'ember'

//define all library methods here that will be used throughout the application
let helper = function(url, type, hash, context){
  if(type.toLowerCase() != 'get' && hash.data != null){
    hash.data = JSON.stringify(hash.data)
  }
  hash.url = url + ".json";
  hash.type = type;
  hash.dataType = 'json';
  hash.contentType = 'application/json; charset=utf-8';
  hash.context = context || this;
  return $.ajax(hash)
}


export default helper
