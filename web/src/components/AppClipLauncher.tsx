const defaultUrl = "https://appclip.apple.com/id?p=app.graffity.ar-viewer.Clip"

function iOS() {
    return /iPad|iPhone|iPod/.test(navigator.userAgent)
}

const AppClipLauncher = () => {
    if (!iOS) return <></>

    const path = window.location.pathname
    const token = path.split("/")[2]
    const urlParams = new URLSearchParams(window.location.search);
    const lat = urlParams.get('lat');
    const long = urlParams.get('long');

    const link = defaultUrl + "&token=" + token + "&lat=" + lat?.toString() + "&long" + long?.toString

    return <div style={{ marginTop: "20px" }}><a href={link} className="btn-app-clip">Launch App Clip</a></div>
}

export { AppClipLauncher }
