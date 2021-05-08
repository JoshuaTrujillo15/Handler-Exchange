import React, { useEffect, useState } from 'react'
import Contract from './components/Contract'
import { ethers } from 'ethers'
import HandlerExchange from '../artifacts/contracts/HandlerExchange.sol/HandlerExchange.json'
import { handlerExchangeAddress } from '../constants/addresses'
import '../styles/Market.css'

const Market = () => {
    const [offerArray, setOfferArray] = useState()

    useEffect(() => {
        if (typeof offerArray === 'undefined') {
            getOffers()
        }
    })

    const getOffers = async () => {
        if (typeof window.ethereum !== 'undefined') {
            const provider = new ethers.providers.Web3Provider(window.ethereum)
            const contract = new ethers.Contract(handlerExchangeAddress, HandlerExchange.abi, provider)
            try {
                const offers = await contract.getOfferBatch()
                setOfferArray(offers.map((offer, index) => {
                    const data = {
                        id: index,
                        address: offer.contractor,
                        personalName: offer.personalName,
                        personalTitle: offer.personalTitle,
                        service: offer.service,
                        emailAddress: offer.emailAddress,
                        primary: offer.primaryColor.replace('0x', '#'),
                        secondary: offer.secondaryColor.replace('0x', '#'),
                        text: '#fff'
                    }
                    return data
                }).reverse())
            } catch (err) {
                console.log(err)
            }
        }
    }

    return (
        <div className='market'>
            <header className='market-header'>
                <h1>Handler X Marketplace</h1>
                <h3>Powered by <a className='link' href='https://offchainlabs.com/'>Arbitrum</a>!</h3>
            </header>
            <div className='market-contract-list'>
                {
                    typeof offerArray !== 'undefined' ?
                    offerArray.map(offer => <Contract key={offer.id} data={offer} />) :
                    <div/>
                }
            </div>
        </div>
    )
}

export default Market