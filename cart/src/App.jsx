import { useState } from 'react'
import './App.css'
import Carts from './Component/State/Carts'
import Useref from './Component/State/Useref'
import Useeffect from './Component/State/Useeffect'

function App() {
  const [count, setCount] = useState(0)

  return (
    <div>
     { /*<Carts/>}
     {<Useeffect/>*/}
     {<Useref/>}
    </div>
  )
}

export default App
