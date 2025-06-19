import React from 'react';
import { Link } from 'react-router-dom';

const Header = () => {
  return (
    <header className="header">
      <nav>
      <ul style={{ display: 'flex', listStyle: 'none', gap: '2rem' }}>
          <li><Link to="/" style={{ fontSize: '25px', color: 'white', padding: '10px' }}>Home</Link></li>
          <li><Link to="/about" style={{ fontSize: '25px', color: 'white' }}>About</Link></li>
        </ul>
      </nav>
    </header>
  );
};

export default Header;