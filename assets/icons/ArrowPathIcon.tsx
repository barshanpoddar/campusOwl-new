import React from 'react';

const ArrowPathIcon: React.FC<React.SVGProps<SVGSVGElement>> = (props) => (
  <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" {...props}>
    <path strokeLinecap="round" strokeLinejoin="round" d="M16.023 9.348h4.992v-.001a10.5 10.5 0 01-1.066 5.193 10.5 10.5 0 01-8.485 5.193A10.5 10.5 0 013 10.5a10.5 10.5 0 0110.5-10.5c2.256 0 4.36.92 5.898 2.428l-2.298 2.298m7.492 0l-4.992 0m4.992 0v-4.992" />
  </svg>
);

export default ArrowPathIcon;
