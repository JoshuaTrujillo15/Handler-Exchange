import React from 'react'
import Contract from './components/Contract'

import '../styles/Market.css'

const mockData = {
    id: '0x12345678',
    personalName: 'Joshua Trujillo',
    personalTitle: 'Lead Designer',
    businessName: 'Byte-Speak',
    emailAddress: 'example@example.com',
    address: '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266',
    price: 1,
    priceDenomination: 'ETH',
    service: 'Build a React Web Application'
}

const Market = () => {
    return (
        <div className='market'>
            <header className='market-header'>
                <h1>Handler X Marketplace</h1>
                <h3>Powered by Ethereum 2.0!</h3>
            </header>
            <div className='market-contract-list'>
                <Contract data={mockData}/>
                <Contract data={mockData}/>
                <Contract data={mockData}/>
                <Contract data={mockData}/>
            </div>
        </div>
    )
}

export default Market