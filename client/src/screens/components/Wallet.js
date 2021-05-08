import React from 'react'

import '../../styles/components/Wallet.css'

const Wallet = props => {
    const account = props.account
    const getAddress = props.getAddress

    const status = account === '' ? '🔴 Not Connected' : '🟢 Connected'
    let miniAddress = ''

    if (account !== '') {
        miniAddress = account.substring(0, 24) + '...'
    }

    return (
        <div className='wallet-container'>
            <div className='wallet'>
                <h3>Wallet</h3>
                <div>
                    <p>Status:</p>
                    <p>{status}</p>
                </div>
                <div>
                    <p>Address:</p>
                    <p>{miniAddress}</p>
                </div>
                <button
                    className={account ? 'button disabled' : 'button'}
                    disabled={account ? true : false}
                    onClick={getAddress}
                >{account ? 'Wallet Connected!' : 'Connect Wallet'}</button>
            </div>

        </div>
    )
}

export default Wallet