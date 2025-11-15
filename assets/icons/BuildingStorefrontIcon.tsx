import React from 'react';

// Icon representing a coffee mug, as requested.
const BuildingStorefrontIcon: React.FC<React.SVGProps<SVGSVGElement>> = (props) => (
  <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" {...props}>
    <path strokeLinecap="round" strokeLinejoin="round" d="M18 8h1a4 4 0 0 1 0 8h-1" />
    <path strokeLinecap="round" strokeLinejoin="round" d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z" />
    <path strokeLinecap="round" strokeLinejoin="round" d="M6 1v3m4-3v3m4-3v3" />
  </svg>
);

export default BuildingStorefrontIcon;
