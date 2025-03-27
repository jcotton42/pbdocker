$release = Invoke-RestMethod -Headers @{'Accept' = 'application/vnd.github+json'; 'X-GitHub-Api-Version' = '2022-11-28' } 'https://api.github.com/repos/mvdicarlo/postybirb-plus/releases/latest'
$asset = $release.assets | Where-Object name -like *.appimage

if (-not $asset) { throw "Could not find AppImage on latest release." }

Invoke-WebRequest $asset.browser_download_url -OutFile postybirb-plus.AppImage
docker build -t jcotton42/my-postybirb:latest -t jcotton42/my-postybirb:$($release.name) .
