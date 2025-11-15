import React from 'react';

const OwlIcon: React.FC<React.SVGProps<SVGSVGElement>> = (props) => (
  <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" {...props}>
    <path strokeLinecap="round" strokeLinejoin="round" d="M21 7.5l-2.25-1.313M21 7.5v2.25m0-2.25l-2.25 1.313M3 7.5l2.25-1.313M3 7.5l2.25 1.313M3 7.5v2.25m9 3l2.25-1.313M12 12.75l-2.25-1.313M12 12.75V15m0 6.75l-2.25-1.313M12 21.75V19.5m0 2.25l2.25-1.313m0-16.875L12 2.25l-2.25 1.313M12 2.25l2.25 1.313m-4.5 0L12 2.25" />
    <path strokeLinecap="round" strokeLinejoin="round" d="M12 2.25c-5.186 0-9.44 3.04-9.44 6.75s4.254 6.75 9.44 6.75 9.44-3.04 9.44-6.75S17.186 2.25 12 2.25z" />
    <path strokeLinecap="round" strokeLinejoin="round" d="M9 9.75a.75.75 0 01.75-.75h4.5a.75.75 0 01.75.75v3a.75.75 0 01-.75.75h-4.5a.75.75 0 01-.75-.75v-3z" />
  </svg>
);

export default OwlIcon;