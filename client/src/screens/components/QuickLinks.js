import React from 'react'
import { useHistory } from 'react-router-dom'
import '../../styles/components/QuickLinks.css'

const QuickLinks = () => {
    const history = useHistory()

    return (
        <div className='wallet-container'>
            <div className='wallet'>
                <h3>Quick Actions</h3>
                <button onClick={() => history.push('/new/handler/')} className='button secondary'>New Handler</button>
                <button onClick={() => history.push('/new/gig/')} className='button secondary'>New Gig</button>
                <button onClick={() => history.push('/new/offer/')} className='button secondary'>New Offer</button>
            </div>
        </div>
    )
}

export default QuickLinks