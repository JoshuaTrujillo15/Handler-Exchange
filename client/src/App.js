import React, { useState } from 'react'
import { BrowserRouter as Router, Route } from 'react-router-dom'

import Navbar from './screens/components/Navbar'
import Footer from './screens/components/Footer'

import Market from './screens/Market'
import ContractDetails from './screens/ContractDetails'
import Profile from './screens/Profile'
import Sidebar from './screens/components/Sidebar'
import Handlers from './screens/Handlers'

// import EthersTest from './screens/EthersTest'
// import TimeToken from './screens/TimeToken'



function App() {

    const [address, setAddress] = useState('')

    return (
        <Router>
            <div className='screen'>
                <Navbar/>
                <main>
                    <Sidebar/>
                    <Route path='/' exact component={Market} />
                    <Route path='/contract/:id' exact component={ContractDetails} />
                    <Route path='/profile' exact component={Profile} />
                    <Route path='/handlers' exact component={Handlers} />
                </main>
                <Footer/>
            </div>
        </Router>
    )
}

export default App
