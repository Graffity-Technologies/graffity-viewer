import { useEffect, useState } from 'react';

const deepLinkPrefix = "graffityviewer://ar/";
const fallbackUrl = "https://viewer.graffity.app/";

function getPlatform() {
    const userAgent = navigator.userAgent || navigator.vendor || (window as any).opera;

    if (/iPad|iPhone|iPod/.test(userAgent) && !(window as any).MSStream) {
        return 'ios';
    } else if (/android/i.test(userAgent)) {
        return 'android';
    } else if (/Mac/.test(userAgent)) {
        return 'mac';
    } else if (/Win/.test(userAgent)) {
        return 'windows';
    } else {
        return 'unknown';
    }
}

const NonAppLauncher = () => {
    const [platform, setPlatform] = useState('unknown');

    useEffect(() => {
        setPlatform(getPlatform());
    }, []);

    const path = window.location.pathname;
    const token = path.split("/")[2];
    const urlParams = new URLSearchParams(window.location.search);
    urlParams.set('token', token);

    // Construct various URL formats
    const webUrl = window.location.href;
    // const appClipUrl = defaultUrl + "&" + urlParams.toString();
    const deepLink = deepLinkPrefix + token + "?" + urlParams.toString();

    // Get appropriate link based on platform
    const getLinkForPlatform = () => {
        switch (platform) {
            case 'ios':
                // iOS uses custom URL scheme or universal links
                return deepLink;
            case 'android':
                // Android uses intent scheme
                return deepLink;
            default:
                // Fall back to web URL for desktop or unknown
                return webUrl;
        }
    };

    const handleClick = (e: React.MouseEvent<HTMLAnchorElement>) => {
        e.preventDefault();

        const link = getLinkForPlatform();

        // Try to open the app first
        window.location.href = link;

        // Set a timeout to redirect to app store if the app isn't installed
        const timeout = setTimeout(() => {
            if (platform === 'ios' || platform === 'mac') {
                window.location.href = 'https://apps.apple.com/th/app/graffity-viewer/id6451207164';
            } else if (platform === 'android') {
                window.location.href = 'https://play.google.com/store/apps/details?id=com.graffity.ar_viewer';
            } else {
                // For desktop or unknown, just use the web experience
                window.location.href = fallbackUrl;
            }
        }, 2000); // 2 second delay

        // Clear the timeout if the page is hidden (app opened successfully)
        document.addEventListener('visibilitychange', function () {
            if (document.hidden) {
                clearTimeout(timeout);
            }
        });
    };

    return <div>
        <p>or</p>
        <div style={{ marginTop: "25px" }}>
            <a href="#" onClick={handleClick} className="btn-app-clip">Launch AR Experience</a>
        </div>
    </div>
}

export { NonAppLauncher }
