import React, { useState } from 'react'
import { BrowserRouter as Router, Route } from 'react-router-dom'

import Navbar from './screens/components/Navbar'
import Footer from './screens/components/Footer'

import Market from './screens/Market'
import ContractDetails from './screens/ContractDetails'
import Profile from './screens/Profile'
import Sidebar from './screens/components/Sidebar'
import Handlers from './screens/Handlers'
import NewGig from './screens/components/NewGig'
import NewOffer from './screens/components/NewOffer'
import NewHandler from './screens/components/NewHandler'

import { ethers } from 'ethers'

function App() {
    const [account, setAccount] = useState('')

    const requestAccount = async () => {
        await window.ethereum.request({ method: 'eth_requestAccounts' })
        console.log('access granted')
    }

    const getAddress = async () => {
        if (typeof window.ethereum !== 'undefined') {
            await requestAccount()
            const provider = new ethers.providers.Web3Provider(window.ethereum)
            const signer = provider.getSigner()
            const address = await signer.getAddress()
            setAccount(address)
        } else {
            alert('You need a web 3.0 provider to perform this action')
        }
    }

    return (
        <Router>
            <div className='screen'>
                <Navbar/>
                <main>
                    <Sidebar getAddress={getAddress} account={account}/>
                    <Route path='/' exact component={Market} />
                    <Route path='/contract/:id' exact component={ContractDetails} />
                    <Route path='/profile' exact component={Profile} />
                    <Route path='/handlers' exact component={Handlers} />
                    <Route path='/new/gig' exact component={NewGig} />
                    <Route path='/new/offer' exact component={NewOffer} />
                    <Route path='/new/handler' exact component={NewHandler} />
                </main>
                <Footer/>
            </div>
        </Router>
    )
}

export default App
