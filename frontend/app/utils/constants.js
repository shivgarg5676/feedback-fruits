let constants = {
  namespace: '/api/v1',
  host: '/'
}
constants.LOGGED_IN_USER_URL = constants.namespace + "/users/logged_in"
constants.SIGN_IN_URL =  constants.namespace + "/users/sign_in"
constants.SIGN_OUT_URL = constants.namespace + '/auth/sign_out'
export default constants;
