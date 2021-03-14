import './App.css';
import { Login } from './login/Login';
import { useState } from 'react';

function App() {

  let loginInfo = useState({loggedIn: false});

  return (
    <div className="App">
      <header className="App-header">Header</header>
      {!loginInfo.loggedIn && <Login></Login>}
    </div>
  );
}

export default App;
