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
            <div
                className='business-card'
                style={{
                    backgroundColor: data.primary,
                    color: data.text
                }}
            >
                <div
                    className='business-card-name'
                    style={{borderBottom: `4px solid ${data.secondary}`}}
                >
                    <h2>{data.personalName}</h2>
                </div>
                <div className='business-card-group'>
                    <h3>{data.personalTitle}</h3>
                    <p>{data.emailAddress}</p>
                </div>
                <div className='business-card-group address'>
                    <div
                        className='business-card-copy'
                        onClick={copyHandler}
                    >
                        <img src={Clipboard} alt='copy to clipboard' className='clipboard-mini' />
                    </div>
                    <h4
                        className='business-card-info'
                        style={{textDecoration: `underline solid ${data.secondary}} 2px`}}
                    >{miniAddress}</h4>
                    <p className='business-card-copy-message'>{copiedToClipboard}</p>
                </div>
            </div>
        </div>
    )
}

export default BusinessCard