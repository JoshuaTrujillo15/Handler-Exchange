import React from 'react'
import BusinessCard from './components/BusinessCard'
// import { useParams } from 'react-router-dom'

import '../styles/ContractDetails.css'

const mockData = {
    address: '0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266',
    id: '0xe7f1725e7734ce288f8367e1bb143e90bb3f0512',
    personalName: 'Joshua Trujillo',
    personalTitle: 'Lead Designer',
    businessName: 'Byte-Speak',
    emailAddress: 'example@example.com',
    price: 1000,
    priceDenomination: 'GWEI',
    service: 'Build a React Web Application!'
}

const ContractDetails = () => {
    // const { id } = useParams()
    return (
        <div className='contract-details-container'>
            <div className='contract-details'>
                <div className='contract-details-header'>
                    <h2>Offer Details</h2>
                </div>

                <BusinessCard data={mockData} />

                <h3 className='contract-details-subheader'>Pricing Data</h3>
                <div className='contract-details-group'>
                    <h4>Service:</h4>
                    <p>I will {mockData.service}</p>
                </div>
                <div className='contract-details-group'>
                    <h4>Pricing:</h4>
                    <p>{mockData.price} - {mockData.priceDenomination}</p>
                </div>

                <h3 className='contract-details-subheader'>Personal Info</h3>
                <div className='contract-details-group'>
                    <h4>Name:</h4>
                    <p>{mockData.personalName}</p>
                </div>
                <div className='contract-details-group'>
                    <h4>Title:</h4>
                    <p>{mockData.personalTitle} at {mockData.businessName}</p>
                </div>
                <div className='contract-details-group'>
                    <h4>Email:</h4>
                    <p>{mockData.emailAddress}</p>
                </div>

                <h3 className='contract-details-subheader'>Blockchain Data</h3>
                <div className='contract-details-group'>
                    <h4>Contract ID:</h4>
                    <p>{mockData.id}</p>
                </div>
                <div className='contract-details-group'>
                    <h4>Contractor Address:</h4>
                    <p>{mockData.address}</p>
                </div>
                <div className='contract-details-group'>
                    <button className='button'>Open Contract</button>
                </div>
            </div>
        </div>
    )
}

export default ContractDetails