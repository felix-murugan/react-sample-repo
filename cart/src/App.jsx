import './App.css'; // Import CSS for styling
import Carts from './Component/State/Carts'; // Import Carts component
import Useref from './Component/State/Useref'; // Import Useref component
import Useeffect from './Component/State/Useeffect'; // Import Useeffect component

function App() {
  return (
    <div>
      {/* Uncomment these components to use them */}
      {/* <Carts /> */}
      {/* <Useeffect /> */}
      <Useref /> {/* This component is being used */}
    </div>
  );
}

export default App;
