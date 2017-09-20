import Ember from 'ember';

export function border(params) {
  let index = params[0];
  let classNames = params.slice(1)[0]
  if((index % 3) < 2 ){
    classNames = classNames + " border-right"
  }
  if(index<6){
    classNames = classNames + " border-bottom"
  }
  return classNames;
}

export default Ember.Helper.helper(border);
