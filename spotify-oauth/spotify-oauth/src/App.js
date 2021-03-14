import './App.css';
import { Login } from './login/Login';
import { useState } from 'react';
import {Register} from './login/Register'
import "bootstrap/dist/css/bootstrap.min.css";

function App() {

  let loginInfo = useState({loggedIn: false});

  return (
    <div className="App">
      <header className="App-header">Header</header>
      {!loginInfo.loggedIn && <Register></Register>}
    </div>
  );
}

export default App;
