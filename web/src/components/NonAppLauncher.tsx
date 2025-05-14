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
                // For iOS, we'll use the custom URL scheme directly
                // This has better success in browser contexts than Universal Links
                return `graffityviewer://ar/${token}?${urlParams.toString()}`;
            case 'android':
                // Android uses intent scheme with fallback
                const encodedDeepLink = encodeURIComponent(`https://viewer.graffity.app/ar/${token}`);
                return `intent://viewer.graffity.app/ar/${token}?${urlParams.toString()}#Intent;scheme=https;package=com.graffity.ar_viewer;S.browser_fallback_url=${encodeURIComponent(fallbackUrl)};end`;
            default:
                // Fall back to web URL for desktop or unknown
                return webUrl;
        }
    };

    const handleClick = (e: React.MouseEvent<HTMLAnchorElement>) => {
        e.preventDefault();

        const link = getLinkForPlatform();
        let hasRedirected = false;

        // For iOS, we need special handling for Universal Links
        if (platform === 'ios') {
            // Create an iframe for handling Universal Links without navigating away
            const iframe = document.createElement('iframe');
            iframe.style.display = 'none';
            document.body.appendChild(iframe);

            // Set a timeout to redirect to App Store if app isn't installed
            const timeout = setTimeout(() => {
                if (!hasRedirected) {
                    hasRedirected = true;
                    window.location.href = 'https://apps.apple.com/th/app/graffity-viewer/id6451207164';
                }
            }, 2000);

            // Try to use the Universal Link in iframe
            iframe.src = link;

            // Clean up the iframe after a short delay
            setTimeout(() => {
                document.body.removeChild(iframe);
            }, 100);
        } else {
            // For Android and other platforms
            window.location.href = link;

            // Set a timeout to redirect to app store if the app isn't installed
            const timeout = setTimeout(() => {
                if (platform === 'android') {
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
        }
    };

    return <div>
        <p>After Installed</p>
        <div style={{ marginTop: "25px" }}>
            {platform === 'ios' ? (
                <p className="ios-open-instruction">
                    Please tap the <strong>"Open"</strong> button at the top right corner to launch the app.
                </p>
            ) : (
                <a href="#" onClick={handleClick} className="btn-app-clip">Launch AR Experience</a>
            )}
        </div>
    </div>
}

export { NonAppLauncher }
