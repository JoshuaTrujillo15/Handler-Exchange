import React, { useState, useEffect } from 'react'
import chevron from '../../assets/chevron.svg'
import Wallet from './Wallet'
import QuickLinks from './QuickLinks'
import { ethers } from 'ethers'
import HandlerExchange from '../../artifacts/contracts/HandlerExchange.sol/HandlerExchange.json'
import { handlerExchangeAddress } from '../../constants/addresses'
import '../../styles/components/Sidebar.css'


const Sidebar = props => {
    const [contractActive, setContractActive] = useState(false)
    const [account, setAccount] = useState()
    const [gigArray, setGigArray] = useState()

    useEffect(() => {
        if (typeof account === 'undefined') {
            getAddress()
        } else if (typeof gigArray === 'undefined') {
            getGigs()
        }
    })

    const requestAccount = async () => {
        await window.ethereum.request({ method: 'eth_requestAccounts' })
        console.log('access granted')
    }

    const getAddress = async () => {
        if (typeof window.ethereum !== 'undefined') {
            await requestAccount()
            const provider = new ethers.providers.Web3Provider(window.ethereum)
            const signer = provider.getSigner()
            const address = signer.getAddress()
            setAccount(address)
        }
    }

    // Conditional classNames 
    const contractChevronClass = contractActive ? 'chevron active' : 'chevron'
    const contractListClass = contractActive ? 'sidebar-menu-content' : 'sidebar-menu-content collapsed'

    const getGigs = async () => {
        if (typeof window.ethereum !== 'undefined') {
            const provider = new ethers.providers.Web3Provider(window.ethereum)
            const contract = new ethers.Contract(handlerExchangeAddress, HandlerExchange.abi, provider)
            const data = await contract.getGigBatch()
            // const filtered = data.filter(gig => gig.client === account || gig.contractor === account || gig.handler === account)
            setGigArray(data)
        } else {
            alert('Functionality is limited without a web 3.0 provider')
        }
    }

    return (
        <div className='sidebar'>
            <div className='sidebar-menu'>
                <Wallet getAddress={props.getAddress} account={props.account}/>
            </div>
            <div className='sidebar-menu'>
                <QuickLinks/>
            </div>
            <div className='sidebar-menu'>
                <div className='sidebar-menu-header'>
                    <h3>Gigs</h3>
                    <img
                        onClick={() => setContractActive(!contractActive)}
                        src={chevron} alt='chevron'
                        className={contractChevronClass}
                    />
                </div>
                <div className={contractListClass}>
                    {
                        typeof gigArray !== 'undefined' ?
                        gigArray.map((gig, index) => {
                            return (
                                <div key={index} className='sidebar-menu-item'>
                                    <h4>Gig #{index}</h4>
                                    <p>{gig.price.toNumber()} HxT</p>
                                </div>
                            )
                        }) :
                        <div/>
                    }
                </div>
            </div>
        </div>
    )
}

export default Sidebar