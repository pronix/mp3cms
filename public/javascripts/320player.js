
var player320;

player320 = (function() {
    //
    function player320(opt) {
      this.options = opt;
      this.tracks  = opt["tracks"];
      this.current = null;
      var tracks   = opt["tracks"];

      soundManager.useFlashBlock = false;
      soundManager.url = '/flash/';
      soundManager.debugMode = opt["debug"] || false;
      soundManager.consoleOnly = true;
      soundManager.onready(function(oStatus) {

          if (!oStatus.success) {  return false;       }
          var track, _fn, _i, _len;
          _fn = function(track,i) {
            if (!soundManager.getSoundById("s"+track.id+"")){
              soundManager.createSound({
                  id: "s"+track.id+"",
                  url: "/admin/listen_track/"+track.id
                });
            }
          };
          for (_i = 0, _len = tracks.length; _i < _len; _i++) {
            track = tracks[_i].track;
            _fn(track, _i);
          }
        });

    }


    /* играем */
    player320.prototype.play = function(track_id) {
      this.set_current(track_id)
      soundManager.stopAll();
      return soundManager.play(track_id)
    };

    /* остановили */
    player320.prototype.stop = function(track_id) {
      return soundManager.stopAll();
    };

    /* текущий трек */
    player320.prototype.current = function() {
      return this.current;
    };

    player320.prototype.set_current = function(track_id) {
      for (_i = 0, _len = this.tracks.length; _i < _len; _i++) {
        if (("s"+this.tracks[_i].track.id) == track_id) {
         this.current = this.tracks[_i].track
        }
      }
      return this.current;
    };


    return player320;

})();