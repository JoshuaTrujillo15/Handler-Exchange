import React from 'react'
import BusinessCard from './BusinessCard'
import { useHistory } from 'react-router-dom'

import '../../styles/components/Contract.css'

const Contract = (props) => {
    const data = props.data
    const history = useHistory()

    return (
        <div className='contract'>
            <BusinessCard data={data} />
            <div className='contract-info'>
                <p>I will {data.service}</p>
                <p>Starting at {data.price} {data.priceDenomination}</p>
                <p>ID - {data.id}</p>
                <button
                    className='button'
                    onClick={() => history.push(`/contract/${data.id}`)}
                >Hire Me!</button>
            </div>
        </div>

    )
}

export default Contract