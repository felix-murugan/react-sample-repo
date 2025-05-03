import './App.css'; // CSS for the App component
import Carts from './Component/State/Carts'; // Import the Carts component
import Useref from './Component/State/Useref'; // Import the Useref component
import Useeffect from './Component/State/Useeffect'; // Import the Useeffect component

function App() {
  return (
    <div>
      {/* Uncomment the components below to use them */}
      {/* <Carts /> */}
      {/* <Useeffect /> */}
      <Useref /> {/* This component is currently being used */}
    </div>
  );
}

export default App;
