import React from 'react'
import BusinessCard from './BusinessCard'

import '../../styles/components/Contract.css'

/*const mockData = {
    personalName: 'Joshua Trujillo',
    personaltitle: 'Lead Designer',
    businessName: 'Byte-Speak',
    phoneNumber: '555 555 5555',
    address: '42 Ethereum Avenue',
    price: 1,
    priceDenomination: 'ETH',
    service: 'Build a React Web Application!'
}
*/

const Contract = (props) => {
    const data = props.data
    return (
        <div className='contract'>
            <BusinessCard data={data} />
            <div className='contract-details'>
                <p>I will {data.service}</p>
                <p>Starting at {data.price} {data.priceDenomination}</p>
                <button
                    className='button'
                    onClick={() => console.log('click')}
                >Hire Me!</button>
            </div>
        </div>

    )
}

export default Contract