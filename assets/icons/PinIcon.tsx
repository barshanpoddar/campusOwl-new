import React from 'react';

const PinIcon: React.FC<React.SVGProps<SVGSVGElement>> = (props) => (
  <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" {...props}>
    <path strokeLinecap="round" strokeLinejoin="round" d="M17.593 3.322c.1.128.2.27.2.428V21l-5.786-4.286L6.214 21V3.75c0-.158.1-.3.2-.428.321-.408.82-.644 1.343-.644h8.486c.522 0 1.022.236 1.343.644z" />
  </svg>
);

export default PinIcon;
