import React, { useState } from 'react'

import '../../styles/components/Wallet.css'

const Wallet = () => {
    const [active, setActive] = useState(false)

    return (
        <div className='wallet-container'>
            <div className='wallet'>
                <div>
                    <p>Status: </p>
                    <p>{active ? 'Connected 🟢' : 'Not Connected 🔴'}</p>
                </div>
                <button
                    className={active ? 'button disabled' : 'button'}
                    disabled={active}
                    onClick={() => setActive(true)}
                >{active ? 'Wallet Connected!' : 'Connect Wallet'}</button>
            </div>

        </div>
    )
}

export default Wallet