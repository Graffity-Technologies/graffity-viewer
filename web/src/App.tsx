import React, { useEffect, useState } from 'react';
import './App.css';

import AppStoreImage from './images/App Store.png';
import GooglePlayImage from './images/Google Play.png';
import ViewerLogo from './images/graffity_viewer_logo.png';
import { NonAppLauncher } from './components/NonAppLauncher';

function App() {
  const appStoreURL = 'https://apps.apple.com/th/app/graffity-viewer/id6451207164';
  const googlePlayURL = 'https://play.google.com/store/apps/details?id=com.graffity.ar_viewer';
  const [platform, setPlatform] = useState('unknown');

  useEffect(() => {
    // Detect the user's platform
    const userAgent = navigator.userAgent || navigator.vendor || (window as any).opera;

    if (/iPad|iPhone|iPod/.test(userAgent) && !(window as any).MSStream) {
      setPlatform('ios');
    } else if (/android/i.test(userAgent)) {
      setPlatform('android');
    } else if (/Mac/.test(userAgent)) {
      setPlatform('mac'); // macOS devices
    } else if (/Win/.test(userAgent)) {
      setPlatform('windows'); // Windows devices
    } else {
      setPlatform('unknown');
    }
  }, []);

  const renderDownloadText = () => {
    if (platform === 'ios' || platform === 'mac') {
      return "Use our App for the best experience. Download it from the App Store.";
    } else if (platform === 'android') {
      return "Use our App for the best experience. Download it from Google Play.";
    } else {
      return "Use our App for the best experience. Download it from App Store or Google Play.";
    }
  };

  return (
    <div className="App">
      <div className='app-container'>
        <img
          src={ViewerLogo}
          alt="Viewer Logo"
          width={230}
        />
        <br /><br /><br /><br />
        <p>{renderDownloadText()}</p>
        <br />
        <div className='btn-container'>
          {(platform === 'ios' || platform === 'mac' || platform === 'unknown') && (
            <a className='btn-app-store' href={appStoreURL} target="_blank" rel="noopener noreferrer">
              <img
                src={AppStoreImage}
                alt="Download on the App Store"
                width={150}
              />
            </a>
          )}
          {(platform === 'android' || platform === 'windows' || platform === 'unknown') && (
            <a href={googlePlayURL} target="_blank" rel="noopener noreferrer">
              <img
                src={GooglePlayImage}
                alt="Get it on Google Play"
                width={150}
              />
            </a>
          )}
        </div>
        <NonAppLauncher />
      </div>
    </div>
  );
}

export default App;