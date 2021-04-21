import React, { useState } from 'react'
import chevron from '../../assets/chevron.svg'
import Wallet from './Wallet'
import '../../styles/components/Sidebar.css'

const Sidebar = () => {
    const [contractActive, setContractActive] = useState(false)

    // Conditional classNames 
    const contractChevronClass = contractActive ? 'chevron active' : 'chevron'
    const contractListClass = contractActive ? 'sidebar-menu-content' : 'sidebar-menu-content collapsed'

    return (
        <div className='sidebar'>
            <div className='sidebar-menu'>
                <Wallet/>
            </div>
            <div className='sidebar-menu'>
                <div className='sidebar-menu-header'>
                    <h3>Active Contracts</h3>
                    <img
                        onClick={() => setContractActive(!contractActive)}
                        src={chevron} alt='chevron'
                        className={contractChevronClass}
                    />
                </div>
                <div className={contractListClass}>
                    <div className='sidebar-menu-item'>
                        <h4>Byte Speak</h4>
                        <p>5 ETH</p>
                    </div>
                    <div className='sidebar-menu-item'>
                        <h4>Handler X</h4>
                        <p>2 ETH</p>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default Sidebar