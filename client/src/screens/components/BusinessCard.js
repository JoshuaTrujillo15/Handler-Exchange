import React, { useState } from 'react'
import Clipboard from '../../assets/clipboard.svg'

import '../../styles/components/BusinessCard.css'

const BusinessCard = (props) => {
    const [copiedToClipboard, setCopiedToClipboard] = useState('')

    const data = props.data

    const fullAddress = data.address
    const miniAddress = fullAddress.substring(0,24) + '...'

    const copyHandler = () => {
        navigator.clipboard.writeText(fullAddress)
        copiedMessageHandler()
    }

    const copiedMessageHandler = () => {
        setCopiedToClipboard('Copied!')
        setTimeout(() => setCopiedToClipboard(''), 5000)
    }

    return (
        <div className='business-card-container'>
            <div className='business-card'>
                <div className='business-card-name'>
                    <h2>{data.personalName}</h2>
                </div>
                <div className='business-card-group'>
                    <h3>{data.personalTitle}</h3>
                    <h3>at {data.businessName}</h3>
                    <p>{data.emailAddress}</p>
                </div>
                <div className='business-card-group address'>
                    <div
                        className='business-card-copy'
                        onClick={copyHandler}
                    >
                        <img src={Clipboard} alt='copy to clipboard' className='clipboard-mini' />
                    </div>
                    <h4 className='business-card-info'>{miniAddress}</h4>
                    <p className='business-card-copy-message'>{copiedToClipboard}</p>
                </div>
            </div>
        </div>
    )
}

export default BusinessCard