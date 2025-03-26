import React from 'react';
import './App.css';

import AppStoreImage from './images/App Store.png';
import GooglePlayImage from './images/Google Play.png';
import ViewerLogo from './images/graffity_viewer_logo.png';
import { AppClipLauncher } from './components/AppClipLauncher';

function App() {
  const appStoreURL = 'https://apps.apple.com/th/app/graffity-viewer/id6451207164';
  const googlePlayURL = 'https://play.google.com/store/apps/details?id=com.graffity.ar_viewer';

  return (
    <div className="App">
      <div className='app-container'>
        <img
          src={ViewerLogo}
          alt="Viewer Logo"
          width={230}
        />
        <br /><br /><br /><br />
        <p>App is not installed on your device? <br />Download it from App Store or Google Play.</p>
        <br />
        <div className='btn-container'>
          <a className='btn-app-store' href={appStoreURL} target="_blank" rel="noopener noreferrer">
            <img
              src={AppStoreImage}
              alt="Download on the App Store"
              width={150}
            />
          </a>
          <a href={googlePlayURL} target="_blank" rel="noopener noreferrer">
            <img
              src={GooglePlayImage}
              alt="Get it on Google Play"
              width={150}
            />
          </a>
        </div>
        <AppClipLauncher />
      </div>
    </div>
  );
}

export default App;