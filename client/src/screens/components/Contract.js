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
                <p>I will {data.service}</p>
                <button
                    className='button'
                    onClick={() => history.push(`/contract/${data.id}`)}
                >See More!</button>
        </div>

    )
}

export default Contract