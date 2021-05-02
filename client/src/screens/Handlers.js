import React, { useState } from 'react'
import '../styles/Handlers.css'

const mockHandlers = [
    {
        name: 'sturdyfarrow',
        address: '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266',
        contractsHandled: 12,
        issues: 0,
        registeredSince: 'November 24, 2019'
    },
    {
        name: 'radiodiffer',
        address: '0x70997970C51812dc3A010C7d01b50e0d17dc79C8',
        contractsHandled: 3,
        issues: 0,
        registeredSince: 'January 3, 2020'
    },
    {
        name: 'utilitycard',
        address: '0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC',
        contractsHandled: 2,
        issues: 0,
        registeredSince: 'February 9, 2021'
    },
    {
        name: 'typemine',
        address: '0x90F79bf6EB2c4f870365E785982E1f101E93b906',
        contractsHandled: 100,
        issues: 3,
        registeredSince: 'December 4, 2018'
    }
]

const Handlers = () => {
    const [clipboard, setClipboard] = useState('')

    const copyHandler = (address) => {
        navigator.clipboard.writeText(address)
        setClipboard(address)
        setTimeout(() => setClipboard(''), 5000)
    }

    const handlerList = mockHandlers.map(handler => {

        const miniAddress = handler.address.substr(0,32) + '...'

        return (
            <div className='handlers-details' key={handler.address}>
                <h3 className='handlers-username'>{handler.name}</h3>
                <ul className='handlers-ul'>
                    <li className='handlers-li'>
                        Contracts Handled:
                        <br/>
                        <span className='handlers-highlight'>{handler.contractsHandled}</span>
                    </li>
                    <li className='handlers-li'>
                        Issues:
                        <br/>
                        <span className='handlers-highlight'>{handler.issues}</span>
                    </li>
                    <li className='handlers-li'>
                        Registered Since:
                        <br/>
                        <span className='handlers-highlight'>{handler.registeredSince}</span>
                    </li>
                    <li className='handlers-li'>
                        Escrow Address:
                        <br/>
                        <span className='handlers-highlight'>{miniAddress}</span>
                    </li>
                </ul>
                <button
                    className='button handlers-copier'
                    onClick={() => copyHandler(handler.address)}
                >{clipboard === handler.address ? 'Copied!': 'Copy to Clipboard'}</button>
            </div>
        )
    })


    return (
        <div className='handlers-container'>
            <div className='handlers'>
                <h2 className='handlers-title'>Handlers List</h2>
                {handlerList}
            </div>
        </div>
    )
}

export default Handlers