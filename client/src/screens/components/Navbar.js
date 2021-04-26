import React from 'react'
import { Link } from 'react-router-dom'
import Logo from '../../assets/logo.svg'
import Profile from '../../assets/profile.svg'
import Swap from '../../assets/swap.svg'

import '../../styles/components/Navbar.css'

const Navbar = () => {
    return (
        <header className='navbar'>
            <Link to='/' className='navbar-brand'>
                <img src={Logo} alt='logo' className='navbar-logo' />
                <h2>Handler X</h2>
            </Link>
            <ul className='navbar-ul'>
                <li>
                    <Link to='/handlers' className='navbar-link'>
                        <img src={Swap} alt='Handlers' className='navbar-icon' />
                        <p className='navbar-link-text'>Handlers</p>
                    </Link>
                </li>
                <li>
                    <Link to='/profile' className='navbar-link'>
                        <img src={Profile} alt='Profile' className='navbar-icon' />
                        Profile
                    </Link>
                </li>
            </ul>
        </header>
    )
}

export default Navbar