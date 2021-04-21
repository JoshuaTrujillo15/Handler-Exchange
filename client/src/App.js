import React from 'react'
import { BrowserRouter as Router, Route } from 'react-router-dom'
import { Web3ReactProvider } from '@web3-react/core'
import { Web3Provider } from '@ethersproject/providers'

import Navbar from './screens/components/Navbar'
import Footer from './screens/components/Footer'

import Market from './screens/Market'
import ContractDetails from './screens/ContractDetails'
import Profile from './screens/Profile'
import Sidebar from './screens/components/Sidebar'

const getLibrary = (provider) => {
    const library = new Web3Provider(provider)
    library.pollingInterval = 12000
    return library
}

function App() {
    return (
        <Web3ReactProvider getLibrary={getLibrary}>
            <Router>
                <div className='screen'>
                    <Navbar/>
                    <main>
                        <Sidebar/>
                        <Route path='/' exact component={Market} />
                        <Route path='/contract' exact component={ContractDetails} />
                        <Route path='/profile' exact component={Profile} />
                    </main>
                    <Footer/>
                </div>
            </Router>
        </Web3ReactProvider>
    )
}

export default App
