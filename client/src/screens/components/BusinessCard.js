import React from 'react'
import Logo from '../../assets/logo.svg'

import '../../styles/components/BusinessCard.css'

const BusinessCard = (props) => {
    const data = props.data

    return (
        <div className='business-card-container'>
            <div className='business-card'>
                <div className='business-card-name'>
                    <h2>{data.personalName}</h2>
                    <img src={Logo} alt='logo' className='business-card-logo' />
                </div>
                <div className='business-card-group'>
                    <h3>{data.personalTitle}</h3>
                    <h3>at {data.businessName}</h3>
                </div>
                <div className='business-card-group'>
                    <h4><span className='business-card-info'>{data.address}</span></h4>
                </div>
            </div>
        </div>
    )
}

export default BusinessCard