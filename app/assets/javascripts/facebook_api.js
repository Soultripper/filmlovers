var FacebookAPI = {

  loggedIn: false,
  friendsQuery: "SELECT uid,username FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) AND is_app_user = 1",

  init: function(){
    // $(document).on('facebook:connected', function(){
    //   ViewModel.loadFriends()
    // })
  },

    // logged_in: function(){
    //   ViewModel.user.loggedIn(true)
    //   ViewModel.user.loggedOut(false)
    // },

    // logged_out: function(){
    //   ViewModel.user.loggedIn(false)
    //   ViewModel.user.loggedOut(true)
    // },

  login: function(){

    FB.login(function(response) 
    {
        if (response.authResponse) 
        {
          FacebookAPI.logged_in()
        } 
        else 
        {
          FacebookAPI.logged_out()
          console.log('User cancelled login or did not fully authorize.');
        }
    })
  },

  logout: function(){
    FB.logout(function(response) 
    {
      FacebookAPI.logged_out()
      console.log('User is now logged out');
    })
  },

  friends: function(callback){
    FacebookAPI.fql(FacebookAPI.friendsQuery, callback)
    // FB.api('/me/friends?fields=id,name,installed', callback );
  },

  fql: function(querystring, callback){
    FB.api({method:'fql.query', query:querystring}, callback)
  },

  watchFilm: function postLike() {
    FB.api(
      'me/video.watches',
      'post',
      {
        movie: "http://45j3.localtunnel.com/films/ted-2012"
      },
      function(response) {
        console.log(response)
      }
    );
  },

  openInviteDialog: function(){
    FB.ui({method: 'apprequests',
            message: 'Please join me at filmlovr.com, so we can recommend films to each other and more!',
            filters: ['app_non_users'],
            max_recipients: 50
        }, FacebookAPI.requestCallback);
  },

  requestCallback: function(response){

  }

}
