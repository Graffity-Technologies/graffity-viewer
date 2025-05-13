const defaultUrl = "https://appclip.apple.com/id?p=app.graffity.ar-viewer.Clip"

function iOS() {
    return /iPad|iPhone|iPod/.test(navigator.userAgent)
}

const NonAppLauncher = () => {
    // if (!iOS()) return <></>
    // TODO: add web sdk launcher here

    const path = window.location.pathname
    const token = path.split("/")[2]
    const urlParams = new URLSearchParams(window.location.search);
    urlParams.set('token', token)

    // const link = defaultUrl + "&" + urlParams.toString()
    const link = window.location.href

    return <div>
        <p>or</p>
        <div style={{ marginTop: "25px" }}>
            <a href={link} target="_blank" className="btn-app-clip">Launch AR Experience</a>
        </div>
    </div>
}

export { NonAppLauncher }
