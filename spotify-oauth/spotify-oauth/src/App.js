import './App.css';
import { Tracks } from './tracks/Tracks';
import { useState, useEffect } from 'react';
import {Register} from './login/Register'
import "bootstrap/dist/css/bootstrap.min.css";
import * as $ from "jquery";

// Get the hash of the url
const hash = window.location.hash
  .substring(1)
  .split("&")
  .reduce(function (initial, item) {
    if (item) {
      var parts = item.split("=");
      initial[parts[0]] = decodeURIComponent(parts[1]);
    }
    return initial;
  }, {});
window.location.hash = "";

function App() {
  let _token = hash.access_token;
  const [state, setState] = useState({ loggedIn: false, token:false, tracks: false });
  useEffect(() => {
    if (_token) {
      setState({ loggedIn: false, token: _token, tracks: false });
    }
  }, [_token]);

  function getTopTracks() {
    // Make a call using the token
    $.ajax({
      url: "https://api.spotify.com/v1/me/top/tracks?limit=10",
      type: "GET",
      beforeSend: (xhr) => {
        xhr.setRequestHeader("Authorization", "Bearer " + state.token);
      },
      success: (data) => {
        setState({
          loggedIn: true,
          token: state.token,
          tracks: data
        });
      },
    });
  }

  let body = (<Register spotify={state.token} submit={getTopTracks}></Register>);
  if (state.tracks){
    body = (<p>{JSON.stringify(state.tracks.items)}</p>)
    body = (<Tracks tracks={state.tracks.items} />)
  }
  return (
    <div className="App">
      <header className="App-header">Melody Matches</header>
      {body}
    </div>
  );
}

export default App;
